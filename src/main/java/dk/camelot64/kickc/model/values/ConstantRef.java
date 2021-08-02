package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;

/** A reference to a named Constant (in the symbol table) */
public class ConstantRef extends SymbolVariableRef implements ConstantValue {

   public ConstantRef(Variable constantVar) {
      super(constantVar.getFullName());
      if(!constantVar.isKindConstant())
         throw new InternalError("VariableRef not allowed for non-constant "+constantVar.toString());
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      Variable constant = scope.getConstant(this);
      return constant.getType();
   }

   @Override
   public ConstantLiteral calculateLiteral(ProgramScope scope) {
      Variable constantVar = scope.getConstant(this);
      if(constantVar.getType() instanceof SymbolTypePointer)
         if(((SymbolTypePointer) constantVar.getType()).getArraySpec()!=null)
            // Constant array values are not literal
            throw new ConstantNotLiteral("not literal");
      ConstantValue constantVarValue = constantVar.getInitValue();
      return constantVarValue.calculateLiteral(scope);
   }
}
