package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.Registers;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.ConstantRef;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.SymbolVariableRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/** A Variable symbol (can either be a runtime variable or a compile-time constant) */
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
    * <li>CONSTANT variables are compile-time constants. They do not live in memory at runtime. An array is a compile-time constant pointer. The array itself lives in memory but the pointer does not.
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

   /** Specifies that the variable must be aligned in memory. Only allowed for arrays & strings. [Only Variables in memory and arrays] */
   private Integer declaredAlignment;

   /** Specifies the register the variable must be put into during execution. [Only variables] */
   private Registers.Register declaredRegister;

   /** Specifies that the variable is declared as const */
   private boolean declaredConst;

   /** Specifies that the variable must always live in memory to be available for any multi-threaded accees (eg. in interrupts). [Only Variables] */
   private boolean declaredVolatile;

   /** Specifies that the variable must always live in memory to be available for any multi-threaded accees (eg. in interrupts). [Only variables] TODO: Remove this */
   private boolean inferredVolatile;

   /** Specifies that the variable must always be added to the output ASM even if it is never used anywhere. */
   private boolean declaredExport;

   /** Specifies that the variable must live in a register if possible (CPU register or ZP-address). */
   private boolean declaredAsRegister;

   /** The memory area where the variable lives (if stored in memory). [Only variables and arrays] */
   private MemoryArea memoryArea;

   /** Comments preceding the procedure in the source code. [ALL] */
   private List<Comment> comments;

   /** The data segment to put the variable into (if it is allocated in memory). [Only variables stored in memory and arrays] */
   private String dataSegment;

   /** The constant value if the variable is a constant. Null otherwise. [Only constants] */
   private ConstantValue constantValue;

   /** Non-null if the variable is an array. [Only constants that are arrays] */
   private ArraySpec arraySpec;

   /** The number of the next version (only used for PHI masters) [Only PHI masters] */
   private Integer nextPhiVersionNumber;

   /** If the variable is assigned to a specific "register", this contains the register. If null the variable has no allocation (yet). Constants are never assigned to registers. [Only variables - not constants and not PHI masters] */
   private Registers.Register allocation;

   /** Memory area used for storing the variable (if is is stored in memory). */
   public enum MemoryArea {
      ZEROPAGE_MEMORY, MAIN_MEMORY
   }

   /**
    * Create a variable (or constant)
    *
    * @param name The name
    * @param kind The storage strategy (PHI-master/PHI-version/Intermediate/load store/constant)
    * @param type The type
    * @param scope The scope
    * @param memoryArea The memory area (zeropage/main memory)
    * @param dataSegment The data segment (in main memory)
    * @param arraySpec The array specification of the variable (if it is an array)
    * @param constantValue The constant value of the variable (if it is constant)
    */
   private Variable(String name, Kind kind, SymbolType type, Scope scope, MemoryArea memoryArea, String dataSegment, ArraySpec arraySpec, ConstantValue constantValue) {
      this.name = name;
      this.kind = kind;
      if(Kind.PHI_MASTER.equals(kind))
         this.nextPhiVersionNumber = 0;
      this.type = type;
      this.scope = scope;
      this.arraySpec = arraySpec;
      this.constantValue = constantValue;
      this.dataSegment = dataSegment;
      this.memoryArea = memoryArea;
      this.comments = new ArrayList<>();
      setFullName();
   }

   /**
    * Create an intermediate variable. The type will initially be set to {@link SymbolType#VAR}.
    *
    * @param name The name
    * @param scope The scope
    * @param dataSegment The data segment (in main memory)
    * @return The new intermediate variable
    */
   public static Variable createIntermediate(String name, Scope scope, String dataSegment) {
      return new Variable(name, Kind.INTERMEDIATE, SymbolType.VAR, scope, MemoryArea.ZEROPAGE_MEMORY, dataSegment, null, null);
   }

   /**
    * Create a load/store variable
    *
    * @param name The name
    * @param type The type
    * @param scope The scope
    * @param memoryArea The memory area (zeropage/main memory)
    * @param dataSegment The data segment (in main memory)
    * @return The new PHI-master variable
    */
   public static Variable createLoadStore(String name, SymbolType type, Scope scope, Variable.MemoryArea memoryArea, String dataSegment) {
      return new Variable(name, Kind.LOAD_STORE, type, scope, memoryArea, dataSegment, null, null);
   }

   /**
    * Create a PHI master variable
    *
    * @param name The name
    * @param type The type
    * @param scope The scope
    * @param memoryArea The memory area (zeropage/main memory)
    * @param dataSegment The data segment (in main memory)
    * @return The new PHI-master variable
    */
   public static Variable createPhiMaster(String name, SymbolType type, Scope scope, Variable.MemoryArea memoryArea, String dataSegment) {
      return new Variable(name, Kind.PHI_MASTER, type, scope, memoryArea, dataSegment, null, null);
   }

   /**
    * Create a version of a PHI master variable
    *
    * @param phiMaster The PHI master variable.
    * @param versionNum The version number
    */
   public static Variable createPhiVersion(Variable phiMaster, int versionNum) {
      Variable version = new Variable(phiMaster.getName() + "#" + versionNum, Kind.PHI_VERSION, phiMaster.getType(), phiMaster.getScope(), phiMaster.getMemoryArea(), phiMaster.getDataSegment(), phiMaster.getArraySpec(), null);
      version.setDeclaredAlignment(phiMaster.getDeclaredAlignment());
      version.setDeclaredAsRegister(phiMaster.isDeclaredAsRegister());
      version.setDeclaredConst(phiMaster.isDeclaredConst());
      version.setDeclaredRegister(phiMaster.getDeclaredRegister());
      version.setDeclaredVolatile(phiMaster.isDeclaredVolatile());
      version.setDeclaredExport(phiMaster.isDeclaredExport());
      version.setInferredVolatile(phiMaster.isInferredVolatile());
      version.setComments(phiMaster.getComments());
      return version;
   }

   /**
    * Create a compile-time constant variable
    *
    * @param name The name
    * @param type The type
    * @param scope The scope
    * @param value The constant value
    * @param dataSegment The data segment (in main memory)
    */
   public static Variable createConstant(String name, SymbolType type, Scope scope, ArraySpec arraySpec, ConstantValue value, String dataSegment) {
      return new Variable(name, Kind.CONSTANT, type, scope, MemoryArea.MAIN_MEMORY, dataSegment, arraySpec, value);
   }

   /**
    * Create a constant version of a variable. Used when a variable is determined to be constant during the compile.
    *
    * @param variable The variable to create a constant version of
    * @param constVal The constant value
    */
   public static Variable createConstant(Variable variable, ConstantValue constVal) {
      Variable constVar = createConstant(variable.getName(), variable.getType(), variable.getScope(), variable.getArraySpec(), constVal, variable.getDataSegment());
      constVar.setDeclaredAlignment(variable.getDeclaredAlignment());
      constVar.setDeclaredAsRegister(variable.isDeclaredAsRegister());
      constVar.setDeclaredConst(variable.isDeclaredConst());
      constVar.setDeclaredRegister(variable.getDeclaredRegister());
      constVar.setDeclaredVolatile(variable.isDeclaredVolatile());
      constVar.setDeclaredExport(variable.isDeclaredExport());
      constVar.setInferredVolatile(variable.isInferredVolatile());
      constVar.setComments(variable.getComments());
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
      Variable copy = new Variable(name, original.getKind(), original.getType(), scope, original.getMemoryArea(), original.getDataSegment(), original.getArraySpec(), original.getConstantValue());
      copy.setDeclaredAlignment(original.getDeclaredAlignment());
      copy.setDeclaredAsRegister(original.isDeclaredAsRegister());
      copy.setDeclaredConst(original.isDeclaredConst());
      copy.setDeclaredVolatile(original.isDeclaredVolatile());
      copy.setDeclaredExport(original.isDeclaredExport());
      copy.setDeclaredRegister(original.getDeclaredRegister());
      copy.setInferredVolatile(original.isInferredVolatile());
      copy.setComments(original.getComments());
      return copy;
   }

   /**
    * Create a variable representing a single member of a struct variable.
    * @param structVar The variable that holds a struct value.
    * @param memberDefinition The definition of the struct member
    * @return The new unwound variable representing the member of the struct
    */
   public static Variable createStructMemberUnwound(Variable structVar, Variable memberDefinition) {
      String name = structVar.getLocalName() + "_" + memberDefinition.getLocalName();
      Variable.MemoryArea memoryArea = (memberDefinition.getType() instanceof SymbolTypePointer) ? Variable.MemoryArea.ZEROPAGE_MEMORY : structVar.getMemoryArea();
      Variable memberVariable = new Variable(name, structVar.getKind(), memberDefinition.getType(), structVar.getScope(), memoryArea, structVar.getDataSegment(), null, null);
      memberVariable.setArraySpec(memberDefinition.getArraySpec());
      memberVariable.setDeclaredVolatile(structVar.isDeclaredVolatile());
      memberVariable.setInferredVolatile(structVar.isInferredVolatile());
      memberVariable.setDeclaredConst(structVar.isDeclaredConst());
      memberVariable.setDeclaredExport(structVar.isDeclaredExport());
      return memberVariable;
   }

   public Kind getKind() {
      return kind;
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
    * Creates a new PHI-version from a PHI-master
    *
    * @return The new version of the PHI master
    */
   public Variable createVersion() {
      if(!isKindPhiMaster())
         throw new InternalError("Cannot version non-PHI variable " + this.toString());
      Variable version = Variable.createPhiVersion(this, nextPhiVersionNumber++);
      getScope().add(version);
      return version;
   }

   /**
    * If the variable is a version of a variable returns the original variable.
    *
    * @return The original variable. Null if this is not a version.
    */
   public Variable getVersionOf() {
      if(!isKindPhiVersion())
         throw new InternalError("Cannot get master for non-PHI version variable " + this.toString());
      String name = getName();
      String versionOfName = name.substring(0, name.indexOf("#"));
      return getScope().getVariable(versionOfName);
   }

   public boolean isArray() {
      return arraySpec != null;
   }

   public ArraySpec getArraySpec() {
      return arraySpec;
   }

   public void setArraySpec(ArraySpec arraySpec) {
      this.arraySpec = arraySpec;
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

   public boolean isDeclaredConst() {
      return declaredConst;
   }

   public void setDeclaredConst(boolean declaredConst) {
      this.declaredConst = declaredConst;
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

   public void setInferredVolatile(boolean inferredVolatile) {
      this.inferredVolatile = inferredVolatile;
   }

   public boolean isInferredVolatile() {
      return inferredVolatile;
   }

   public boolean isVolatile() {
      return declaredVolatile || inferredVolatile;
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
            .append((constantValue == null && isKindIntermediate()) ? "~" : "")
            .append(") ")
            .append(getFullName()).toString();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      Variable variable = (Variable) o;
      return kind == variable.kind &&
            Objects.equals(name, variable.name) &&
            Objects.equals(scope, variable.scope) &&
            Objects.equals(type, variable.type);
   }

   @Override
   public int hashCode() {
      return Objects.hash(kind, name, scope, type);
   }
}

