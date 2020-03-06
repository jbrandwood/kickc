package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.ConstantValue;

import java.util.List;

/** Pulls some bytes of the stack. */
public class StatementStackPull extends StatementBase {

   private ConstantValue pullBytes;

   public StatementStackPull(ConstantValue pullBytes, StatementSource source, List<Comment> comments) {
      super(source, comments);
      this.pullBytes = pullBytes;
   }

   public ConstantValue getPullBytes() {
      return pullBytes;
   }

   public void setPullBytes(ConstantValue pullBytes) {
      this.pullBytes = pullBytes;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      return "stackpull("+pullBytes.toString(program)+")";
   }
}
