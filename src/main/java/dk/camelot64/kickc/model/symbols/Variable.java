package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.Registers;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.Objects;

/** A Variable (or a Constant) */
public class Variable extends SymbolVariable {

   /** true if the variable is intermediate. */
   private boolean isIntermediate;

   /* true if the variable is a PHI version. (the variable has storage strategy PHI)*/
   private boolean isVersion;

   /** If the variable is assigned to a specific "register", this contains the register. If null the variable has no allocation (yet). Constants are never assigned to registers. */
   private Registers.Register allocation;

   public Variable(String name, Scope scope, SymbolType type, String dataSegment, boolean isIntermediate, boolean isVersion) {
      super(name, scope, type, dataSegment);
      this.isIntermediate = isIntermediate;
      this.isVersion = isVersion;
   }

   public Variable(VariableUnversioned versionOf, int version) {
      super(versionOf.getName()+"#"+version, versionOf.getScope(), versionOf.getType(), versionOf.getDataSegment());
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
      this.setComments(versionOf.getComments());
      this.isIntermediate = false;
      this.isVersion = true;
   }


   public Registers.Register getAllocation() {
      return allocation;
   }

   public void setAllocation(Registers.Register allocation) {
      this.allocation = allocation;
   }

   public boolean isVersioned() {
      return isVersion;
   }

   public boolean isIntermediate() {
      return isIntermediate;
   }

   /**
    * If the variable is a version of a variable returns the original variable.
    * @return The original variable. Null if this is not a version.
    */
   public VariableUnversioned getVersionOf() {
      if(isVersioned()) {
         String name = getName();
         String versionOfName = name.substring(0, name.indexOf("#"));
         return (VariableUnversioned) getScope().getVariable(versionOfName);
      } else {
         return null;
      }
   }

   public VariableRef getRef() {
      return new VariableRef(this);
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      if(!super.equals(o)) return false;
      Variable variable = (Variable) o;
      return isIntermediate == variable.isIntermediate &&
            isVersion == variable.isVersion &&
            Objects.equals(allocation, variable.allocation);
   }

   @Override
   public int hashCode() {
      return Objects.hash(super.hashCode(), isIntermediate, isVersion, allocation);
   }
}
