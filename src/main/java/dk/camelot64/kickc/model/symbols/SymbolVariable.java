package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.Registers;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantRef;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.SymbolVariableRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
import java.util.List;

/** Abstract Variable or a Constant Variable */
public class SymbolVariable implements Symbol {

   /** The name of the variable. */
   private String name;

   /** The scope containing the variable */
   private Scope scope;

   /** The type of the variable. VAR means tha type is unknown, and has not been inferred yet. */
   private SymbolType type;

   /** true if the symbol type is inferred (not declared) */
   private boolean inferredType;

   /** A short name used for the variable in ASM code. If possible variable names of variables are shortened in ASM code. This is possible, when several versions of the var use the same register. */
   private String asmName;

   /** True of the variable is a compile-time constant (previously ConstantVar*/
   private boolean isConstant;

   /** Specifies whether the symbol is declared to be constant, never constant or maybe constant. */
   public enum ConstantDeclaration {
      CONST, NOT_CONST, MAYBE_CONST
   }

   /** Specifies that the variable is declared a constant. It will be replaced by a ConstantVar when possible. */
   private ConstantDeclaration constantDeclaration;

   /** Specifies that the variable must be aligned in memory. Only allowed for arrays & strings. */
   private Integer declaredAlignment;

   /** Specifies the register the variable must be put into during execution. */
   private Registers.Register declaredRegister;

   /** Specifies that the variable must always live in memory to be available for any multi-threaded accees (eg. in interrupts). */
   private boolean declaredVolatile;

   /** Specifies that the variable must always live in memory to be available for any multi-threaded accees (eg. in interrupts). */
   private boolean inferedVolatile;

   /** Specifies that the variable must always be added to the output ASM even if it is never used anywhere. */
   private boolean declaredExport;

   /** Specifies that the variable must live in a register if possible (CPU register or ZP-address). */
   private boolean declaredAsRegister;

   /** Specifies that the variable must live in memory. */
   private boolean declaredAsNotRegister;

   /**
    * Strategy being used for storing and accessing the variable. The value depends on the directives memory/register/volatile/const - and on the compilers optimization decisions.
    * <ul>
    * <li>PHI variables are turned into versions and PHI-nodes are used for them throughout the entire program. They cannot be "volatile" and the "address-of" operator cannot be used on them.</li>
    * <li>INTERMEDIATE variables are created when expressions are broken into smaller statements. </li>
    * <li>LOAD_STORE variables are accessed through load/store operations. </li>
    * <li>CONSTANT variables are constant.
    * </ul>
    **/
   public enum StorageStrategy {
      PHI_MASTER, PHI_VERSION, INTERMEDIATE, LOAD_STORE, CONSTANT
   }

   /** The storage strategy for the variable. */
   private StorageStrategy storageStrategy;

   /** Memory area used for storing the variable (if is is stored in memory). */
   public enum MemoryArea {
      ZEROPAGE_MEMORY, MAIN_MEMORY
   }

   /** The memory area where the variable lives (if stored in memory). */
   private MemoryArea memoryArea;

   /** Comments preceding the procedure in the source code. */
   private List<Comment> comments;

   /** Full name of variable (scope::name or name) */
   private String fullName;

   /** The data segment to put the variable into (if it is allocated in memory). */
   private String dataSegment;

   /** The constant value if the variable is a constant. Null otherwise. */
   private ConstantValue constantValue;

   /** The number of the next version (only used for PHI masters) */
   private Integer nextPhiVersionNumber;

   /** If the variable is assigned to a specific "register", this contains the register. If null the variable has no allocation (yet). Constants are never assigned to registers. */
   private Registers.Register allocation;

   public SymbolVariable(boolean isConstant, String name, Scope scope, SymbolType type, StorageStrategy storageStrategy, MemoryArea memoryArea, String dataSegment) {
      this.isConstant = isConstant;
      this.name = name;
      this.scope = scope;
      this.type = type;
      this.inferredType = false;
      this.comments = new ArrayList<>();
      this.dataSegment = dataSegment;
      this.storageStrategy = storageStrategy;
      this.memoryArea = memoryArea;
      this.constantDeclaration = ConstantDeclaration.MAYBE_CONST;
      setFullName();
      if(isStoragePhiMaster())
         this.nextPhiVersionNumber = 0;
   }

