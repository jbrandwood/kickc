package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.StatementInfos;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.symbols.VariableVersion;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;

/**
 * Prepare for unrolling loops declared as inline.
 * This is done byensuring that all variables defined inside the loops and used outside the loop is passed through a PHI-functions
 * upon loop exit thus ensuring that these variables are only used inside the loop and in the PHI-function.
 * This makes it much easier to perform the unrolling as only a few parts of the program must be modified.
 */
public class Pass2LoopUnrollPhiPrepare extends Pass2SsaOptimization {

   public Pass2LoopUnrollPhiPrepare(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      // Look for loops to unroll
      NaturalLoopSet loops = getProgram().getLoopSet();
      List<NaturalLoop> unrollLoopCandidates = Pass2LoopUnroll.findUnrollLoopCandidates(getProgram(), loops);
      // Is there any unrolling to do?
      if(unrollLoopCandidates.isEmpty()) {
         return false;
      }


      for(NaturalLoop unrollLoop : unrollLoopCandidates) {

         List<VariableRef> definedInLoop = Pass2LoopUnroll.getVarsDefinedInLoop(getProgram(), unrollLoop);
         // - Ensure that all variables assigned inside the loop has a PHI in successor blocks to the loop
         //   - Find loop successor blocks
         List<Pass2LoopUnroll.LoopSuccessorBlock> loopSuccessors = Pass2LoopUnroll.getLoopSuccessorBlocks(unrollLoop, getGraph());
         //   - Add any needed PHI-statements to the successors
         for(VariableRef definedVarRef : definedInLoop) {
            // Find out if the variable is ever referenced outside the loop
            if(isReferencedOutsideLoop(definedVarRef, unrollLoop, getProgram())) {
               for(Pass2LoopUnroll.LoopSuccessorBlock loopSuccessor : loopSuccessors) {
                  LabelRef successorBlockRef = loopSuccessor.sucessor;
                  LabelRef successorPredecessorRef = loopSuccessor.predecessor;
                  ControlFlowBlock successorBlock = getGraph().getBlock(successorBlockRef);
                  StatementPhiBlock phiBlock = successorBlock.getPhiBlock();

                  // Look for a phi-variable
                  boolean phiFound = false;
                  for(StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
                     if(phiVariable.getVariable().isVersion() && definedVarRef.isVersion()) {
                        if(phiVariable.getVariable().getFullNameUnversioned().equals(definedVarRef.getFullNameUnversioned())) {
                           phiFound = true;
                        }
                     }
                  }
                  if(!phiFound) {
                     Variable definedVar = getScope().getVariable(definedVarRef);
                     Variable newVar = ((VariableVersion) definedVar).getVersionOf().createVersion();

                     // Replace all references to definedVarRef outside loop to newVar!
                     LinkedHashMap<SymbolRef, RValue> aliases = new LinkedHashMap<>();
                     aliases.put(definedVarRef, newVar.getRef());
                     ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
                        if(currentBlock != null) {
                           if(!unrollLoop.getBlocks().contains(currentBlock.getLabel())) {
                              new AliasReplacer(aliases).execute(programValue, currentStmt, stmtIt, currentBlock);
                           }
                        }
                     });

                     // Create the new phi-variable
                     StatementPhiBlock.PhiVariable newPhiVar = phiBlock.addPhiVariable(newVar.getRef());
                     newPhiVar.setrValue(successorPredecessorRef, definedVarRef);
                     getLog().append("Creating PHI for " + definedVarRef.getFullName() + " in block " + successorBlock.getLabel() + " - " + phiBlock.toString(getProgram(), false));

                  }
               }
            }
         }
      }
      getLog().append(getGraph().toString(getProgram()));
      return false;
   }

   private static boolean isReferencedOutsideLoop(VariableRef definedVarRef, NaturalLoop unrollLoop, Program program) {
      boolean referencedOutsideLoop = false;
      VariableReferenceInfos variableReferenceInfos = program.getVariableReferenceInfos();
      Collection<Integer> varRefStatements = variableReferenceInfos.getVarRefStatements(definedVarRef);
      for(Integer varRefStatement : varRefStatements) {
         StatementInfos statementInfos = program.getStatementInfos();
         ControlFlowBlock refBlock = statementInfos.getBlock(varRefStatement);
         if(!unrollLoop.getBlocks().contains(refBlock.getLabel())) {
            referencedOutsideLoop = true;
            break;
         }
      }
      return referencedOutsideLoop;
   }


}
