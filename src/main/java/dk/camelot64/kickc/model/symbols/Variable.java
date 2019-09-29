package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Registers;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.Objects;

/** A Variable in the program.
 *
 * There are several types of variables
 *
 * - Intermediate: A variable added by the compiler to hold some intermediate value. Intermediate variables are names $1, $2, ...
 * - PHI-variable: A variable with storage strategy PHI is turned into versions. The variable itself is never used directly in the program.
 * - PHI-versions: A variable with storage strategy PHI is turned into versions. Versions of the PHI-variable name are named name#1, name#2, name#3
 * - Memory: A variable with storage strategy memory is used directly in the program.
 * */
public class Variable extends SymbolVariable {

   /** true if the variable is intermediate. */
   private boolean isIntermediate;

   /* true if the variable is a PHI master variable that is turned into versions. (the variable has storage strategy PHI)*/
   private boolean isPhiMaster;

   /** The number of the next version (only used for PHI masters)*/
   private Integer nextPhiVersionNumber;

   /* true if the variable is a PHI version. (the "master" variable has storage strategy PHI)*/
   private boolean isPhiVersion;

   /** If the variable is assigned to a specific "register", this contains the register. If null the variable has no allocation (yet). Constants are never assigned to registers. */
   private Registers.Register allocation;

   public Variable(String name, Scope scope, SymbolType type, String dataSegment, StorageStrategy storageStrategy, boolean isIntermediate, boolean isPhiVersion, boolean isPhiMaster) {
      super(name, scope, type, storageStrategy, dataSegment);
      this.isIntermediate = isIntermediate;
      this.isPhiVersion = isPhiVersion;
      this.isPhiMaster = isPhiMaster;
      if(isPhiMaster)
         this.nextPhiVersionNumber = 0;
   }

   /**
    * Create a version of a PHI master variable
    * @param phiMaster The PHI master variable.
    * @param version The version number
    */
   public Variable(Variable phiMaster, int version) {
      super(phiMaster.getName()+"#"+version, phiMaster.getScope(), phiMaster.getType(), StorageStrategy.PHI_VERSION, phiMaster.getDataSegment());
      this.setDeclaredAlignment(phiMaster.getDeclaredAlignment());
      this.setDeclaredAsRegister(phiMaster.isDeclaredAsRegister());
      this.setDeclaredAsMemory(phiMaster.isDeclaredAsMemory());
      this.setDeclaredRegister(phiMaster.getDeclaredRegister());
      this.setDeclaredMemoryAddress(phiMaster.getDeclaredMemoryAddress());
      this.setDeclaredVolatile(phiMaster.isDeclaredVolatile());
      this.setDeclaredExport(phiMaster.isDeclaredExport());
      this.setInferedVolatile(phiMaster.isInferedVolatile());
      this.setInferredType(phiMaster.isInferredType());
      this.setComments(phiMaster.getComments());
      this.isPhiMaster = false;
      this.isPhiVersion = true;
      this.isIntermediate = false;
   }

   public Registers.Register getAllocation() {
      return allocation;
   }

   public void setAllocation(Registers.Register allocation) {
      this.allocation = allocation;
   }

   public boolean isPhiMaster() {
      /*
      if(isPhiMaster) {
         if(!StorageStrategy.PHI_MASTER.equals(getStorageStrategy())) {
            System.out.println("PHI master mismatch!");
         };
      }
      return StorageStrategy.PHI_MASTER.equals(getStorageStrategy());
       */
      return isPhiMaster;
   }

   public boolean isPhiVersion() {
      return isPhiVersion;
   }

   public boolean isIntermediate() {
      return isIntermediate;
   }

   /**
    * Creates a new PHI-version from a PHI-master
    * @return The new version of the PHI master
    */
   public Variable createVersion() {
      if(!isPhiMaster)
         throw new InternalError("Cannot version non-PHI variable");
      Variable version = new Variable(this, nextPhiVersionNumber++);
      getScope().add(version);
      return version;
   }

   /**
    * If the variable is a version of a variable returns the original variable.
    * @return The original variable. Null if this is not a version.
    */
   public Variable getVersionOf() {
      if(isPhiVersion()) {
         String name = getName();
         String versionOfName = name.substring(0, name.indexOf("#"));
         return getScope().getVariable(versionOfName);
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
            isPhiVersion == variable.isPhiVersion &&
            Objects.equals(allocation, variable.allocation);
   }

   @Override
   public int hashCode() {
      return Objects.hash(super.hashCode(), isIntermediate, isPhiVersion, allocation);
   }
}
