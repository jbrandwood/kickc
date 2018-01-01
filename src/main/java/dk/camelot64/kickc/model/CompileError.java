package dk.camelot64.kickc.model;

/** Signals some error in the code (or compilation) */
public class CompileError extends RuntimeException {

   public CompileError(String message) {
      super(message);
   }

   public CompileError(String message, Throwable cause) {
      super(message, cause);
   }
}
