package dk.camelot64.kickc.icl;

/**
 * A Symbol (variable, jump label, etc.)
 */
public class VariableUnversioned extends Variable {

   /**
    * The number of the next version
    */
   private Integer nextVersionNumber;

   public VariableUnversioned(String name, Scope scope, SymbolType type) {
      super(name, scope, type);
      this.nextVersionNumber = 0;
   }

   /**
    * Get the version number of the next version. (if anyone versions the symbol).
    */
   int getNextVersionNumber() {
      return nextVersionNumber++;
   }

   @Override
   public boolean isVersioned() {
      return false;
   }

   @Override
   public boolean isIntermediate() {
      return false;
   }
}
