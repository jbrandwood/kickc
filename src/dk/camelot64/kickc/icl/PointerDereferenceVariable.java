package dk.camelot64.kickc.icl;

/** A dereferenced variable pointer */
public class PointerDereferenceVariable implements PointerDereference {

   private Variable pointer;

   public PointerDereferenceVariable(Variable pointer) {
      this.pointer = pointer;
   }

   public Variable getPointer() {
      return pointer;
   }

   public Variable getPointerVariable() {
      return pointer;
   }

   @Override
   public String toString() {
      return "*(" + pointer + ')';
   }

   public void setPointerVariable(Variable pointer) {
      this.pointer = pointer;
   }
}
