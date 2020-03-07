package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.RValue;

import java.util.List;

/** An expression that has a side effect. The expression is not assigned anywhere and will not be deleted. */
public class StatementExprSideEffect extends StatementBase {

   private RValue expression;

   public StatementExprSideEffect(RValue expression, StatementSource source, List<Comment> comments) {
      super(source, comments);
      this.expression = expression;
   }

   public RValue getExpression() {
      return expression;
   }

   public void setExpression(RValue expression) {
      this.expression = expression;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      return "sideeffect " + expression.toString(program);
   }
}
