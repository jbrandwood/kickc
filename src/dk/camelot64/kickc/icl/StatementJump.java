package dk.camelot64.kickc.icl;

/**
 * Single Static Assignment Form Statement unconditional jump.
 * Intermediate form used for compiler optimization.
 * <br>
 * <i> goto XX </i>
 */
public class StatementJump implements Statement {

   private Symbol destination;

   public StatementJump(Symbol destination) {
      this.destination = destination;
   }

   public Symbol getDestination() {
      return destination;
   }

   @Override
   public String toString() {
      return "goto "+destination.getName();
   }
}
