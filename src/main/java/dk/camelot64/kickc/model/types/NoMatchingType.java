package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.CompileError;

/** Signalling that no type can be used to promote the operands of a binary expression to be compatible. */
public class NoMatchingType extends CompileError {
   public NoMatchingType(String message) {
      super(message);
   }
}
