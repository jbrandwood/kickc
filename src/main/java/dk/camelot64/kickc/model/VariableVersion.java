package dk.camelot64.kickc.model;

/** A Symbol (variable, jump label, etc.) */
public class VariableVersion extends Variable {

   private String versionOfName;

   public VariableVersion(VariableUnversioned versionOf, int version) {
      super(versionOf.getLocalName() + "#" + version, versionOf.getScope(), versionOf.getType());
      this.setDeclaredAlignment(versionOf.getDeclaredAlignment());
      this.versionOfName = versionOf.getLocalName();
   }

   public VariableVersion(
         String name,
         SymbolType type,
         String versionOfName) {
      super(name, null, type);
      this.versionOfName = versionOfName;
   }

   @Override
   public boolean isVersioned() {
      return true;
   }

   public VariableUnversioned getVersionOf() {
      return (VariableUnversioned) getScope().getVariable(versionOfName);
   }

   public String getVersionOfName() {
      return versionOfName;
   }

   public void setVersionOfName(String versionOfName) {
      this.versionOfName = versionOfName;
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
