package dk.camelot64.kickc.icl;

/**
 * Intermediate Compiler Form Statement with a conditional jump.
 * Intermediate form used for compiler optimization.
 * <br>
 * <i> if ( Y<sub>j</sub> ) goto XX </i>
 */
public class StatementConditionalJump implements Statement {

   private RValue condition;
   private Label destination;

   public StatementConditionalJump(RValue condition, Label destination) {
      this.condition = condition;
      this.destination = destination;
   }

   public RValue getCondition() {
      return condition;
   }

   public Label getDestination() {
      return destination;
   }

   @Override
   public String toString() {
      return "if("+condition+") goto "+destination.getName();
   }

   public void setCondition(RValue condition) {
      this.condition = condition;
   }

   public void setDestination(Label destination) {
      this.destination = destination;
   }
}
