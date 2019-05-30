package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementSource;

/** Signals an internal error in the compiler. Should be reported to the author. */
public class InternalError extends RuntimeException {

   public InternalError(String message) {
      super(message);
   }

   public InternalError(String message, StatementSource source) {
      super(message+"\n"+source.toString());
   }

   public InternalError(String message, Statement statement) {
      this(message, statement.getSource());
   }

   public InternalError(String message, Throwable cause) {
      super(message, cause);
   }
}
