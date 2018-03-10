package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;

/** A constant value. The value might be calculated through a constant expression. */
public interface ConstantValue extends RValue {

   SymbolType getType(ProgramScope scope);

   ConstantLiteral calculate(ProgramScope scope);

}