   public SymbolVariable(String name, Scope scope, SymbolType type, String dataSegment, ConstantValue value) {
      this(true, name, scope, type, StorageStrategy.CONSTANT, MemoryArea.MAIN_MEMORY, dataSegment);
      setConstantValue(value);
   }

      /**
       * Create a version of a PHI master variable
       *
       * @param phiMaster The PHI master variable.
       * @param version The version number
       */
   public SymbolVariable(SymbolVariable phiMaster, int version) {
      this(false, phiMaster.getName() + "#" + version, phiMaster.getScope(), phiMaster.getType(), StorageStrategy.PHI_VERSION, phiMaster.getMemoryArea(), phiMaster.getDataSegment());
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

   /**
    * True if the variable is a compile time constant. (Previously this was ConstantVar)
    * @return True if the variable is a compile time constant.
    */
   public boolean isConstant() {
      return isConstant;
   }

   /**
    * True if the variable is a not compile time constant. (Previously this was Variable)
    * @return True if the variable is not a compile-time constant
    */
   public boolean isVariable() {
      return !isConstant;
   }

   public SymbolVariableRef getRef() {
      if(isConstant)
         return new ConstantRef(this);
      else
         return new VariableRef(this);
   }

   public ConstantRef getConstantRef() {
      return (ConstantRef) getRef();
   }

   public VariableRef getVariableRef() {
      return (VariableRef) getRef();
   }

   private void setFullName() {
      String scopeName = (scope == null) ? "" : scope.getFullName();
      fullName = (scopeName.length() > 0) ? scopeName + "::" + name : name;
   }

   /**
    * Creates a new PHI-version from a PHI-master
    *
    * @return The new version of the PHI master
    */
   public SymbolVariable createVersion() {
      if(!isStoragePhiMaster())
         throw new InternalError("Cannot version non-PHI variable " + this.toString());
      SymbolVariable version = new SymbolVariable(this, nextPhiVersionNumber++);
      getScope().add(version);
      return version;
   }

   /**
    * If the variable is a version of a variable returns the original variable.
    *
    * @return The original variable. Null if this is not a version.
    */
   public SymbolVariable getVersionOf() {
      if(!isStoragePhiVersion())
         throw new InternalError("Cannot get master for non-PHI version variable " + this.toString());
      String name = getName();
      String versionOfName = name.substring(0, name.indexOf("#"));
      return getScope().getVariable(versionOfName);
   }


   public Registers.Register getAllocation() {
      return allocation;
   }

   public void setAllocation(Registers.Register allocation) {
      this.allocation = allocation;
   }

   public ConstantValue getConstantValue() {
      return constantValue;
   }

   public void setConstantValue(ConstantValue value) {
      this.constantValue = value;
   }

   public String getDataSegment() {
      return dataSegment;
   }

   @Override
   public String getLocalName() {
      return name;
   }

   @Override
   public String getFullName() {
      return this.fullName;
   }

   public SymbolType getType() {
      return type;
   }

   public void setType(SymbolType type) {
      this.type = type;
   }

   public void setTypeInferred(SymbolType type) {
      this.type = type;
      this.inferredType = true;
   }

   public boolean isInferredType() {
      return inferredType;
   }

   public void setInferredType(boolean inferredType) {
      this.inferredType = inferredType;
   }

   public String getName() {
      return name;
   }

   public void setName(String name) {
      this.name = name;
      setFullName();
   }

   public String getAsmName() {
      return asmName;
   }

   public void setAsmName(String asmName) {
      this.asmName = asmName;
   }

   public Scope getScope() {
      return scope;
   }

   public void setScope(Scope scope) {
      this.scope = scope;
      setFullName();
   }

   @Override
   public int getScopeDepth() {
      if(scope == null) {
         return 0;
      } else {
         return scope.getScopeDepth() + 1;
      }
   }

   public void setConstantDeclaration(ConstantDeclaration constantDeclaration) {
      this.constantDeclaration = constantDeclaration;
   }

   public ConstantDeclaration getConstantDeclaration() {
      return constantDeclaration;
   }

   public boolean isDeclaredConstant() {
      return ConstantDeclaration.CONST.equals(constantDeclaration);
   }

   public boolean isDeclaredNotConstant() {
      return ConstantDeclaration.NOT_CONST.equals(constantDeclaration);
   }

   public Integer getDeclaredAlignment() {
      return declaredAlignment;
   }

   public void setDeclaredAlignment(Integer declaredAlignment) {
      this.declaredAlignment = declaredAlignment;
   }

   public Registers.Register getDeclaredRegister() {
      return declaredRegister;
   }

   public void setDeclaredRegister(Registers.Register declaredRegister) {
      this.declaredRegister = declaredRegister;
   }

   public boolean isDeclaredVolatile() {
      return declaredVolatile;
   }

   public void setDeclaredVolatile(boolean declaredVolatile) {
      this.declaredVolatile = declaredVolatile;
   }

   public void setInferedVolatile(boolean inferedVolatile) {
      this.inferedVolatile = inferedVolatile;
   }

   public boolean isInferedVolatile() {
      return inferedVolatile;
   }

   public boolean isVolatile() {
      return declaredVolatile || inferedVolatile;
   }

   public boolean isDeclaredExport() {
      return declaredExport;
   }

   public void setDeclaredExport(boolean declaredExport) {
      this.declaredExport = declaredExport;
   }

   public boolean isDeclaredAsRegister() {
      return declaredAsRegister;
   }

   public void setDeclaredAsRegister(boolean declaredAsRegister) {
      this.declaredAsRegister = declaredAsRegister;
   }

   public boolean isDeclaredAsNotRegister() {
      return declaredAsNotRegister;
   }

   public void setDeclaredNotRegister(boolean declaredAsMemory) {
      this.declaredAsNotRegister = declaredAsMemory;
   }

   public StorageStrategy getStorageStrategy() {
      return storageStrategy;
   }

   public void setStorageStrategy(StorageStrategy storageStrategy) {
      this.storageStrategy = storageStrategy;
   }

   public boolean isStorageConstant() {
      return StorageStrategy.CONSTANT.equals(getStorageStrategy());
   }

   public boolean isStoragePhiMaster() {
      return StorageStrategy.PHI_MASTER.equals(getStorageStrategy());
   }

   public boolean isStoragePhiVersion() {
      return StorageStrategy.PHI_VERSION.equals(getStorageStrategy());
   }

   public boolean isStorageLoadStore() {
      return StorageStrategy.LOAD_STORE.equals(getStorageStrategy());
   }

   public boolean isStorageIntermediate() {
      return StorageStrategy.INTERMEDIATE.equals(getStorageStrategy());
   }

   public MemoryArea getMemoryArea() {
      return memoryArea;
   }

   public void setMemoryArea(MemoryArea memoryArea) {
      this.memoryArea = memoryArea;
   }

   public boolean isMemoryAreaZp() {
      return MemoryArea.ZEROPAGE_MEMORY.equals(getMemoryArea());
   }

   public boolean isMemoryAreaMain() {
      return MemoryArea.MAIN_MEMORY.equals(getMemoryArea());
   }

   public List<Comment> getComments() {
      return comments;
   }

   public void setComments(List<Comment> comments) {
      this.comments = comments;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      return new StringBuilder()
            .append("(")
            .append((constantValue != null) ? "const " : "")
            .append(getType().getTypeName())
            .append((constantValue==null&&inferredType) ? "~" : "")
            .append(") ")
            .append(getFullName()).toString();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) {
         return true;
      }
      if(o == null || getClass() != o.getClass()) {
         return false;
      }

      SymbolVariable variable = (SymbolVariable) o;
      if(name != null ? !name.equals(variable.name) : variable.name != null) {
         return false;
      }
      if(scope != null ? !scope.equals(variable.scope) : variable.scope != null) {
         return false;
      }
      if(type != null ? !type.equals(variable.type) : variable.type != null) {
         return false;
      }
      return asmName != null ? asmName.equals(variable.asmName) : variable.asmName == null;
   }

   @Override
   public int hashCode() {
      int result = name != null ? name.hashCode() : 0;
      result = 31 * result + (scope != null ? scope.hashCode() : 0);
      result = 31 * result + (type != null ? type.hashCode() : 0);
      result = 31 * result + (asmName != null ? asmName.hashCode() : 0);
      return result;
   }

}
