package dk.camelot64.kickc.icl;

/** A Symbol (variable, jump label, etc.) */
public class VariableVersion extends Variable {

   private VariableUnversioned versionOf;

   public VariableVersion(VariableUnversioned versionOf, int version) {
      super(versionOf.getLocalName()+"#"+version, versionOf.getScope(), versionOf.getType());
      this.versionOf = versionOf;
   }

   @Override
   public boolean isVersioned() {
      return true;
   }

   @Override
   public boolean isIntermediate() {
      return false;
   }

   public VariableUnversioned getVersionOf() {
      return versionOf;
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;
      if (!super.equals(o)) return false;

      VariableVersion that = (VariableVersion) o;

      return versionOf != null ? versionOf.equals(that.versionOf) : that.versionOf == null;
   }

   @Override
   public int hashCode() {
      int result = super.hashCode();
      result = 31 * result + (versionOf != null ? versionOf.hashCode() : 0);
      return result;
   }
}
