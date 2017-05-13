package dk.camelot64.kickc.icl;

/** A Symbol (variable, jump label, etc.) */
public class VariableIntermediate extends Variable {

   public VariableIntermediate(String name, SymbolType type) {
      super(name, type);
   }

   @Override
   public boolean isIntermediate() {
      return true;
   }

   @Override
   public boolean isVersioned() {
      return false;
   }
}
