package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Compiler Pass simplifying unary not variables if they reference a comparison that can be inverted
 */
public class Pass2UnaryNotSimplification extends Pass2SsaOptimization {

   public Pass2UnaryNotSimplification(Program program) {
      super(program);
   }

   /**
    * Eliminate unary nots if they are the only usage of a reversable comparison
    */
   @Override
   public boolean optimize() {
      final Map<VariableRef, Integer> usages = countVarUsages();
      final Map<LValue, StatementAssignment> assignments = getAllAssignments();
      final List<VariableRef> unusedComparisons = optimizeUnaryNots(assignments, usages);
      removeAssignments(unusedComparisons);
      deleteSymbols(unusedComparisons);
      return (unusedComparisons.size() > 0);
   }

   /**
    * Examine all unary nots. If they are the only usage of a reversable unary not replace the unary not with the reversed comparison - and eliminate the riginal variable.
    *
    * @param assignments Assignments to examine
    * @param usages      All variable usages
    * @return Unused comparisons (because they have been replaced with reversed comparisions)
    */
   private List<VariableRef> optimizeUnaryNots(final Map<LValue, StatementAssignment> assignments, final Map<VariableRef, Integer> usages) {

      final List<VariableRef> unused = new ArrayList<>();
      for (StatementAssignment assignment : assignments.values()) {
         if (assignment.getrValue1() == null
               && assignment.getOperator() != null
               && ("!".equals(assignment.getOperator().getOperator()) || "not".equals(assignment.getOperator().getOperator()))
               && assignment.getrValue2() instanceof VariableRef
               ) {
            VariableRef tempVar = (VariableRef) assignment.getrValue2();
            StatementAssignment tempAssignment = assignments.get(tempVar);
            if (usages.get(tempVar) == 1 && tempAssignment.getOperator() != null) {
               switch(tempAssignment.getOperator().getOperator()) {
                  case "<":
                     createInverse(">=", assignment, tempAssignment);
                     unused.add(tempVar);
                     break;
                  case ">":
                     createInverse("<=", assignment, tempAssignment);
                     unused.add(tempVar);
                     break;
                  case "<=":
                  case "=<":
                     createInverse(">", assignment, tempAssignment);
                     unused.add(tempVar);
                     break;
                  case ">=":
                  case "=>":
                     createInverse("<", assignment, tempAssignment);
                     unused.add(tempVar);
                     break;
                  case "==":
                     createInverse("!=", assignment, tempAssignment);
                     unused.add(tempVar);
                     break;
                  case "!=":
                  case "<>":
                     createInverse("==", assignment, tempAssignment);
                     unused.add(tempVar);
                     break;
                  case "!":
                  case "not":
                     createInverse(null, assignment, tempAssignment);
                     unused.add(tempVar);
                     break;
               }
            }
         }
      }
      return unused;
   }

   /**
    * Updates an assignment to be the inverse of the temp assignment.
    *
    * @param newOperator The new operator to use
    * @param assignment The assignment to update
    * @param tempAssignment The temp assignment to take rValues from.
    */
   private void createInverse(String newOperator, StatementAssignment assignment, StatementAssignment tempAssignment) {
      assignment.setrValue1(tempAssignment.getrValue1());
      assignment.setOperator(newOperator==null?null:new Operator(newOperator));
      assignment.setrValue2(tempAssignment.getrValue2());
      getLog().append("Inversing boolean not "+assignment.toString(getProgram()) +" from "+tempAssignment.toString(getProgram()));
   }


}
