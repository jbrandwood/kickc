package dk.camelot64.kickc.icl;

/**
 * Single Static Assignment Form Statement Jump target.
 */
public class StatementLabel implements Statement {

   private LabelRef label;

   public StatementLabel(LabelRef label) {
      this.label = label;
   }

   public LabelRef getLabel() {
      return label;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(ProgramScope scope) {
      return label.getFullName() + ":";
   }

}
