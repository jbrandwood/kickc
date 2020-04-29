package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

import java.util.Objects;

/** A dereferenced pointer (based on a variable or a constant pointer) */
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

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      PointerDereferenceSimple that = (PointerDereferenceSimple) o;
      return pointer.equals(that.pointer);
   }

   @Override
   public int hashCode() {
      return Objects.hash(pointer);
   }
}
