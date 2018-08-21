package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementInfos;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.symbols.VariableVersion;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.*;

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

      VariableReferenceInfos variableReferenceInfos = getProgram().getVariableReferenceInfos();

      for(NaturalLoop unrollLoop : unrollLoopCandidates) {


         List<ControlFlowBlock> unrollBlocks = new ArrayList<>();
         for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
            if(unrollLoop.getBlocks().contains(block.getLabel())) {
               unrollBlocks.add(block);
            }
         }

         List<VariableRef> definedInLoop = new ArrayList<>();
         for(ControlFlowBlock block : unrollBlocks) {
            for(Statement statement : block.getStatements()) {
               Collection<VariableRef> definedVars = variableReferenceInfos.getDefinedVars(statement);
               for(VariableRef definedVarRef : definedVars) {
                  definedInLoop.add(definedVarRef);
                  getLog().append("Defined in loop: " + definedVarRef.getFullName());
               }
            }
         }

         // - Ensure that all variables assigned inside the loop has a PHI in successor blocks to the loop
         //   - Find loop successor blocks
         List<LabelRef> loopSuccessors = new ArrayList<>();
         List<LabelRef> loopSuccessorPredecessors = new ArrayList<>();
         for(ControlFlowBlock block : unrollBlocks) {
            if(block.getDefaultSuccessor() != null && !unrollLoop.getBlocks().contains(block.getDefaultSuccessor())) {
               // Default successor is outside
               loopSuccessors.add(block.getDefaultSuccessor());
               loopSuccessorPredecessors.add(block.getLabel());
            }
            if(block.getConditionalSuccessor() != null && !unrollLoop.getBlocks().contains(block.getConditionalSuccessor())) {
               // Default successor is outside
               loopSuccessors.add(block.getConditionalSuccessor());
               loopSuccessorPredecessors.add(block.getLabel());
            }
         }
         //   - Add any needed PHI-statements to the successors
         StatementInfos statementInfos = getProgram().getStatementInfos();
         for(VariableRef definedVarRef : definedInLoop) {

            // Find out if the variable is ever referenced outside the loop
            boolean referencedOutsideLoop = false;
            Collection<Integer> varRefStatements = variableReferenceInfos.getVarRefStatements(definedVarRef);
            for(Integer varRefStatement : varRefStatements) {
               ControlFlowBlock refBlock = statementInfos.getBlock(varRefStatement);
               if(!unrollLoop.getBlocks().contains(refBlock.getLabel())) {
                  referencedOutsideLoop = true;
                  break;
               }
            }
            if(referencedOutsideLoop) {
               for(int i = 0; i < loopSuccessors.size(); i++) {
                  LabelRef successorBlockRef = loopSuccessors.get(i);
                  LabelRef successorPredecessorRef = loopSuccessorPredecessors.get(i);
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
                     StatementPhiBlock.PhiVariable newPhiVar = phiBlock.addPhiVariable(newVar.getRef());
                     newPhiVar.setrValue(successorPredecessorRef, definedVarRef);
                     getLog().append("Missing PHI for " + definedVarRef.getFullName() + " in block " + successorBlock.getLabel() + " - " + phiBlock.toString(getProgram(), false));

                     // TODO: Replace all references to definedVarRef outside loop to newVar!

                  }
               }
            }
         }

      }

      getLog().append(getGraph().toString(getProgram()));

      return false;

   }

}
