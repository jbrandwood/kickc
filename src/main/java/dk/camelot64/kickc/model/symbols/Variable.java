package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.ConstantRef;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.SymbolVariableRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * A Variable symbol (can either be a runtime variable or a compile-time constant).
 * <p>
 * Array values are implemented as {@link Kind#CONSTANT}s with the array data in {@link #getInitValue()} and the declared size in {@link #getArraySpec()}.
 * Struct values are implemented as {@link Kind#LOAD_STORE}s with the initial data in {@link #getInitValue()} or as {@link Kind#PHI_MASTER}s that will be unwound to member variables during compilation.
 * </p>
 **/
public class Variable implements Symbol {

   /**
    * The kind of the variable. The kind is the most significant property of the variable since it drives most of the behavior.
    * <p>
    * The value depends on the directives memory/register/volatile/const - and on the compilers optimization decisions.
    * <ul>
    * <li>PHI_MASTER variables are turned into PHI-versions and PHI-nodes are used for them throughout the entire program. The PHI-master itself is only an information container and does not live in memory at runtime.</li>
    * <li>PHI_VERSION variables are versions of a PHI-master. A PHI-version lives in memory or a register at runtime.</li>
    * <li>INTERMEDIATE variables are created when expressions are broken into smaller statements. The type of intermediate variables must be inferred by the compiler. An intermediate variable lives in memory or a register at runtime.</li>
    * <li>LOAD_STORE variables are accessed through load/store operations. They can have hardcoded memory addresses. A load/store-variable lives in memory or a register at runtime</li>
    * <li>CONSTANT variables are compile-time constants. They do not live in memory at runtime. As a special case arrays are compile-time constants. The array itself lives in memory. The variable holding the array cannot be assigned and hence is constant.
    * </ul>
    **/
   public enum Kind {
      PHI_MASTER, PHI_VERSION, INTERMEDIATE, LOAD_STORE, CONSTANT
   }

   /** The kind of the variable. */
   private Kind kind;

   /** The local name of the variable. [ALL] */
   private String name;

   /** Full name of variable including scope (scope::name or name) [ALL] */
   private String fullName;

   /** A short name used for the variable in ASM code. If possible variable names of variables are shortened in ASM code. This is possible, when several versions of the var use the same register. [ALL] */
   private String asmName;

   /** The scope containing the variable. [ALL] */
   private Scope scope;

   /** The type of the variable. VAR means the type is unknown, and has not been inferred yet. [ALL] */
   private SymbolType type;

   /** Specifies that the variable is a local permanent variable (local variable static keyword) */
   private boolean permanent;

   /** Specifies that the variable must always be added to the output ASM even if it is never used anywhere. (export keyword) */
   private boolean export;

   /** Specifies that the should be optimized (register keyword). */
   private boolean optimize;

   /** Specifies the hard-coded register the variable must be put into during execution. [Only variables] */
   private Registers.Register register;

   /** Memory area used for storing the variable (if is is stored in memory). */
   public enum MemoryArea {
      ZEROPAGE_MEMORY, MAIN_MEMORY
   }

   /** The memory area where the variable lives (if stored in memory). [Only variables and arrays] */
   private MemoryArea memoryArea;

   /** Specifies that the variable must be aligned in memory. Only allowed for arrays & strings. [Only Variables in memory and arrays] */
   private Integer memoryAlignment;

   /** Specifies that the variable must be placed at an absolute address in memory. Only allowed for arrays & strings. [Only Variables in memory and arrays] */
   private ConstantValue memoryAddress;

   /** The data segment to put the variable into (if it is allocated in memory). [Only variables stored in memory and arrays] */
   private String dataSegment;

   /** Comments preceding the procedure in the source code. [ALL] */
   private List<Comment> comments;

   /** The initial compiletime-value of the variable. Null if no initial value present. [Constants, Arrays, global/local-static loadstore-variables ] */
   private ConstantValue initValue;

   /** The number of the next version (only used for PHI masters) [Only PHI masters] */
   private Integer nextPhiVersionNumber;

   /** If the variable is assigned to a specific "register", this contains the register. If null the variable has no allocation (yet). Constants are never assigned to registers. [Only variables - not constants and not PHI masters] */
   private Registers.Register allocation;

   /** If the variable is only declared and not defined (using the "extern" keyword). */
   private boolean declarationOnly;

   /** If the variable is a struct that is/should be unwound to variables for each member. */
   private boolean structUnwind;

   /**
    * Create a variable (or constant)
    *
    * @param name The name
    * @param kind The storage strategy (PHI-master/PHI-version/Intermediate/load store/constant)
    * @param type The type
    * @param scope The scope
    * @param memoryArea The memory area (zeropage/main memory)
    * @param dataSegment The data segment (in main memory)
    * @param initValue The constant value of the variable (if it is constant)
    */
   public Variable(String name, Kind kind, SymbolType type, Scope scope, MemoryArea memoryArea, String dataSegment, ConstantValue initValue) {
      this.name = name;
      this.kind = kind;
      if(Kind.PHI_MASTER.equals(kind))
         this.nextPhiVersionNumber = 0;
      this.type = type;
      this.scope = scope;
      this.dataSegment = dataSegment;
      this.memoryArea = memoryArea;
      this.initValue = initValue;
      this.comments = new ArrayList<>();
      setFullName();
   }

   /**
    * Create a version of a PHI master variable
    *
    * @param phiMaster The PHI master variable.
    * @param versionNum The version number
    */
   public static Variable createPhiVersion(Variable phiMaster, int versionNum) {
      if(!phiMaster.isKindPhiMaster())
         throw new InternalError("Cannot version non-PHI variable " + phiMaster.toString());
      Variable version = new Variable(phiMaster.getName() + "#" + versionNum, Kind.PHI_VERSION, phiMaster.getType(), phiMaster.getScope(), phiMaster.getMemoryArea(), phiMaster.getDataSegment(), null);
      version.setMemoryAlignment(phiMaster.getMemoryAlignment());
      version.setMemoryAddress(phiMaster.getMemoryAddress());
      version.setOptimize(phiMaster.isOptimize());
      version.setRegister(phiMaster.getRegister());
      version.setPermanent(phiMaster.isPermanent());
      version.setExport(phiMaster.isExport());
      version.setComments(phiMaster.getComments());
      version.setStructUnwind(phiMaster.isStructUnwind());
      return version;
   }

   /**
    * Creates a new PHI-version from a PHI-master
    *
    * @return The new version of the PHI master
    */
   public Variable createVersion() {
      Variable version = Variable.createPhiVersion(this, nextPhiVersionNumber++);
      getScope().add(version);
      return version;
   }

   /**
    * Create a compile-time constant variable
    *
    * @param name The name
    * @param type The type
    * @param scope The scope
    * @param constantValue The constant value
    * @param dataSegment The data segment (in main memory)
    */
   public static Variable createConstant(String name, SymbolType type, Scope scope, ConstantValue constantValue, String dataSegment) {
      return new Variable(name, Kind.CONSTANT, type, scope, MemoryArea.MAIN_MEMORY, dataSegment, constantValue);
   }

   /**
    * Create a constant version of a variable. Used when a variable is determined to be constant during the compile.
    *
    * @param variable The variable to create a constant version of
    * @param constantValue The constant value
    */
   public static Variable createConstant(Variable variable, ConstantValue constantValue) {
      Variable constVar = new Variable(variable.getName(), Kind.CONSTANT, variable.getType(), variable.getScope(), MemoryArea.MAIN_MEMORY, variable.getDataSegment(), constantValue);
      constVar.setMemoryAlignment(variable.getMemoryAlignment());
      constVar.setMemoryAddress(variable.getMemoryAddress());
      constVar.setOptimize(variable.isOptimize());
      constVar.setRegister(variable.getRegister());
      constVar.setPermanent(variable.isPermanent());
      constVar.setExport(variable.isExport());
      constVar.setComments(variable.getComments());
      constVar.setStructUnwind(variable.isStructUnwind());
      return constVar;
   }

   /**
    * Create a copy of a variable with a different name in a different scope
    *
    * @param name The name for the new variable
    * @param scope The scope for the new variable
    * @param original The original variable
    */
   public static Variable createCopy(String name, Scope scope, Variable original) {
      Variable copy = new Variable(name, original.getKind(), original.getType(), scope, original.getMemoryArea(), original.getDataSegment(), original.getInitValue());
      copy.setMemoryAlignment(original.getMemoryAlignment());
      copy.setMemoryAddress(original.getMemoryAddress());
      copy.setOptimize(original.isOptimize());
      copy.setPermanent(original.isPermanent());
      copy.setExport(original.isExport());
      copy.setRegister(original.getRegister());
      copy.setComments(original.getComments());
      copy.setStructUnwind(original.isStructUnwind());
      return copy;
   }

   /**
    * Create a variable representing a single member of a struct variable.
    *
    * @param structVar The variable that holds a struct value.
    * @param memberDefinition The definition of the struct member
    * @param isParameter True if the structVar is a parameter to a procedure
    * @return The new unwound variable representing the member of the struct
    */
   public static Variable createStructMemberUnwound(Variable structVar, Variable memberDefinition, boolean isParameter) {
      String name = structVar.getLocalName() + "_" + memberDefinition.getLocalName();
      Variable.MemoryArea memoryArea = (memberDefinition.getType() instanceof SymbolTypePointer) ? Variable.MemoryArea.ZEROPAGE_MEMORY : structVar.getMemoryArea();
      Variable memberVariable;
      if(isParameter && memberDefinition.isArray()) {
         // Array struct members are converted to pointers when unwound (use same kind as the struct variable)
         SymbolTypePointer arrayType = (SymbolTypePointer) memberDefinition.getType();
         SymbolType typeQualified = new SymbolTypePointer(arrayType.getElementType()).getQualified(structVar.isVolatile(), structVar.isNoModify());
         memberVariable = new Variable(name, structVar.getKind(), typeQualified, structVar.getScope(), memoryArea, structVar.getDataSegment(), null);
      } else if(memberDefinition.isKindConstant()) {
         // Constant members are unwound as constants
         SymbolType typeQualified = memberDefinition.getType().getQualified(structVar.isVolatile(), structVar.isNoModify());
         memberVariable = new Variable(name, Kind.CONSTANT, typeQualified, structVar.getScope(), memoryArea, structVar.getDataSegment(), memberDefinition.getInitValue());
      } else {
         // For others the kind is preserved from the member definition
         SymbolType typeQualified = memberDefinition.getType().getQualified(structVar.isVolatile(), structVar.isNoModify());
         memberVariable = new Variable(name, structVar.getKind(),typeQualified, structVar.getScope(), memoryArea, structVar.getDataSegment(), memberDefinition.getInitValue());
      }
      memberVariable.setExport(structVar.isExport());
      memberVariable.setPermanent(structVar.isPermanent());
      memberVariable.setStructUnwind(memberDefinition.isStructUnwind());
      return memberVariable;
   }

   /**
    * If the variable is a PHI-version of a PHI-master variable this returns the  PHI-master variable.
    *
    * @return The  PHI-master variable. Null if this is not a PHI-version.
    */
   public Variable getPhiMaster() {
      if(!isKindPhiVersion())
         throw new InternalError("Cannot get PHI-master for non-PHI-version variable " + this.toString());
      String name = getName();
      String versionOfName = name.substring(0, name.indexOf("#"));
      return getScope().getLocalVariable(versionOfName);
   }

   public Kind getKind() {
      return kind;
   }

   public void setKind(Kind kind) {
      this.kind = kind;
      if(kind.equals(Kind.PHI_MASTER)) {
         this.nextPhiVersionNumber = 0;
      } else
         this.nextPhiVersionNumber = null;
   }

   public boolean isKindConstant() {
      return Kind.CONSTANT.equals(getKind());
   }

   public boolean isKindPhiMaster() {
      return Kind.PHI_MASTER.equals(getKind());
   }

   public boolean isKindPhiVersion() {
      return Kind.PHI_VERSION.equals(getKind());
   }

   public boolean isKindLoadStore() {
      return Kind.LOAD_STORE.equals(getKind());
   }

   public boolean isKindIntermediate() {
      return Kind.INTERMEDIATE.equals(getKind());
   }

   /**
    * True if the variable is a not compile time constant. (Previously this was Variable)
    *
    * @return True if the variable is not a compile-time constant
    */
   public boolean isVariable() {
      return !isKindConstant();
   }

   public SymbolVariableRef getRef() {
      if(isKindConstant())
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
    * Determines if the variable is an array
    *
    * @return True if the variable is an array.
    */
   public boolean isArray() {
      return (getType() instanceof SymbolTypePointer) && (((SymbolTypePointer) getType()).getArraySpec() != null);
   }

   /**
    * If the variable is an array with a declared size this returns the size
    *
    * @return The size of the array if declared. Null if not an array or an array without a declared size.
    */
   public ConstantValue getArraySize() {
      if(isArray())
         return ((SymbolTypePointer) getType()).getArraySpec().getArraySize();
      else
         return null;
   }

   public ArraySpec getArraySpec() {
      if(isArray())
         return ((SymbolTypePointer) getType()).getArraySpec();
      else
         return null;
   }

   public boolean isStruct() {
      return type instanceof SymbolTypeStruct;
   }

   public Registers.Register getAllocation() {
      return allocation;
   }

   public void setAllocation(Registers.Register allocation) {
      this.allocation = allocation;
   }

   public ConstantValue getInitValue() {
      return initValue;
   }

   public void setInitValue(ConstantValue value) {
      this.initValue = value;
   }

   public String getDataSegment() {
      return dataSegment;
   }

   public void setDataSegment(String dataSegment) {
      this.dataSegment = dataSegment;
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

   public boolean isNoModify() {
      return type.isNomodify();
   }

   public boolean isVolatile() {
      return type.isVolatile();
   }

   public boolean isToNoModify() {
      return type instanceof SymbolTypePointer && ((SymbolTypePointer) type).getElementType().isNomodify();
   }

   public boolean isToVolatile() {
      return type instanceof SymbolTypePointer && ((SymbolTypePointer) type).getElementType().isVolatile();
   }

   public boolean isPermanent() {
      return permanent;
   }

   public void setPermanent(boolean permanent) {
      this.permanent = permanent;
   }

   public boolean isExport() {
      return export;
   }

   public void setExport(boolean export) {
      this.export = export;
   }

   public boolean isOptimize() {
      return optimize;
   }

   public void setOptimize(boolean optimize) {
      this.optimize = optimize;
   }

   public Registers.Register getRegister() {
      return register;
   }

   public void setRegister(Registers.Register register) {
      this.register = register;
   }

   public MemoryArea getMemoryArea() {
      return memoryArea;
   }

   public void setMemoryArea(MemoryArea memoryArea) {
      this.memoryArea = memoryArea;
   }

   public boolean isMemoryAreaMain() {
      return MemoryArea.MAIN_MEMORY.equals(getMemoryArea());
   }

   public Integer getMemoryAlignment() {
      return memoryAlignment;
   }

   public void setMemoryAlignment(Integer memoryAlignment) {
      this.memoryAlignment = memoryAlignment;
   }

   public ConstantValue getMemoryAddress() {
      return memoryAddress;
   }

   public void setMemoryAddress(ConstantValue memoryAddress) {
      this.memoryAddress = memoryAddress;
   }

   public void setStructUnwind(boolean structUnwind) {
      this.structUnwind = structUnwind;
   }



   /**
    * Is the variable a struct that should be unwound to member variables
    *
    * @return true if an unwinding struct
    */
   public boolean isStructUnwind() {
         return structUnwind;
   }

   /**
    * Is the variable a struct that should be handled using C Classic memory layout
    *
    * @return true if an classic struct
    */
   public boolean isStructClassic() {
      if(getType() instanceof SymbolTypeStruct) {
         return !structUnwind;
      }
      return false;
   }

   public boolean isDeclarationOnly() {
      return declarationOnly;
   }

   public void setDeclarationOnly(boolean declarationOnly) {
      this.declarationOnly = declarationOnly;
   }

   public List<Comment> getComments() {
      return comments;
   }

   public void setComments(List<Comment> comments) {
      this.comments = comments;
   }

   @Override
   public String toString() {
      return getFullName();
   }

   @Override
   public String toString(Program program) {
      return toString();
   }

   public String toCDecl() {
      StringBuilder cdecl = new StringBuilder();
      cdecl.append(getType().toCDecl(getLocalName()));
      return cdecl.toString();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      Variable variable = (Variable) o;
      return kind == variable.kind &&
            Objects.equals(name, variable.name) &&
            Objects.equals(scope.getRef(), variable.scope.getRef()) &&
            Objects.equals(type, variable.type);
   }

   @Override
   public int hashCode() {
      return Objects.hash(kind, name, scope, type);
   }
}

