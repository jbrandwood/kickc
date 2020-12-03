package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementSource;
import org.antlr.v4.runtime.Token;

/** Signals some error in the code (or compilation) */
public class CompileError extends RuntimeException {

   private StatementSource source;

   public CompileError(String message) {
      super(message);
   }

   public CompileError(String message, StatementSource source) {
      super(message);
      this.source = source;
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

   public StatementSource getSource() {
      return source;
   }

   /**
    * Formats the CompileError using the GCC format, so that it may be easily parsed by IDEs and automated tools.
    * See https://www.gnu.org/prep/standards/html_node/Errors.html
    * <ul>
    * <li> sourcefile:lineno: message
    * <li> sourcefile:lineno:column: message
    * </ul>
    */
   public String format() {
      StatementSource source = getSource();
      if(source != null && source.getFileName() != null) {
         return source.format() + " error: " + getMessage();
      } else {
         return getMessage();
      }
   }

}
