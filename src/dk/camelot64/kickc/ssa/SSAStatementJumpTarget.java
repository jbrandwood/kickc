package dk.camelot64.kickc.ssa;

/**
 * Single Static Assignment Form Statement Jump target.
 */
public class SSAStatementJumpTarget implements SSAStatement {

   private SSAJumpLabel label;

   public SSAStatementJumpTarget(SSAJumpLabel label) {
      this.label = label;
   }

   public SSAJumpLabel getLabel() {
      return label;
   }

   @Override
   public String toString() {
      return label+":";
   }


}
