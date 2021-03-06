package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

/** Assignable value (capable of being on the left part of an assignment) */
public interface LValue extends RValue {

   /**
    * Singleton signalling that an RValue is never assigned and can safely be discarded as rvalue in phi-functions.
    */
   RValue VOID = new RValue() {

      @Override
      public String toString() {
         return toString(null);
      }

      @Override
      public String toString(Program program) {
         return "VOID";
      }

   };


}
