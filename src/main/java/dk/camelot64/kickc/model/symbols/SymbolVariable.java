package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.Registers;
import dk.camelot64.kickc.model.types.SymbolType;

import java.util.ArrayList;
import java.util.List;

/** Abstract Variable or a Constant Variable */
public abstract class SymbolVariable implements Symbol {

   /** The name of the variable. */
   private String name;

   /** The scope containing the variable */
   private Scope scope;

   /** The type of the variable. VAR means tha type is unknown, and has not been inferred yet. */
   private SymbolType type;

   /** true if the symbol type is infered (not declared) */
   private boolean inferredType;

   /** A short name used for the variable in ASM code. If possible variable names of ZP variables are shortened in ASM code. This is possible, when all versions of the var use the same register. */
   private String asmName;

   /** Specifies that the variable is declared a constant. It will be replaced by a ConstantVar when possible. */
   private boolean declaredConstant;

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

   /** Specifies a specific address where the variable must reside in memory. */
   private Long declaredMemoryAddress;

   /** Strategy being used for storing and accessing the variable. The value depends on the directives memory/register/volatile/const - and on the compilers optimization decisions.
    * <ul>
    * <li>PHI variables are turned into versions and PHI-nodes are used for them throughout the entire program. They cannot be "volatile" and the "address-of" operator cannot be used on them.</li>
    * <li>INTERMEDIATE variables are created when expressions are broken into smaller statements. </li>
    * <li>LOAD_STORE variables are accessed through load/store operations. </li>
    * <li>CONSTANT variables are constant.
    * </ul>
    **/
   public enum StorageStrategy { PHI_MASTER, PHI_VERSION, INTERMEDIATE, LOAD_STORE, CONSTANT }

   /** The storage strategy for the variable. */
   private StorageStrategy storageStrategy;

   /** Memory area used for storing the variable (if is is stored in memory). */
   public enum MemoryArea { ZEROPAGE_MEMORY, MAIN_MEMORY }

   /** The memory area where the variable lives (if stored in memory). */
   private MemoryArea memoryArea;

   /** Comments preceding the procedure in the source code. */
   private List<Comment> comments;

   /** Full name of variable (scope::name or name) */
   private String fullName;

   /** The data segment to put the variable into (if it is allocated in memory). */
   private String dataSegment;


   public SymbolVariable(String name, Scope scope, SymbolType type, StorageStrategy storageStrategy, MemoryArea memoryArea, String dataSegment) {
      this.name = name;
      this.scope = scope;
      this.type = type;
      this.inferredType = false;
      this.comments = new ArrayList<>();
      this.dataSegment = dataSegment;
      this.storageStrategy = storageStrategy;
      this.memoryArea = memoryArea;
      setFullName();
   }

   private void setFullName() {
      String scopeName = (scope == null) ? "" : scope.getFullName();
      fullName = (scopeName.length() > 0) ? scopeName + "::" + name : name;
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

   public boolean isDeclaredConstant() {
      return declaredConstant;
   }

   public void setDeclaredConstant(boolean declaredConstant) {
      this.declaredConstant = declaredConstant;
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
      return declaredVolatile || inferedVolatile || isStorageLoadStore();
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

   public Long getDeclaredMemoryAddress() {
      return declaredMemoryAddress;
   }

   public void setDeclaredMemoryAddress(Long declaredMemoryAddress) {
      this.declaredMemoryAddress = declaredMemoryAddress;
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
      String s = new StringBuilder()
            .append("(")
            .append(type.getTypeName())
            .append(inferredType ? "~" : "")
            .append(") ")
            .append(getFullName()).toString();
      return s;
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

      if(inferredType != variable.inferredType) {
         return false;
      }
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
      result = 31 * result + (inferredType ? 1 : 0);
      result = 31 * result + (asmName != null ? asmName.hashCode() : 0);
      return result;
   }

}
