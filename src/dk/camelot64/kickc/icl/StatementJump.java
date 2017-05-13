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

   @Override
   public String toString() {
      return "goto "+destination.getName();
   }
}
