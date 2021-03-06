package dk.camelot64.kickc.model;

/** Signals that a constant is not literal.
 *  Thrown when trying to find the literal value of constant expressions that
 *  contain non-literal elements such as the address of program labels.
 **/
public class ConstantNotLiteral extends RuntimeException {

   /** Global singleton (saves initialization time for the exception stacktrace)*/
   private static final ConstantNotLiteral EXCEPTION = new ConstantNotLiteral("Constant not literal!");

   public static ConstantNotLiteral getException() {
      return EXCEPTION;
   }

   public  ConstantNotLiteral(String message) {
      super(message);
   }

}
