package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.types.SymbolType;

/** A Versioned variable. Versions are created for REGISTER-variables that are handled through PHI-nodes. */
public class VariableVersion extends Variable {

   private String versionOfName;

   public VariableVersion(VariableUnversioned versionOf, int version) {
      super(versionOf.getLocalName() + "#" + version, versionOf.getScope(), versionOf.getType(), versionOf.getDataSegment(), false, true);
      this.setDeclaredAlignment(versionOf.getDeclaredAlignment());
      this.setDeclaredAsRegister(versionOf.isDeclaredAsRegister());
      this.setDeclaredAsMemory(versionOf.isDeclaredAsMemory());
      this.setDeclaredRegister(versionOf.getDeclaredRegister());
      this.setDeclaredMemoryAddress(versionOf.getDeclaredMemoryAddress());
      this.setStorageStrategy(versionOf.getStorageStrategy());
      this.setDeclaredVolatile(versionOf.isDeclaredVolatile());
      this.setDeclaredExport(versionOf.isDeclaredExport());
      this.setInferedVolatile(versionOf.isInferedVolatile());
      this.setInferredType(versionOf.isInferredType());
      this.versionOfName = versionOf.getLocalName();
      this.setComments(versionOf.getComments());
   }

   public VariableVersion(
         String name,
         SymbolType type,
         String versionOfName) {
      super(name, null, type, Scope.SEGMENT_DATA_DEFAULT, false, true);
      this.versionOfName = versionOfName;
   }

   public VariableUnversioned getVersionOf() {
      return (VariableUnversioned) getScope().getVariable(versionOfName);
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) {
         return true;
      }
      if(o == null || getClass() != o.getClass()) {
         return false;
      }
      if(!super.equals(o)) {
         return false;
      }
      VariableVersion that = (VariableVersion) o;
      return versionOfName != null ? versionOfName.equals(that.versionOfName) : that.versionOfName == null;
   }

   @Override
   public int hashCode() {
      int result = super.hashCode();
      result = 31 * result + (versionOfName != null ? versionOfName.hashCode() : 0);
      return result;
   }
}
