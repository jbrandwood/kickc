package dk.camelot64.kickc.icl;

/** A dereferenced pointer (based on a variable or a constant pointer)*/
public class PointerDereferenceSimple implements PointerDereference {

   private RValue pointer;

   public PointerDereferenceSimple(RValue pointer) {
      this.pointer = pointer;
   }

   public RValue getPointer() {
      return pointer;
   }

   public void setPointer(RValue pointer) {
      this.pointer = pointer;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      return "*(" + pointer.toString(program) + ')';
   }

}
