package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.icl.PointerDereference;
import dk.camelot64.kickc.icl.ProgramScope;
import dk.camelot64.kickc.icl.RegisterAllocation;

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
      return getAsString();
   }

   @Override
   public String getAsTypedString(ProgramScope scope) {
      return getAsString();
   }

   @Override
   public String getAsString() {
      return "*(" + pointer.toString() + ')';
   }
}
