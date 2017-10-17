package dk.camelot64.kickc.model;

/** A constant value. The value might be calculated through a constant expression. */
public interface ConstantValue extends RValue {

   SymbolType getType(ProgramScope scope);

}
