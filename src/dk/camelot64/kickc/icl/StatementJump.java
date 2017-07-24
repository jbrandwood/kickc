package dk.camelot64.kickc.icl;

/**
 * Single Static Assignment Form Statement unconditional jump.
 * Intermediate form used for compiler optimization.
 * <br>
 * <i> goto XX </i>
 */
public class StatementJump implements Statement {

   private LabelRef destination;

   public StatementJump(LabelRef destination) {
      this.destination = destination;
   }

   public LabelRef getDestination() {
      return destination;
   }

   public void setDestination(LabelRef destination) {
      this.destination = destination;
   }

   @Override
   public String toString() {
       return toString(null);
   }

   @Override
   public String toString(ProgramScope scope) {
      return "goto "+destination.getFullName();
   }

}
