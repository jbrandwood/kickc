package dk.camelot64.kickc.icl;

/**  Signals some error in the code (or compilation) */
public class CompileError extends RuntimeException {

   public CompileError(String message) {
      super(message);
   }


}
