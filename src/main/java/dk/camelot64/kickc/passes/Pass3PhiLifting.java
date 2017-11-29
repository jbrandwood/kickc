package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Perform PhiLifting to greatly reduce overlapping of alive intervals for variables.
 *
 * After phi lifting it is guaranteed that variables in different phi blocks are in different live range equivalence classes.
 * <p>
 * PhiLifting introduces a large number of new virtual variables (one for each rvalue in phi-functions).
 * Most of these are eliminated again by the PhiMemCoalesce pass.
 * <p>
 * See http://compilers.cs.ucla.edu/fernando/projects/soc/reports/short_tech.pdf
 */
public class Pass3PhiLifting {

   private final Program program;

   public Pass3PhiLifting(Program program) {
      this.program = program;
   }

   public void perform() {
      ControlFlowGraph graph = program.getGraph();
      ProgramScope programScope = program.getScope();
      Collection<ControlFlowBlock> blocks = graph.getAllBlocks();
      for (ControlFlowBlock block : blocks) {
         // Maps old predecessors to new blocks created
         Map<LabelRef, LabelRef> newBlocks = new HashMap<>();
         if (block.hasPhiBlock()) {
            StatementPhiBlock phiBlock = block.getPhiBlock();
            for (StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
               for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                  if (!(phiRValue.getrValue() instanceof ConstantValue)) {
                     LabelRef predecessorRef = phiRValue.getPredecessor();
                     ControlFlowBlock predecessorBlock = graph.getBlock(predecessorRef);
                     VariableRef rValVarRef = (VariableRef) phiRValue.getrValue();
                     Variable newVar;
                     if(rValVarRef.isVersion()) {
                        Variable rValVar = program.getScope().getVariable(rValVarRef);
                        newVar = ((VariableVersion) rValVar).getVersionOf().createVersion();
                     } else {
                        Symbol predecessorSymbol = programScope.getSymbol(predecessorRef);
                        newVar = predecessorSymbol.getScope().addVariableIntermediate();
                     }
                     Symbol phiLValue = programScope.getSymbol(phiVariable.getVariable());
                     newVar.setType(phiLValue.getType());
                     newVar.setInferredType(true);
                     List<Statement> predecessorStatements = predecessorBlock.getStatements();
                     Statement lastPredecessorStatement = predecessorStatements.get(predecessorStatements.size() - 1);
                     StatementAssignment newAssignment = new StatementAssignment(newVar, phiRValue.getrValue());
                     if (lastPredecessorStatement instanceof StatementConditionalJump) {
                        // Use or Create a new block between the predecessor and this one - getReplacement labels where appropriate
                        ControlFlowBlock newBlock;
                        LabelRef newBlockRef = newBlocks.get(predecessorRef);
                        if(newBlockRef==null) {
                           // Create new block
                           LabelRef currentBlockLabel = block.getLabel();
                           Scope currentScope = programScope.getSymbol(currentBlockLabel).getScope();
                           Label newBlockLabel = currentScope.addLabelIntermediate();
                           newBlock = new ControlFlowBlock(newBlockLabel.getRef(), currentScope.getRef());
                           graph.addBlock(newBlock);
                           newBlock.setDefaultSuccessor(block.getLabel());
                           newBlocks.put(predecessorRef, newBlock.getLabel());
                           StatementConditionalJump previousConditionalJump = (StatementConditionalJump) lastPredecessorStatement;
                           LabelRef previousConditionalDestination = previousConditionalJump.getDestination();
                           if(block.getLabel().equals(previousConditionalDestination)) {
                              previousConditionalJump.setDestination(newBlock.getLabel());
                              predecessorBlock.setConditionalSuccessor(newBlock.getLabel());
                           }
                           if(block.getLabel().equals(predecessorBlock.getDefaultSuccessor())) {
                              predecessorBlock.setDefaultSuccessor(newBlock.getLabel());
                           }
                           program.getLog().append("Added new block during phi lifting "+newBlock.getLabel() + "(between "+predecessorRef+" and "+block.getLabel()+")");
                        }  else {
                           newBlock = graph.getBlock(newBlockRef);
                        }
                        List<Statement> newBlockStatements = newBlock.getStatements();
                        newBlockStatements.add(newAssignment);
                        phiRValue.setrValue(newVar.getRef());
                        phiRValue.setPredecessor(newBlock.getLabel());
                     } else if(block.getLabel().equals(predecessorBlock.getCallSuccessor())) {
                        predecessorBlock.addStatementBeforeCall(newAssignment);
                        phiRValue.setrValue(newVar.getRef());
                     } else {
                        predecessorBlock.addStatement(newAssignment);
                        phiRValue.setrValue(newVar.getRef());
                     }
                  }
               }
            }
         }
      }
   }

}
