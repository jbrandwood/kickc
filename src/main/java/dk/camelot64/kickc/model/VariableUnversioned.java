package dk.camelot64.kickc.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * A Symbol (variable, jump label, etc.)
 */
public class VariableUnversioned extends Variable {

   /**
    * The number of the next version
    */
   private Integer nextVersionNumber;

   public VariableUnversioned(
         String name,
         Scope scope,
         SymbolType type) {
      super(name, scope, type);
      this.nextVersionNumber = 0;
   }

   @JsonCreator
   public VariableUnversioned(
         @JsonProperty("name") String name,
         @JsonProperty("type") SymbolType type,
         @JsonProperty("nextVersionNumber") Integer nextVersionNumber) {
      super(name, null, type);
      this.nextVersionNumber = nextVersionNumber;
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

   public VariableVersion createVersion() {
         VariableVersion version = new VariableVersion(this, this.getNextVersionNumber());
         getScope().add(version);
         return version;
   }
}
