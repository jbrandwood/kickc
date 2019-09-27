package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.types.SymbolType;

/**
 * A Symbol (variable, jump label, etc.)
 */
public class VariableUnversioned extends Variable {

   /** The number of the next version */
   private Integer nextVersionNumber;

   public VariableUnversioned( String name, Scope scope, SymbolType type, String dataSegment) {
      super(name, scope, type, dataSegment, false, false);
      this.nextVersionNumber = 0;
   }

   /**
    * Get the version number of the next version. (if anyone versions the symbol).
    */
   int getNextVersionNumber() {
      return nextVersionNumber++;
   }

   public VariableVersion createVersion() {
      VariableVersion version = new VariableVersion(this, this.getNextVersionNumber());
      getScope().add(version);
      return version;
   }
}
