package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.LabelRef;

import java.util.*;

/**
 * Perform PhiLifting to greatly reduce overlapping of alive intervals for variables.
 * <p>
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
      for(var procedureCompilation : program.getProcedureCompilations()) {
         upliftProcedure(procedureCompilation);
      }
   }

   private void upliftProcedure(ProcedureCompilation procedureCompilation) {
      final ControlFlowGraph graph = procedureCompilation.getGraph();
      List<Graph.Block> liftedBlocks = new ArrayList<>(graph.getAllBlocks());
      ProgramScope programScope = program.getScope();
      ListIterator<Graph.Block> blocksIt = liftedBlocks.listIterator();
      while(blocksIt.hasNext()) {
         Graph.Block block = blocksIt.next();
         // Maps old predecessors to new blocks created
         Map<LabelRef, LabelRef> newBlocks = new HashMap<>();
         if(block.hasPhiBlock()) {
            StatementPhiBlock phiBlock = block.getPhiBlock();
            for(StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
               for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                  if(!(phiRValue.getrValue() instanceof ConstantValue)) {
                     LabelRef predecessorRef = phiRValue.getPredecessor();
                     Graph.Block predecessorBlock = getBlock(liftedBlocks, predecessorRef);
                     if(predecessorBlock==null) {
                        // Look for the predecessor in the entire graph
                        predecessorBlock = program.getGraph().getBlock(predecessorRef);
                     }
                     //VariableRef rValVarRef = (VariableRef) phiRValue.getrValue();
                     Variable newVar;
                     if(phiVariable.getVariable().isVersion()) {
                        Symbol phiLValue = programScope.getSymbol(phiVariable.getVariable());
                        Variable lValVar = program.getScope().getVariable(phiVariable.getVariable());
                        newVar = lValVar.getPhiMaster().createVersion();
                        newVar.setType(phiLValue.getType());
                     } else {
                        Symbol phiLValue = programScope.getSymbol(phiVariable.getVariable());
                        Variable lValVar = program.getScope().getVariable(phiVariable.getVariable());
                        newVar = VariableBuilder.createIntermediate(lValVar.getScope(), lValVar.getType(), program);
                     }
                     List<Statement> predecessorStatements = predecessorBlock.getStatements();
                     Statement lastPredecessorStatement = null;
                     if(predecessorStatements.size() > 0) {
                        lastPredecessorStatement = predecessorStatements.get(predecessorStatements.size() - 1);
                     }
                     StatementAssignment newAssignment = new StatementAssignment((LValue) newVar.getRef(), phiRValue.getrValue(), false, phiBlock.getSource(), Comment.NO_COMMENTS);
                     if(lastPredecessorStatement instanceof StatementConditionalJump) {
                        // Use or Create a new block between the predecessor and this one - replace labels where appropriate
                        Graph.Block newBlock;
                        LabelRef newBlockRef = newBlocks.get(predecessorRef);
                        if(newBlockRef == null) {
                           // Create new block
                           LabelRef currentBlockLabel = block.getLabel();
                           Scope currentScope = programScope.getSymbol(currentBlockLabel).getScope();
                           Label newBlockLabel = currentScope.addLabelIntermediate();
                           newBlock = new ControlFlowBlock(newBlockLabel.getRef(), currentScope.getRef());
                           blocksIt.add(newBlock);
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
                           program.getLog().append("Added new block during phi lifting " + newBlock.getLabel() + "(between " + predecessorRef + " and " + block.getLabel() + ")");
                        } else {
                           newBlock = getBlock(liftedBlocks, newBlockRef);
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
            if(newBlocks.size() > 0) {
               // If new blocks have been inserted: Update the predecessors of all phi values
               for(StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
                  for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                     LabelRef predecessor = phiRValue.getPredecessor();
                     LabelRef newBlock = newBlocks.get(predecessor);
                     if(newBlock != null) {
                        phiRValue.setPredecessor(newBlock);
                        program.getLog().append("Fixing phi predecessor for " + phiVariable.getVariable().toString() +
                              " to new block ( " + predecessor.toString() + " -> " + newBlock.toString() + " ) " +
                              "during phi lifting.");
                     }
                  }
               }
            }
         }
      }

      // Update the procedure with the PHI-lifted blocks
      procedureCompilation.setGraph(new ControlFlowGraph(liftedBlocks));

   }

   private Graph.Block getBlock(List<Graph.Block> blocks, LabelRef blockRef) {
      return blocks.stream().filter(block -> block.getLabel().equals(blockRef)).findFirst().orElse(null);
   }

}
