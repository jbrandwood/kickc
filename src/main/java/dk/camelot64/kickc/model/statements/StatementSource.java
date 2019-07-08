package dk.camelot64.kickc.model.statements;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.misc.Interval;

/** Contains information about the source of a program statement */
public class StatementSource {

   private ParserRuleContext context;

   public StatementSource(ParserRuleContext context) {
      this.context = context;
   }

   public String getFile() {
      Token contextStart = context.getStart();
      if(contextStart != null) {
         CharStream stream = contextStart.getInputStream();
         return stream.getSourceName();
      }
      return null;
   }

   public Integer getLineNumber() {
      Token contextStart = context.getStart();
      if(contextStart != null) {
         return contextStart.getLine();
      }
      return null;
   }

   public String getCode() {
      Token contextStart = context.getStart();
      if(contextStart != null) {
         CharStream stream = contextStart.getInputStream();
         Interval interval = new Interval(contextStart.getStartIndex(), context.getStop().getStopIndex());
         return stream.getText(interval);
      }
      return null;
   }

   @Override
   public String toString() {
      Token contextStart = context.getStart();
      if(contextStart != null) {
         CharStream stream = contextStart.getInputStream();
         Interval interval = new Interval(contextStart.getStartIndex(), context.getStop().getStopIndex());
         return "File " + stream.getSourceName() + "\nLine " + contextStart.getLine() + "\n" + stream.getText(interval);
      } else {
         return "";
      }
   }
}
