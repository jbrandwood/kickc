package dk.camelot64.kickc.icl;

/** A dereferenced ZP pointer to a byte */
public class PointerDereferenceRegisterZpByte implements PointerDereference {

   private RegisterAllocation.RegisterZpPointerByte pointer;

   public PointerDereferenceRegisterZpByte(RegisterAllocation.RegisterZpPointerByte pointer) {
      this.pointer = pointer;
   }

   public RegisterAllocation.RegisterZpPointerByte getPointer() {
      return pointer;
   }

   public RegisterAllocation.RegisterZpPointerByte getPointerRegister() {
      return pointer;
   }

   @Override
   public String toString() {
      return "*(" + pointer + ')';
   }

}
