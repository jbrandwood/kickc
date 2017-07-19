package dk.camelot64.kickc.icl;

/**
 * Single Static Assignment Form Statement unconditional jump.
 * Intermediate form used for compiler optimization.
 * <br>
 * <i> goto XX </i>
 */
public class StatementJump implements Statement {

   private Label destination;

   public StatementJump(Label destination) {
      this.destination = destination;
   }

   public Label getDestination() {
      return destination;
   }

   public void setDestination(Label destination) {
      this.destination = destination;
   }

   @Override
   public String toString() {
       return getAsString();
   }

   @Override
   public String getAsTypedString(ProgramScope scope) {
      return getAsString();
   }

   @Override
   public String getAsString() {
      return "goto "+destination.getFullName();   }
}
