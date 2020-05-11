package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementSource;
import org.antlr.v4.runtime.Token;

/** Signals some error in the code (or compilation) */
public class CompileError extends RuntimeException {

   private String source;

   public CompileError(String message) {
      super(message);
   }

   public CompileError(String message, StatementSource source) {
      super(message+"\n"+(source==null?"":source.toString()));
      this.source = (source==null?"":source.toString());
   }

   public CompileError(String message, Token token) {
      this(message, new StatementSource(token, token));
   }

   public CompileError(String message, Statement statement) {
      this(message, statement.getSource());
   }

   public CompileError(String message, Throwable cause) {
      super(message, cause);
   }

   public String getSource() {
      return source;
   }

}
