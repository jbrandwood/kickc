package dk.camelot64.kickc.icl;

/** A Symbol (variable, jump label, etc.) */
public class VariableVersion extends Variable {

   private VariableUnversioned versionOf;

   public VariableVersion(VariableUnversioned versionOf, int version) {
      super(versionOf.getName()+"#"+version, versionOf.getType());
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
}
