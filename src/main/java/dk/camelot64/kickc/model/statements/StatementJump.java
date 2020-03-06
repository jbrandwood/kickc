package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.Program;

import java.util.List;

/**
 * Single Static Assignment Form Statement unconditional jump.
 * Intermediate form used for compiler optimization.
 * <br>
 * <i> goto XX </i>
 */
public class StatementJump extends StatementBase {

   private LabelRef destination;

   public StatementJump(LabelRef destination, StatementSource source, List<Comment> comments) {
      super(source, comments);
      this.destination = destination;
   }

   public LabelRef getDestination() {
      return destination;
   }

   public void setDestination(LabelRef destination) {
      this.destination = destination;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      return super.idxString() + "goto " + destination.getFullName() + (aliveInfo ? super.aliveString(program) : "");
   }

}
