package dk.camelot64.kickc.icl;

/** A dereferenced variable pointer plus an index (used for array writes)*/
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
      return "*(" + pointer.toString(program) + " + " +index.toString(program) + ')';
   }

}
