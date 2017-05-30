package dk.camelot64.kickc.icl;

/** A dereferenced constant pointer */
public class PointerDereferenceConstant implements PointerDereference {

   private Constant pointer;

   public PointerDereferenceConstant(Constant pointer) {
      this.pointer = pointer;
   }

   public Constant getPointer() {
      return pointer;
   }

   public Constant getPointerConstant() {
      return pointer;
   }

   @Override
   public String toString() {
      return "*(" + pointer + ')';
   }
}
