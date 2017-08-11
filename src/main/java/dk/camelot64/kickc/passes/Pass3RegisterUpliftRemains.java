package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.AsmFragment;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.asm.AsmSegment;
import dk.camelot64.kickc.icl.*;

import java.util.*;

/*** For eac non-uplifted equivalence class attempt to put it in a register */
public class Pass3RegisterUpliftRemains extends Pass2Base {

   public Pass3RegisterUpliftRemains(Program program) {
      super(program);
   }

   public void performUplift() {

      LiveRangeEquivalenceClassSet equivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      List<LiveRangeEquivalenceClass> equivalenceClasses = new ArrayList<>(equivalenceClassSet.getEquivalenceClasses());
      final VariableRegisterWeights registerWeights = getProgram().getVariableRegisterWeights();
      Collections.sort(equivalenceClasses, new Comparator<LiveRangeEquivalenceClass>() {
         @Override
         public int compare(LiveRangeEquivalenceClass o1, LiveRangeEquivalenceClass o2) {
            return Double.compare(registerWeights.getTotalWeight(o2), registerWeights.getTotalWeight(o1));
         }
      });

      Set<String> unknownFragments = new LinkedHashSet<>();

      for (LiveRangeEquivalenceClass equivalenceClass : equivalenceClasses) {
         if (equivalenceClass.getRegister().getType().equals(RegisterAllocation.RegisterType.ZP_BYTE)) {
            int bestScore = Integer.MAX_VALUE;
            RegisterCombination bestCombination = null;
            RegisterCombinationIterator combinationIterator = new RegisterCombinationIterator(Arrays.asList(equivalenceClass), getProgram().getRegisterPotentials());

            while (combinationIterator.hasNext()) {
               RegisterCombination combination = combinationIterator.next();
               // Reset register allocation to original zero page allocation
               new Pass3RegistersFinalize(getProgram()).allocate(false);
               // Apply the uplift combination
               combination.allocate(getProgram().getAllocation());
               // Generate ASM
               try {
                  new Pass3CodeGeneration(getProgram()).generate();
               } catch (AsmFragment.UnknownFragmentException e) {
                  unknownFragments.add(e.getFragmentSignature());
                  //StringBuilder msg = new StringBuilder();
                  //msg.append("Uplift remains attempt [" + equivalenceClass + "] ");
                  //msg.append("missing fragment " + e.getFragmentSignature());
                  //msg.append(" allocation: ").append(combination.toString());
                  //getLog().append(msg.toString());
                  continue;
               } catch (AsmFragment.AluNotApplicableException e) {
                  //StringBuilder msg = new StringBuilder();
                  //msg.append("Uplift remains attempt [" + equivalenceClass + "] ");
                  //msg.append("alu not applicable");
                  //msg.append(" allocation: ").append(combination.toString());
                  //getLog().append(msg.toString());
                  continue;
               }
               // If no clobber - Find value of the resulting allocation
               boolean hasClobberProblem = new Pass3AssertNoCpuClobber(getProgram()).hasClobberProblem(false);
               int combinationScore = Pass3RegisterUpliftCombinations.getAsmScore(getProgram());
               //StringBuilder msg = new StringBuilder();
               //msg.append("Uplift remains attempt [" + equivalenceClass + "] ");
               //if (hasClobberProblem) {
               //   msg.append("clobber");
               //} else {
               //   msg.append(combinationScore);
               //}
               //msg.append(" allocation: ").append(combination.toString());
               //getLog().append(msg.toString());
               if (!hasClobberProblem) {
                  if (combinationScore < bestScore) {
                     bestScore = combinationScore;
                     bestCombination = combination;
                  }
               }
            }
            // Save the best combination in the equivalence class
            if(!bestCombination.getRegister(equivalenceClass).isZp()) {
               bestCombination.store(equivalenceClassSet);
               getLog().append("Uplifting remains [" + equivalenceClass + "] best " + bestScore + " combination " + bestCombination.toString());
            }

         }
      }

      if (unknownFragments.size() > 0) {
         getLog().append("MISSING FRAGMENTS");
         for (String unknownFragment : unknownFragments) {
            getLog().append("  " + unknownFragment);
         }
      }


   }

}
