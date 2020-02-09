package dk.camelot64.kickc.model.values;

/** A reference to a Variable or Constant (in the symbol table) */
public abstract class SymbolVariableRef extends SymbolRef implements RValue {

   public SymbolVariableRef(String fullName) {
      super(fullName);
   }


}
