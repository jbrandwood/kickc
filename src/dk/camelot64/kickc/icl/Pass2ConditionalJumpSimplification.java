package dk.camelot64.kickc.icl;

import dk.camelot64.kickc.CompileLog;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Compiler Pass simplifying conditional jumps that are simple comparisons
 */
public class Pass2ConditionalJumpSimplification extends Pass2SsaOptimization {

   private Map<Variable, List<Statement>> allUsages;

   public Pass2ConditionalJumpSimplification(ControlFlowGraph graph, Scope scope, CompileLog log) {
      super(graph, scope, log);
   }

   /**
    * Eliminate alias assignments replacing them with the aliased variable.
    */
   @Override
   public boolean optimize() {
      final Map<LValue, StatementAssignment> assignments = getAllAssignments();
      final Map<RValue, List<Statement>> usages = getAllUsages();
      final List<Variable> simpleConditionVars = getSimpleConditions(assignments, usages);
      removeAssignments(simpleConditionVars);
      deleteSymbols(simpleConditionVars);
      return (simpleConditionVars.size()>0);
   }

   private List<Variable>  getSimpleConditions(final Map<LValue, StatementAssignment> assignments, final Map<RValue, List<Statement>> usages) {

      final List<Variable>  simpleConditionVars = new ArrayList<>();

      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitConditionalJump(StatementConditionalJump conditionalJump) {
            if(conditionalJump.getRValue1()==null && conditionalJump.getOperator()==null) {
               RValue conditionRValue = conditionalJump.getRValue2();
               if(conditionRValue instanceof Variable && usages.get(conditionRValue).size()==1) {
                  Variable conditionVar = (Variable) conditionRValue;
                  StatementAssignment conditionAssignment = assignments.get(conditionVar);
                  if(conditionAssignment.getOperator()!=null) {
                     switch (conditionAssignment.getOperator().getOperator()) {
                        case "==":
                        case "<>":
                        case "!=":
                        case "<":
                        case ">":
                        case "<=":
                        case "=<":
                        case ">=":
                        case "=>":
                        conditionalJump.setRValue1(conditionAssignment.getRValue1());
                        conditionalJump.setOperator(conditionAssignment.getOperator());
                        conditionalJump.setRValue2(conditionAssignment.getRValue2());
                        simpleConditionVars.add(conditionVar);
                        log.append("Simple Condition " + conditionVar + " " + conditionalJump);
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
