package dk.camelot64.kickc.icl;

/** A dereferenced pointer */
public interface PointerDereference extends LValue {

   Value getPointer();

}
