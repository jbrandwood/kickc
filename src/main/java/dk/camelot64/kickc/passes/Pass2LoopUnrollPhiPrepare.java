package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.NaturalLoop;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.symbols.VariableVersion;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.LinkedHashMap;

/**
 * Prepare for unrolling loops declared as inline.
 * This is done by ensuring that all variables defined inside the loops and used outside the loop is passed through a PHI-functions
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
      for(NaturalLoop unrollLoop : Pass2LoopUnroll.findUnrollLoops(getProgram())) {
         // - Ensure that all variables assigned inside the loop has a PHI in successor blocks to the loop
         for(VariableRef definedVarRef : Pass2LoopUnroll.getVarsDefinedInLoop(unrollLoop, getProgram())) {
            // Find out if the variable is ever referenced outside the loop
            if(Pass2LoopUnroll.isReferencedOutsideLoop(definedVarRef, unrollLoop, getProgram())) {
               //   - Add any needed PHI-statements to the successors
               for(Pass2LoopUnroll.LoopSuccessorBlock loopSuccessor : Pass2LoopUnroll.getLoopSuccessorBlocks(unrollLoop, getGraph())) {

                  LabelRef successorBlockRef = loopSuccessor.successor;
                  LabelRef successorPredecessorRef = loopSuccessor.predecessor;
                  ControlFlowBlock successorBlock = getGraph().getBlock(successorBlockRef);
                  StatementPhiBlock phiBlock = successorBlock.getPhiBlock();

                  // Create a new version of the variable
                  Variable definedVar = getScope().getVariable(definedVarRef);
                  Variable newVar = ((VariableVersion) definedVar).getVersionOf().createVersion();

                  // Replace all references outside the loop to the new version!
                  LinkedHashMap<SymbolRef, RValue> aliases = new LinkedHashMap<>();
                  aliases.put(definedVarRef, newVar.getRef());
                  ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
                     if(currentBlock != null) {
                        if(!unrollLoop.getBlocks().contains(currentBlock.getLabel())) {
                           new AliasReplacer(aliases).execute(programValue, currentStmt, stmtIt, currentBlock);
                        }
                     }
                  });

                  // Create the new phi-variable in the successor phi block
                  StatementPhiBlock.PhiVariable newPhiVar = phiBlock.addPhiVariable(newVar.getRef());
                  newPhiVar.setrValue(successorPredecessorRef, definedVarRef);
                  getLog().append("Creating PHI for " + definedVarRef.getFullName() + " in block " + successorBlock.getLabel() + " - " + phiBlock.toString(getProgram(), false));

               }
            }
         }
      }
      return false;
   }


}
