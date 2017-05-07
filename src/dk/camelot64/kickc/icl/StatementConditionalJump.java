package dk.camelot64.kickc.icl;

/**
 * Intermediate Compiler Form Statement with a conditional jump.
 * Intermediate form used for compiler optimization.
 * <br>
 * <i> if ( Y<sub>j</sub> ) goto XX </i>
 */
public class StatementConditionalJump implements Statement {

   private RValue condition;
   private Symbol destination;

   public StatementConditionalJump(RValue condition, Symbol destination) {
      this.condition = condition;
      this.destination = destination;
   }

   public RValue getCondition() {
      return condition;
   }

   public Symbol getDestination() {
      return destination;
   }

   @Override
   public String toString() {
      return "if("+condition+") goto "+destination.getName();
   }
}
