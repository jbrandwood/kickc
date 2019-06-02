package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Compiler Pass simplifying conditional jumps that are simple comparisons
 */
public class Pass2ConditionalJumpSimplification extends Pass2SsaOptimization {

   public Pass2ConditionalJumpSimplification(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      final Map<LValue, StatementAssignment> assignments = getAllAssignments();
      final Map<RValue, List<Statement>> usages = getAllUsages();
      final List<VariableRef> simpleConditionVars = getSimpleConditions(assignments, usages);
      removeAssignments(getGraph(), simpleConditionVars);
      deleteSymbols(getScope(), simpleConditionVars);
      return (simpleConditionVars.size() > 0);
   }

   private List<VariableRef> getSimpleConditions(final Map<LValue, StatementAssignment> assignments, final Map<RValue, List<Statement>> usages) {

      final List<VariableRef> simpleConditionVars = new ArrayList<>();

      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementConditionalJump) {
               StatementConditionalJump conditionalJump = (StatementConditionalJump) statement;
               if(conditionalJump.getrValue1() == null && conditionalJump.getOperator() == null) {
                  RValue conditionRValue = conditionalJump.getrValue2();
                  if(conditionRValue instanceof VariableRef && usages.get(conditionRValue).size() == 1) {
                     VariableRef conditionVar = (VariableRef) conditionRValue;
                     StatementAssignment conditionAssignment = assignments.get(conditionVar);
                     if(conditionAssignment != null && conditionAssignment.getOperator() != null) {
                        switch(conditionAssignment.getOperator().getOperator()) {
                           case "==":
                           case "<>":
                           case "!=":
                           case "<":
                           case ">":
                           case "<=":
                           case "=<":
                           case ">=":
                           case "=>":
                              conditionalJump.setrValue1(conditionAssignment.getrValue1());
                              conditionalJump.setOperator(conditionAssignment.getOperator());
                              conditionalJump.setrValue2(conditionAssignment.getrValue2());
                              simpleConditionVars.add(conditionVar);
                              getLog().append("Simple Condition " + conditionVar.toString(getProgram()) + " " + conditionalJump.toString(getProgram(), false));
                              break;
                           default:
                        }
                     }
                  }
               }
            }
         }
      }
      return simpleConditionVars;
   }

}
