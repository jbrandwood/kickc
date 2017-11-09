package dk.camelot64.kickc.model;

/**
 * Single Static Assignment Form Statement Jump target.
 */
public class StatementLabel extends StatementBase {

   private LabelRef label;

   public StatementLabel(LabelRef label) {
      super(null);
      this.label = label;
   }

   public LabelRef getLabel() {
      return label;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      return super.idxString() + label.getFullName() + ":"+(aliveInfo?super.aliveString(program):"");
   }

}
