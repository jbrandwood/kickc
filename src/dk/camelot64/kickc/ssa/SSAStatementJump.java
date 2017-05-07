package dk.camelot64.kickc.ssa;

/**
 * Single Static Assignment Form Statement unconditional jump.
 * Intermediate form used for compiler optimization.
 * <br>
 * <i> goto XX </i>
 */
public class SSAStatementJump implements SSAStatement {

   private SSAJumpLabel destination;

   public SSAStatementJump(SSAJumpLabel destination) {
      this.destination = destination;
   }

   public SSAJumpLabel getDestination() {
      return destination;
   }

   @Override
   public String toString() {
      return "  "+"goto "+destination;
   }
}
