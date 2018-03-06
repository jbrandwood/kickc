package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;

/** A reference to a named Constant (in the symbol table) */
public class ConstantRef extends SymbolRef implements ConstantValue {

   public ConstantRef(ConstantVar constantVar) {
      super(constantVar.getFullName());
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      ConstantVar constant = scope.getConstant(this);
      return constant.getType();
   }

}
