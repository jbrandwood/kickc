package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.Program;

/**
 * Single Static Assignment Form Statement Jump target.
 */
public class StatementLabel extends StatementBase {

   private LabelRef label;

   public StatementLabel(LabelRef label,
                         StatementSource source) {
      super(null, source);
      this.label = label;
   }

   public LabelRef getLabel() {
      return label;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      return super.idxString() + label.getFullName() + ":" + (aliveInfo ? super.aliveString(program) : "");
   }

}
