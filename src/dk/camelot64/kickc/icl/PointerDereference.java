package dk.camelot64.kickc.icl;

/** A dereferenced pointer */
public class PointerDereference implements LValue {

   private Variable pointer;

   public PointerDereference(Variable pointer) {
      this.pointer = pointer;
   }

   public Variable getPointer() {
      return pointer;
   }

   @Override
   public String toString() {
      return "*(" + pointer + ')';
   }
}
