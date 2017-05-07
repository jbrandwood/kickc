package dk.camelot64.kickc.icl;

/**
 * Single Static Assignment Form Statement Jump target.
 */
public class StatementJumpTarget implements Statement {

   private Symbol label;

   public StatementJumpTarget(Symbol label) {
      this.label = label;
   }

   public Symbol getLabel() {
      return label;
   }

   @Override
   public String toString() {
      return label+":";
   }


}
