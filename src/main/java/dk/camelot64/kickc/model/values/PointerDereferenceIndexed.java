package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

/** A dereferenced variable pointer plus an index (used for array writes) */
public class PointerDereferenceIndexed implements PointerDereference {

   private RValue pointer;

   private RValue index;

   public PointerDereferenceIndexed(RValue pointer, RValue index) {
      this.pointer = pointer;
      this.index = index;
   }

   public RValue getPointer() {
      return pointer;
   }

   public void setPointer(RValue pointer) {
      this.pointer = pointer;
   }

   public RValue getIndex() {
      return index;
   }

   public void setIndex(RValue index) {
      this.index = index;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      String pointerString = pointer.toString(program);
      if(!pointerString.matches("[a-zA-Z0-9:#$]*"))
         pointerString = "(" + pointerString + ")";
      return pointerString + "[" + index.toString(program) + ']';
   }

}
