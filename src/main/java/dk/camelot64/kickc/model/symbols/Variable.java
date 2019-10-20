package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Registers;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.Objects;

/**
 * A Variable in the program.
 * <p>
 * There are several types of variables
 * <p>
 * - Intermediate: A variable added by the compiler to hold some intermediate value. Intermediate variables are names $1, $2, ...
 * - PHI-variable: A variable with storage strategy PHI is turned into versions. The variable itself is never used directly in the program.
 * - PHI-versions: A variable with storage strategy PHI is turned into versions. Versions of the PHI-variable name are named name#1, name#2, name#3
 * - Memory: A variable with storage strategy memory is used directly in the program.
 */
public class Variable extends SymbolVariable {

   /** The number of the next version (only used for PHI masters) */
   private Integer nextPhiVersionNumber;

   /** If the variable is assigned to a specific "register", this contains the register. If null the variable has no allocation (yet). Constants are never assigned to registers. */
   private Registers.Register allocation;

   public Variable(String name, Scope scope, SymbolType type, String dataSegment, StorageStrategy storageStrategy, MemoryArea memoryArea) {
      super(name, scope, type, storageStrategy, memoryArea, dataSegment);
      if(isStoragePhiMaster())
         this.nextPhiVersionNumber = 0;
   }

   /**
    * Create a version of a PHI master variable
    *
    * @param phiMaster The PHI master variable.
    * @param version The version number
    */
   public Variable(Variable phiMaster, int version) {
      super(phiMaster.getName() + "#" + version, phiMaster.getScope(), phiMaster.getType(), StorageStrategy.PHI_VERSION, phiMaster.getMemoryArea(), phiMaster.getDataSegment());
      this.setDeclaredAlignment(phiMaster.getDeclaredAlignment());
      this.setDeclaredAsRegister(phiMaster.isDeclaredAsRegister());
      this.setDeclaredNotRegister(phiMaster.isDeclaredAsNotRegister());
      this.setConstantDeclaration(phiMaster.getConstantDeclaration());
      this.setDeclaredRegister(phiMaster.getDeclaredRegister());
      this.setDeclaredVolatile(phiMaster.isDeclaredVolatile());
      this.setDeclaredExport(phiMaster.isDeclaredExport());
      this.setInferedVolatile(phiMaster.isInferedVolatile());
      this.setInferredType(phiMaster.isInferredType());
      this.setComments(phiMaster.getComments());
   }

   public VariableRef getRef() {
      return new VariableRef(this);
   }

   public Registers.Register getAllocation() {
      return allocation;
   }

   public void setAllocation(Registers.Register allocation) {
      this.allocation = allocation;
   }


   /**
    * Creates a new PHI-version from a PHI-master
    *
    * @return The new version of the PHI master
    */
   public Variable createVersion() {
      if(!isStoragePhiMaster())
         throw new InternalError("Cannot version non-PHI variable " + this.toString());
      Variable version = new Variable(this, nextPhiVersionNumber++);
      getScope().add(version);
      return version;
   }

   /**
    * If the variable is a version of a variable returns the original variable.
    *
    * @return The original variable. Null if this is not a version.
    */
   public Variable getVersionOf() {
      if(!isStoragePhiVersion())
         throw new InternalError("Cannot get master for non-PHI version variable " + this.toString());
      String name = getName();
      String versionOfName = name.substring(0, name.indexOf("#"));
      return getScope().getVariable(versionOfName);
   }


   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      if(!super.equals(o)) return false;
      Variable variable = (Variable) o;
      return Objects.equals(allocation, variable.allocation);
   }

   @Override
   public int hashCode() {
      return Objects.hash(super.hashCode(), allocation);
   }
}
