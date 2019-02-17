package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.Program;

import java.util.ArrayList;
import java.util.List;

/**
 * Single Static Assignment Form Statement Jump target.
 */
public class StatementLabel extends StatementBase {

   private LabelRef label;

   public StatementLabel(LabelRef label, StatementSource source, List<Comment> comments) {
      super(null, source, comments);
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
