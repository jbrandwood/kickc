package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.symbols.ProgramScope;

/** A literal constant value */
public interface ConstantLiteral<T> extends ConstantValue {

   T getValue();

   @Override
   default ConstantLiteral calculate(ProgramScope scope) {
      return this;
   }
}
