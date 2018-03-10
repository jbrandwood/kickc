package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.symbols.ProgramScope;

/** A literal constant value */
public interface ConstantLiteral<T> extends ConstantValue {

   T getValue();

   @Override
   default ConstantLiteral calculateLiteral(ProgramScope scope) {
      return this;
   }
}
