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

   @Override
   public String toString() {
      return "*(" + pointer + ')';
   }

   public void setPointer(RValue pointer) {
      this.pointer = pointer;
   }
}
