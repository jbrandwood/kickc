package dk.camelot64.kickc.icl;

/**
 * Single Static Assignment Form Statement Jump target.
 */
public class StatementLabel implements Statement {

   private Label label;

   public StatementLabel(Label label) {
      this.label = label;
   }

   public Label getLabel() {
      return label;
   }

   @Override
   public String toString() {
      return label.getFullName()+":";
   }


}
