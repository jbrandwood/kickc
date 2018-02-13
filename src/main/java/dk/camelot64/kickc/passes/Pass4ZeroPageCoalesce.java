package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.Collection;
import java.util.List;

/**
 * Coalesces zero page registers where their live ranges do not overlap.
 * A final step done after all other register optimizations and before ASM generation.
 */
public class Pass4ZeroPageCoalesce extends Pass2Base {


   public Pass4ZeroPageCoalesce(Program program) {
      super(program);
   }

   public void allocate() {
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      boolean change;
      do {
         change = coalesce(liveRangeEquivalenceClassSet);
      } while(change);

   }

   /**
    * Find two equivalence classes that can be coalesced into one - and perform the coalescence.
    *
    * @param liveRangeEquivalenceClassSet The set of live range equivalence classes
    * @return true if any classes were coalesced. False otherwise.
    */
   private boolean coalesce(LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet) {

      double maxScore = -1.0;
      LiveRangeEquivalenceClass maxThis = null;
      LiveRangeEquivalenceClass maxOther = null;

      for(LiveRangeEquivalenceClass thisEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         for(LiveRangeEquivalenceClass otherEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
            if(!thisEquivalenceClass.equals(otherEquivalenceClass)) {
               if(canCoalesce(thisEquivalenceClass, otherEquivalenceClass)) {
                  double coalesceScore = getCoalesceScore(thisEquivalenceClass, otherEquivalenceClass);
                  if(coalesceScore>maxScore) {
                     if(otherEquivalenceClass==null) {
                        throw new RuntimeException("EQC is null!"+otherEquivalenceClass);
                     }
                     maxScore = coalesceScore;
                     maxThis = thisEquivalenceClass;
                     maxOther = otherEquivalenceClass;
                  }
               }
            }
         }
      }

      if(maxOther!=null) {
         getLog().append("Coalescing zero page register [ " + maxThis+ " ] with [ " + maxOther + " ]");
         liveRangeEquivalenceClassSet.consolidate(maxThis, maxOther);
         // Reset the program register allocation
         getProgram().getLiveRangeEquivalenceClassSet().storeRegisterAllocation();
         return true;
      }

      return false;
   }

   private double getCoalesceScore(LiveRangeEquivalenceClass thisEquivalenceClass, LiveRangeEquivalenceClass otherEquivalenceClass) {
      double score = 0.0;
      List<VariableRef> thisClassVars = thisEquivalenceClass.getVariables();
      List<VariableRef> otherClassVars = otherEquivalenceClass.getVariables();
      VariableReferenceInfos variableReferenceInfos = getProgram().getVariableReferenceInfos();
      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            Collection<VariableRef> definedVars = variableReferenceInfos.getDefinedVars(statement);
            Collection<VariableRef> usedVars = variableReferenceInfos.getUsedVars(statement);
            if(definedVars!=null && definedVars.size()>0) {
               for(VariableRef definedVar : definedVars) {
                  if(thisClassVars.contains(definedVar)) {
                     for(VariableRef usedVar : usedVars) {
                        if(otherClassVars.contains(usedVar)) {
                           score += 1.0;
                        }
                     }
                  } else if(otherClassVars.contains(definedVar)) {
                     for(VariableRef usedVar : usedVars) {
                        if(thisClassVars.contains(usedVar)) {
                           score += 1.0;
                        }
                     }
                  }
               }
            }
         }
      }
      return score;
   }

   private boolean canCoalesce(LiveRangeEquivalenceClass myEquivalenceClass, LiveRangeEquivalenceClass otherEquivalenceClass) {
      VariableRef myVariableRef = myEquivalenceClass.getVariables().get(0);
      Variable myVariable = getProgram().getSymbolInfos().getVariable(myVariableRef);
      VariableRef otherVariableRef = otherEquivalenceClass.getVariables().get(0);
      Variable otherVariable = getProgram().getSymbolInfos().getVariable(otherVariableRef);
      // Types match
      Registers.Register myRegister = myEquivalenceClass.getRegister();
      Registers.Register otherRegister = otherEquivalenceClass.getRegister();
      if(myRegister.isZp() && otherRegister.isZp()) {
         // Both registers are on Zero Page

         if(myRegister.getType().equals(otherRegister.getType())) {
            // Both registers have the same Zero Page size

            // Reset the program register allocation to the one specified in the equivalence class set
            getProgram().getLiveRangeEquivalenceClassSet().storeRegisterAllocation();
            // Try out the coalesce to test if it works
            for(VariableRef var : otherEquivalenceClass.getVariables()) {
               Variable variable = getProgram().getSymbolInfos().getVariable(var);
               variable.setAllocation(myRegister);
            }
            if(!Pass4RegisterUpliftCombinations.isAllocationOverlapping(getProgram())) {
               // Live ranges do not overlap
               // Perform coalesce!
               return true;
            }
         }
      }
      return false;
   }

}
