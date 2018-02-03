package dk.camelot64.kickc.model;

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
   public String toString(Program program) {
      return "&" + toVar.toString(program);
   }
}
