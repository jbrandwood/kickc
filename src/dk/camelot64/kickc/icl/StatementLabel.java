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
      return getAsString();
   }

   @Override
   public String getAsTypedString(ProgramScope scope) {
      return getAsString();
   }

   @Override
   public String getAsString() {
      return label.getFullName() + ":";
   }
}
