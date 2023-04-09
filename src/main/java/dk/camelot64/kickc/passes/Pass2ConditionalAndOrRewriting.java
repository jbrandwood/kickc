package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashMap;

/**
 * Compiler Pass rewriting conditional jumps that use && or || operators
 */
public class Pass2ConditionalAndOrRewriting extends Pass2SsaOptimization {

   public Pass2ConditionalAndOrRewriting(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean modified = false;
      for(ProcedureCompilation procedureCompilation : getProgram().getProcedureCompilations()) {
         modified |= findAndRewriteBooleanConditions(procedureCompilation.getGraph());
      }
      return modified;
   }

   private boolean findAndRewriteBooleanConditions(Graph graph) {
      boolean done = false;
      boolean modified = false;
      while(!done) {
         VariableRef obsoleteConditionVar = findAndRewriteBooleanCondition(graph);
         if(obsoleteConditionVar != null) {
            Collection<VariableRef> obsoleteVars = new ArrayList<>();
            obsoleteVars.add(obsoleteConditionVar);
            removeAssignments(graph, obsoleteVars);
            deleteSymbols(getProgramScope(), obsoleteVars);
            modified = true;
         } else {
            done = true;
         }
      }
      return modified;
   }

   /**
    * Look through a control flow graph looking for an if() condition that uses &&, || or !.
    * When found rewrite it (adding blocks)
    *
    * @return Null if no condition was found to rewrite. The now obsolete variable containing the && / || / ! to be removed.
    * @param graph The control flow graph to modify
    */
   private VariableRef findAndRewriteBooleanCondition(Graph graph) {
      final VariableReferenceInfos variableReferenceInfos = getProgram().getVariableReferenceInfos();
      for(var block : graph.getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementConditionalJump conditional) {
               if(conditional.getrValue1() == null && conditional.getOperator() == null) {
                  RValue conditionRValue = conditional.getrValue2();
                  if(conditionRValue instanceof VariableRef) {
                     final int conditionRValueUsages = variableReferenceInfos.getVarUseStatements((VariableRef) conditionRValue).size();
                     if(conditionRValueUsages == 1) {
                        VariableRef conditionVar = (VariableRef) conditionRValue;
                        final Integer conditionDefineStatementIdx = variableReferenceInfos.getVarDefineStatement(conditionVar);
                        if(conditionDefineStatementIdx != null) {
                           final Statement conditionDefineStatement = graph.getStatementByIndex(conditionDefineStatementIdx);
                           if(conditionDefineStatement instanceof StatementAssignment conditionAssignment) {
                              if(Operators.LOGIC_AND.equals(conditionAssignment.getOperator())) {
                                 // Found if() with logical && condition - rewrite to if(c1) if(c2) { xx }
                                 rewriteLogicAnd(block, conditional, conditionAssignment, getGraph());
                                 return conditionVar;
                              } else if(Operators.LOGIC_OR.equals(conditionAssignment.getOperator())) {
                                 // Found if() with logical || condition - rewrite to if(c1) goto x else if(c2) goto x else goto end, x:{ xx } end:
                                 rewriteLogicOr(block, conditional, conditionAssignment, getGraph());
                                 return conditionVar;
                              } else if(Operators.LOGIC_NOT.equals(conditionAssignment.getOperator())) {
                                 // Found if() with logical ! condition - rewrite to if(!c1) goto x else goto end, x:{ xx } end:
                                 rewriteLogicNot(block, conditional, conditionAssignment);
                                 return conditionVar;
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      return null;
   }

   /**
    * Rewrite logical && condition if(c1&&c2) { xx } to if(c1) if(c2) { xx }
    *
    * @param block The block containing the current if()
    * @param conditional The if()-statement
    * @param conditionAssignment The assignment defining the condition variable.
    * @param graph The control flow graph to modify
    */
   private void rewriteLogicAnd(Graph.Block block, StatementConditionalJump conditional, StatementAssignment conditionAssignment, Graph graph) {
      // Found an if with a logical && condition - rewrite to if(c1) if(c2) { xx }
      getLog().append("Rewriting && if()-condition to two if()s " + conditionAssignment.toString(getProgram(), false));
      ScopeRef currentScopeRef = block.getScope();
      Scope currentScope = getProgramScope().getScope(currentScopeRef);
      // Add a new block containing the second part of the && condition expression
      Label newBlockLabel = currentScope.addLabelIntermediate();
      ControlFlowBlock newBlock = new ControlFlowBlock(newBlockLabel.getRef(), currentScopeRef);
      graph.addBlock(newBlock);
      LabelRef destLabel = conditional.getDestination();
      StatementConditionalJump newConditional = new StatementConditionalJump(conditionAssignment.getrValue2(), destLabel, conditional.getSource(), Comment.NO_COMMENTS);
      newConditional.setDeclaredUnroll(conditional.isDeclaredUnroll());
      newBlock.getStatements().add(newConditional);
      newBlock.setDefaultSuccessor(block.getDefaultSuccessor());
      newBlock.setConditionalSuccessor(destLabel);
      // Rewrite the conditional to use only the first part of the && condition expression
      conditional.setDestination(newBlockLabel.getRef());
      block.setConditionalSuccessor(newBlockLabel.getRef());
      conditional.setrValue2(conditionAssignment.getrValue1());

      // Replace the phi labels inside the destination block with the new block
      Graph.Block destBlock = graph.getBlock(destLabel);
      LinkedHashMap<LabelRef, LabelRef> replacements = new LinkedHashMap<>();
      replacements.put(block.getLabel(), newBlockLabel.getRef());
      replaceLabels(destBlock.getPhiBlock(), replacements);

   }

   /**
    * Rewrite logical || condition if(c1||c2) { xx } to if(c1) goto x else if(c2) goto x else goto end, x:{ xx } end:
    *
    * @param block The block containing the current if()
    * @param conditional The if()-statement
    * @param conditionAssignment The assignment defining the condition variable.
    * @param graph The control flow graph to modify
    */
   private void rewriteLogicOr(Graph.Block block, StatementConditionalJump conditional, StatementAssignment conditionAssignment, Graph graph) {
      getLog().append("Rewriting || if()-condition to two if()s " + conditionAssignment.toString(getProgram(), false));
      ScopeRef currentScopeRef = block.getScope();
      Scope currentScope = getProgramScope().getScope(currentScopeRef);
      // Add a new block containing the second part of the && condition expression
      Label newBlockLabel = currentScope.addLabelIntermediate();
      ControlFlowBlock newBlock = new ControlFlowBlock(newBlockLabel.getRef(), currentScopeRef);
      graph.addBlock(newBlock);
      StatementConditionalJump newConditional = new StatementConditionalJump(conditionAssignment.getrValue2(), conditional.getDestination(), conditional.getSource(), Comment.NO_COMMENTS);
      // Copy unrolling to the new conditional
      newConditional.setDeclaredUnroll(conditional.isDeclaredUnroll());
      newBlock.getStatements().add(newConditional);
      newBlock.setConditionalSuccessor(conditional.getDestination());
      newBlock.setDefaultSuccessor(block.getDefaultSuccessor());
      // Rewrite the conditional to use only the first part of the && condition expression
      block.setDefaultSuccessor(newBlockLabel.getRef());
      conditional.setrValue2(conditionAssignment.getrValue1());
      // Remove any unrolling from the original conditional as only the new one leaves the loop
      conditional.setDeclaredUnroll(false);

      // Update the default destination PHI block to reflect the last of the conditions
      Graph.Block defaultDestBlock = graph.getBlock(newBlock.getDefaultSuccessor());
      if(defaultDestBlock.hasPhiBlock()) {
         StatementPhiBlock defaultDestPhiBlock = defaultDestBlock.getPhiBlock();
         for(StatementPhiBlock.PhiVariable phiVariable : defaultDestPhiBlock.getPhiVariables()) {
            for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
               if(phiRValue.getPredecessor().equals(block.getLabel())) {
                  // Found phi-variable with current block as predecessor - change the predecessor
                  phiRValue.setPredecessor(newBlock.getLabel());
               }
            }
         }
      }

      Graph.Block conditionalDestBlock = graph.getBlock(conditional.getDestination());
      if(conditionalDestBlock.hasPhiBlock()) {
         StatementPhiBlock conditionalDestPhiBlock = conditionalDestBlock.getPhiBlock();
         for(StatementPhiBlock.PhiVariable phiVariable : conditionalDestPhiBlock.getPhiVariables()) {
            for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
               if(phiRValue.getPredecessor().equals(block.getLabel())) {
                  // Found phi-variable with current block as predecessor - copy the phi-value for the new block
                  phiVariable.setrValue(newBlockLabel.getRef(), phiRValue.getrValue());
                  break;
               }
            }
         }
      }

   }

   /**
    * Rewrite logical ! condition if(!c1) { xx } to if(c1) goto end else goto x, x:{ xx } end:
    *
    * @param block The block containing the current if()
    * @param conditional The if()-statement
    * @param conditionAssignment The assignment defining the condition variable.
    */
   private void rewriteLogicNot(Graph.Block block, StatementConditionalJump conditional, StatementAssignment conditionAssignment) {
      getLog().append("Rewriting ! if()-condition to reversed if() " + conditionAssignment.toString(getProgram(), false));
      // Rewrite the conditional to use only the first part of the && condition expression
      LabelRef defaultSuccessor = block.getDefaultSuccessor();
      LabelRef conditionalSuccessor = block.getConditionalSuccessor();
      // Change condition (to the non-negated condition)
      conditional.setrValue2(conditionAssignment.getrValue2());
      // Swap successors
      conditional.setDestination(defaultSuccessor);
      block.setConditionalSuccessor(defaultSuccessor);
      block.setDefaultSuccessor(conditionalSuccessor);
   }

}
