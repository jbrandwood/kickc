package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.SymbolVariable;
import dk.camelot64.kickc.model.types.SymbolType;

/** A reference to a named Constant (in the symbol table) */
public class ConstantRef extends SymbolVariableRef implements ConstantValue {

   public ConstantRef(SymbolVariable constantVar) {
      super(constantVar.getFullName());
      if(!constantVar.isConstant())
         throw new InternalError("VariableRef not allowed for non-constant "+constantVar.toString());
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      SymbolVariable constant = scope.getConstant(this);
      return constant.getType();
   }

   @Override
   public ConstantLiteral calculateLiteral(ProgramScope scope) {
      SymbolVariable constantVar = scope.getConstant(this);
      ConstantValue constantVarValue = constantVar.getConstantValue();
      return constantVarValue.calculateLiteral(scope);
   }
}
