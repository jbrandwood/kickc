package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.symbols.SymbolVariable;

/** A reference to a variable from the symbol table */
public class VariableRef extends SymbolVariableRef implements RValue, LValue {

   public VariableRef(String fullName) {
      super(fullName);
   }

   public VariableRef(SymbolVariable variable) {
      this(variable.getFullName());
      if(!variable.isVariable())
         throw new InternalError("VariableRef not allowed for non-variable "+variable.toString());
   }

}