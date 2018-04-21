package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.values.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * Compiler Pass rewriting conditional jumps that use && or || operators
 */
public class Pass2ConditionalAndOrRewriting extends Pass2SsaOptimization {

   public Pass2ConditionalAndOrRewriting(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      VariableRef obsoleteConditionVar = findAndRewriteBooleanCondition();
      if(obsoleteConditionVar!=null) {
         Collection<VariableRef> obsoleteVars = new ArrayList<>();
         obsoleteVars.add(obsoleteConditionVar);
         removeAssignments(obsoleteVars);
         deleteSymbols(obsoleteVars);
         return true;
      }  else {
         return false;
      }
   }

   /**
    * Look through the entire program looking for an if() condition that uses &&, || or !.
    * When found rewrite it (adding blocks)
    * @return Null if no condition was found to rewrite. The now obsolete variable containing the && / || / ! to be removed.
    */
   private VariableRef  findAndRewriteBooleanCondition() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         final Map<LValue, StatementAssignment> assignments = getAllAssignments();
         final Map<RValue, List<Statement>> usages = getAllUsages();
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementConditionalJump) {
               StatementConditionalJump conditional = (StatementConditionalJump) statement;
               if(conditional.getrValue1()==null && conditional.getOperator()==null) {
                  RValue conditionRValue = conditional.getrValue2();
                  if(conditionRValue instanceof VariableRef && usages.get(conditionRValue).size() == 1) {
                     VariableRef conditionVar = (VariableRef) conditionRValue;
                     StatementAssignment conditionAssignment = assignments.get(conditionVar);
                     if(Operators.LOGIC_AND.equals(conditionAssignment.getOperator())) {
                        // Found if() with logical && condition - rewrite to if(c1) if(c2) { xx }
                        rewriteLogicAnd(block, conditional, conditionAssignment);
                        return conditionVar;
                     } else if(Operators.LOGIC_OR.equals(conditionAssignment.getOperator())) {
                        // Found if() with logical || condition - rewrite to if(c1) goto x else if(c2) goto x else goto end, x:{ xx } end:
                        rewriteLogicOr(block, conditional, conditionAssignment);
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
      return null;
   }

   /**
    * Rewrite logical && condition if(c1&&c2) { xx } to if(c1) if(c2) { xx }
    * @param block The block containing the current if()
    * @param conditional The if()-statement
    * @param conditionAssignment The assignment defining the condition variable.
    */
   private void rewriteLogicAnd(ControlFlowBlock block, StatementConditionalJump conditional, StatementAssignment conditionAssignment) {
      // Found an if with a logical && condition - rewrite to if(c1) if(c2) { xx }
      getLog().append("Rewriting && if()-condition to two if()s "+conditionAssignment.toString(getProgram(), false));
      ScopeRef currentScopeRef = block.getScope();
      Scope currentScope = getScope().getScope(currentScopeRef);
      // Add a new block containing the second part of the && condition expression
      Label newBlockLabel = currentScope.addLabelIntermediate();
      ControlFlowBlock newBlock = new ControlFlowBlock(newBlockLabel.getRef(), currentScopeRef);
      getGraph().addBlock(newBlock);
      newBlock.getStatements().add(new StatementConditionalJump(conditionAssignment.getrValue2(), conditional.getDestination()));
      newBlock.setDefaultSuccessor(block.getDefaultSuccessor());
      newBlock.setConditionalSuccessor(conditional.getDestination());
      // Rewrite the conditional to use only the first part of the && condition expression
      conditional.setDestination(newBlockLabel.getRef());
      block.setConditionalSuccessor(newBlockLabel.getRef());
      conditional.setrValue2(conditionAssignment.getrValue1());
   }

   /**
    * Rewrite logical || condition if(c1&&c2) { xx } to if(c1) goto x else if(c2) goto x else goto end, x:{ xx } end:
    * @param block The block containing the current if()
    * @param conditional The if()-statement
    * @param conditionAssignment The assignment defining the condition variable.
    */
   private void rewriteLogicOr(ControlFlowBlock block, StatementConditionalJump conditional, StatementAssignment conditionAssignment) {
      getLog().append("Rewriting || if()-condition to two if()s "+conditionAssignment.toString(getProgram(), false));
      ScopeRef currentScopeRef = block.getScope();
      Scope currentScope = getScope().getScope(currentScopeRef);
      // Add a new block containing the second part of the && condition expression
      Label newBlockLabel = currentScope.addLabelIntermediate();
      ControlFlowBlock newBlock = new ControlFlowBlock(newBlockLabel.getRef(), currentScopeRef);
      getGraph().addBlock(newBlock);
      newBlock.getStatements().add(new StatementConditionalJump(conditionAssignment.getrValue2(), conditional.getDestination()));
      newBlock.setConditionalSuccessor(conditional.getDestination());
      newBlock.setDefaultSuccessor(block.getDefaultSuccessor());
      // Rewrite the conditional to use only the first part of the && condition expression
      block.setDefaultSuccessor(newBlockLabel.getRef());
      conditional.setrValue2(conditionAssignment.getrValue1());
   }

   /**
    * Rewrite logical ! condition if(!c1) { xx } to if(c1) goto end else goto x, x:{ xx } end:
    * @param block The block containing the current if()
    * @param conditional The if()-statement
    * @param conditionAssignment The assignment defining the condition variable.
    */
   private void rewriteLogicNot(ControlFlowBlock block, StatementConditionalJump conditional, StatementAssignment conditionAssignment) {
      getLog().append("Rewriting ! if()-condition to reversed if() "+conditionAssignment.toString(getProgram(), false));
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
