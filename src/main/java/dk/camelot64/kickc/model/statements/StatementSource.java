package dk.camelot64.kickc.model.statements;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.misc.Interval;

/** Contains information about the source of a program statement */
public class StatementSource {

   private ParserRuleContext context;

   public StatementSource(ParserRuleContext context) {
      this.context = context;
   }

   @Override
   public String toString() {
      CharStream stream = context.getStart().getInputStream();
      Interval interval = new Interval(context.getStart().getStartIndex(), context.getStop().getStopIndex());
      String sourceMessage = "File "+stream.getSourceName()+"\nLine "+context.getStart().getLine()+ "\n" +stream.getText(interval);
      return sourceMessage;
   }
}
