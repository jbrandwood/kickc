package dk.camelot64.kickc.model;

/** A dereferenced pointer */
public interface PointerDereference extends LValue {

   RValue getPointer();

   void setPointer(RValue pointer);


}
