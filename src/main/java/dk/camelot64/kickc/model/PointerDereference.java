package dk.camelot64.kickc.model;

/** A dereferenced pointer */
public interface PointerDereference extends LValue {

   Value getPointer();

}
