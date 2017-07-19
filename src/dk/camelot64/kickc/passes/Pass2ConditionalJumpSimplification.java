package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Compiler Pass simplifying conditional jumps that are simple comparisons
 */
public class Pass2ConditionalJumpSimplification extends Pass2SsaOptimization {

   private Map<Variable, List<Statement>> allUsages;

   public Pass2ConditionalJumpSimplification(ControlFlowGraph graph, ProgramScope scope, CompileLog log) {
      super(graph, scope, log);
   }

   /**
    * Eliminate alias assignments replacing them with the aliased variable.
    */
   @Override
   public boolean optimize() {
      final Map<LValue, StatementAssignment> assignments = getAllAssignments();
      final Map<RValue, List<Statement>> usages = getAllUsages();
      final List<VariableRef> simpleConditionVars = getSimpleConditions(assignments, usages);
      removeAssignments(simpleConditionVars);
      deleteVariables(simpleConditionVars);
      return (simpleConditionVars.size()>0);
   }

   private List<VariableRef>  getSimpleConditions(final Map<LValue, StatementAssignment> assignments, final Map<RValue, List<Statement>> usages) {

      final List<VariableRef>  simpleConditionVars = new ArrayList<>();

      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitConditionalJump(StatementConditionalJump conditionalJump) {
            if(conditionalJump.getRValue1()==null && conditionalJump.getOperator()==null) {
               RValue conditionRValue = conditionalJump.getRValue2();
               if(conditionRValue instanceof VariableRef && usages.get(conditionRValue).size()==1) {
                  VariableRef conditionVar = (VariableRef) conditionRValue;
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
                        conditionalJump.setRValue1(conditionAssignment.getrValue1());
                        conditionalJump.setOperator(conditionAssignment.getOperator());
                        conditionalJump.setRValue2(conditionAssignment.getrValue2());
                        simpleConditionVars.add(conditionVar);
                        log.append("Simple Condition " + conditionVar.getAsTypedString(getSymbols()) + " " + conditionalJump.getAsTypedString(getSymbols()));
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
