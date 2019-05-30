package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.StatementAssignment;

/** The "total" RValue of an assignment. */
public class AssignmentRValue implements RValue {

   private StatementAssignment assignment;

   public AssignmentRValue(StatementAssignment assignment) {
      this.assignment = assignment;
   }

   public StatementAssignment getAssignment() {
      return assignment;
   }

   @Override
   public String toString(Program program) {
      return
            (assignment.getrValue1() == null ? "" : assignment.getrValue1().toString(program) + " ") +
                  (assignment.getOperator() == null ? "" : assignment.getOperator() + " ") +
                  assignment.getrValue2().toString(program)
            ;
   }

   @Override
   public String toString() {
      return toString(null);
   }
}
