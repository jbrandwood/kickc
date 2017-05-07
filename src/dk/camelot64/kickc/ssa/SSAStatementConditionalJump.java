package dk.camelot64.kickc.ssa;

/**
 * Single Static Assignment Form Statement with a conditional jump.
 * Intermediate form used for compiler optimization.
 * <br>
 * <i> if ( Y<sub>j</sub> ) goto XX </i>
 */
public class SSAStatementConditionalJump implements SSAStatement {

   private SSARValue condition;
   private SSAJumpLabel destination;

   public SSAStatementConditionalJump(SSARValue condition, SSAJumpLabel destination) {
      this.condition = condition;
      this.destination = destination;
   }

   public SSARValue getCondition() {
      return condition;
   }

   public SSAJumpLabel getDestination() {
      return destination;
   }

   @Override
   public String toString() {
      return "  "+"if("+condition+") goto "+destination;
   }
}
