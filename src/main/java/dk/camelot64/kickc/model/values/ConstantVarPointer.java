package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;

/** A pointer to a variable */
public class ConstantVarPointer implements ConstantValue {

   /** The variable pointed to. */
   private VariableRef toVar;

   public ConstantVarPointer(VariableRef toVar) {
      this.toVar = toVar;
   }

   public VariableRef getToVar() {
      return toVar;
   }

   public void setToVar(VariableRef toVar) {
      this.toVar = toVar;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      Variable to = scope.getVariable(toVar);
      return new SymbolTypePointer(to.getType());
   }

   @Override
   public ConstantLiteral calculateLiteral(ProgramScope scope) {
      throw new ConstantNotLiteral("Cannot calculate literal var pointer");
   }

   @Override
   public String toString(Program program) {
      return "&" + toVar.toString(program);
   }

   @Override
   public String toString() {
      return toString(null);
   }
}
