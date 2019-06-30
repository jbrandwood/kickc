package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.types.SymbolType;

/**
 * An array initialized with constant values.
 */
public interface ConstantArray extends ConstantValue {

   SymbolType getElementType();

}
