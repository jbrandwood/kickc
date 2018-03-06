package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;

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

   /**
    * Eliminate alias assignments replacing them with the aliased variable.
    */
   @Override
   public boolean step() {
      final Map<LValue, StatementAssignment> assignments = getAllAssignments();
      final Map<RValue, List<Statement>> usages = getAllUsages();
      final List<VariableRef> simpleConditionVars = getSimpleConditions(assignments, usages);
      removeAssignments(simpleConditionVars);
      deleteSymbols(simpleConditionVars);
      return (simpleConditionVars.size() > 0);
   }

   private List<VariableRef> getSimpleConditions(final Map<LValue, StatementAssignment> assignments, final Map<RValue, List<Statement>> usages) {

      final List<VariableRef> simpleConditionVars = new ArrayList<>();

      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitConditionalJump(StatementConditionalJump conditionalJump) {
            if(conditionalJump.getrValue1() == null && conditionalJump.getOperator() == null) {
               RValue conditionRValue = conditionalJump.getrValue2();
               if(conditionRValue instanceof VariableRef && usages.get(conditionRValue).size() == 1) {
                  VariableRef conditionVar = (VariableRef) conditionRValue;
                  StatementAssignment conditionAssignment = assignments.get(conditionVar);
                  if(conditionAssignment.getOperator() != null) {
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
                           getLog().append("Simple Condition " + conditionVar.toString(getProgram()) + " " + conditionalJump.toString(getProgram(), true));
                           break;
                        default:
                     }
                  }
               }
            }
            return null;
         }
      };
      visitor.visitGraph(getGraph());
      return simpleConditionVars;
   }


}
