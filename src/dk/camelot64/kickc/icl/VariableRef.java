package dk.camelot64.kickc.icl;

/** A reference to a variable from the symbol table */
public class VariableRef extends SymbolRef implements RValue, LValue {

   public VariableRef(String fullName) {
      super(fullName);
   }

   public VariableRef(Variable variable) {
      this(variable.getFullName());
   }

}
