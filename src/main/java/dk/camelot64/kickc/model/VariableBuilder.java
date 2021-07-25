package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeConversion;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.List;

/**
 * Used for creating a {@link Variable} with the right properties based on the declaration incl. all directives and configuration.
 * <p>
 * Holds information about the variable while it is being built.
 */
public class VariableBuilder {

   /** The variable name. */
   private String varName;

   /** The scope of the variable. */
   private Scope scope;

   /** The variable is an intermediate variable. */
   private boolean isIntermediate;

   /** The variable is a function parameter declaration. */
   private boolean isParameter;

   /** The type of the variable. */
   private SymbolType type;

   /** The directives of the variable declaration. */
   private List<Directive> directives;

   /** The data segment. */
   private String dataSegment;

   /** Configuration of how to setup optimization/memory area for variables. */
   private VariableBuilderConfig config;

   public VariableBuilder(String varName, Scope scope, boolean isParameter, boolean isIntermediate, SymbolType type, List<Directive> directives, String dataSegment, VariableBuilderConfig config) {
      this.varName = varName;
      this.scope = scope;
      this.isIntermediate = isIntermediate;
      this.isParameter = isParameter;
      this.type = type;
      this.directives = directives;
      this.dataSegment = dataSegment;
      this.config = config;
   }

   /**
    * Create a variable builder for an intermediate variable
    *
    *
    * @param scope The scope to create the intermediate variable in
    * @param type The variable type
    * @param program The global program
    * @return The new intermediate variable
    */
   public static Variable createIntermediate(Scope scope, SymbolType type, Program program) {
      VariableBuilder builder = new VariableBuilder(scope.allocateIntermediateVariableName(), scope, false, true, type, null, scope.getSegmentData(), program.getTargetPlatform().getVariableBuilderConfig());
      return builder.build();
   }

   /**
    * Build the variable with the properties derived from type, scope, directives and configuration.
    *
    * @return The variable
    */
   public Variable build() {

      Variable variable = new Variable(this.varName, getKind(), this.type, scope, getMemoryArea(), this.dataSegment, null);
      variable.setExport(this.isExport());
      variable.setPermanent(this.isPermanent());
      variable.setOptimize(this.isOptimize());
      variable.setRegister(this.getRegister());
      if(variable.getRegister() instanceof Registers.RegisterMainMem) {
         ((Registers.RegisterMainMem) variable.getRegister()).setVariableRef(variable.getVariableRef());
      }
      variable.setMemoryArea(this.getMemoryArea());
      variable.setMemoryAlignment(this.getAlignment());
      variable.setMemoryAddress(this.getAddress());
      variable.setDeclarationOnly(this.isDeclarationOnly());
      variable.setStructUnwind(this.getStructUnwind());

      // Check if the symbol has already been declared
      Symbol declaredSymbol = this.scope.getLocalSymbol(this.varName);
      if(declaredSymbol != null && !declaredSymbol.getFullName().equals(variable.getFullName()))
         // We found another symbol!
         declaredSymbol = null;

      if(declaredSymbol != null) {
         if(!(declaredSymbol instanceof Variable))
            throw new CompileError("Error! Conflicting declarations for: " + variable.getFullName());
         Variable declaredVar = (Variable) declaredSymbol;
         if(!declaredVar.isDeclarationOnly() && !variable.isDeclarationOnly())
            throw new CompileError("Error! Redefinition of variable: " + variable.getFullName());
         if(!SymbolTypeConversion.variableDeclarationMatch(declaredVar, variable))
            throw new CompileError("Error! Conflicting declarations for: " + variable.getFullName());

         // Update the variable with the definition
         if(!variable.isDeclarationOnly()) {
            this.scope.remove(declaredSymbol);
            this.scope.add(variable);
         }
      } else {
         // Not already declared - add it
         this.scope.add(variable);
      }

      return variable;
   }

   private boolean getStructUnwind() {
      return isStructUnwind(this.type, getKind(), config);
   }

   public static boolean isStructUnwind(SymbolType type, Variable.Kind kind, VariableBuilderConfig config) {
      if(config.isStructModelClassic())
         return false;
      if(type instanceof SymbolTypeStruct) {
         final SymbolTypeStruct typeStruct = (SymbolTypeStruct) type;
         if(typeStruct.isUnion())
            return false;
         if(Variable.Kind.LOAD_STORE.equals(kind))
            return false;
         // Unwind non-union, SSA and intermediate struct variables
         return true;
      }
      return false;
   }


   /**
    * Is the type is a simple integer type.
    *
    * @return True if the type is a simple integer type.
    */
   public boolean isTypeInteger() {
      return SymbolType.isInteger(type) || SymbolType.BOOLEAN.equals(type);
   }

   /**
    * Is the type is a struct type.
    *
    * @return True if the type is a struct type.
    */
   public boolean isTypeStruct() {
      return type instanceof SymbolTypeStruct;
   }

   /**
    * Is the type is a pointer type.
    *
    * @return True if the type is a pointer type.
    */
   public boolean isTypePointer() {
      return type instanceof SymbolTypePointer;
   }

   /**
    * Is the type is a var (currently unknown).
    *
    * @return True if the type is currently unknown
    */
   public boolean isTypeVar() {
      return SymbolType.VAR.equals(type) || SymbolType.VOID.equals(type);
   }

   /**
    * Is the variable a global variable
    *
    * @return true if the variable is in the global scope
    */
   public boolean isScopeGlobal() {
      return ScopeRef.ROOT.equals(scope.getRef()) || ScopeRef.TYPEDEFS.equals(scope.getRef());
   }

   /**
    * Is the variable a function parameter
    *
    * @return true if the variable is a function parameter
    */
   public boolean isScopeParameter() {
      Scope s = scope;
      while(s instanceof BlockScope)
         s = s.getScope();
      return (s instanceof Procedure) && isParameter;
   }

   /**
    * Is the variable a local variable in a function
    *
    * @return true if the variable is in a function scope
    */
   public boolean isScopeLocal() {
      Scope s = scope;
      while(s instanceof BlockScope)
         s = s.getScope();
      return (s instanceof Procedure) && !isParameter;
   }

   /**
    * Is the variable a (local) intermediate variable in a function
    *
    * @return true if the variable is an intermediate variable in a function scope
    */
   public boolean isScopeIntermediate() {
      if(isIntermediate) {
         if(isScopeGlobal()) throw new RuntimeException("Globa intermediate not supported");
         return true;
      } else
         return false;
   }

   /**
    * Is the variable a member of a struct definition
    *
    * @return true if the variable is a struct definition member
    */
   public boolean isScopeMember() {
      return scope instanceof StructDefinition;
   }

   /**
    * Is the variable an intermediate variable
    *
    * @return true if the variable is intermediate
    */
   public boolean isIntermediate() {
      return isIntermediate;
   }

   /**
    * Is the variable an array declaration
    *
    * @return true if the variable is an array declaration
    */
   public boolean isArray() {
      return isTypePointer() && ((SymbolTypePointer) type).getArraySpec() != null;
   }

   /**
    * Is the variable a compile-time constant
    *
    * @return true if the variable is a compile-time constant
    */
   public boolean isConstant() {
      if(isScopeGlobal() && isNoModify() && !isVolatile())
         // Global const
         return true;
      else if(isScopeLocal() && isNoModify() && hasDirective(Directive.Static.class) && !isVolatile())
         // Global static const
         return true;
      else if(isScopeLocal() && isNoModify() && !isVolatile())
         // Local const
         // TODO: Only allow local const variables with an init-value that is instanceof ConstantValue
         return true;
      else if(isArray())
         // Any array
         return true;
      else
         return false;
   }

   /** Declared as global private (static keyword and global variable) */
   public boolean isPrivate() {
      return isScopeGlobal() && hasDirective(Directive.Static.class);
   }

   /** Declared as local permanent (static keyword and local variable) */
   public boolean isPermanent() {
      return isScopeLocal() && hasDirective(Directive.Static.class);
   }

   /** Declared as volatile (volatile keyword) */
   public boolean isVolatile() {
      return type.isVolatile();
   }

   /** Declared as no-modify (const keyword) */
   public boolean isNoModify() {
      return type.isNomodify();
   }

   /** Declared as optimize (register keyword) */
   public boolean isOptimize() {
      return hasDirective(Directive.Register.class) || hasDirective(Directive.NamedRegister.class);
   }

   /**
    * Declared as export (__export keyword)
    *
    * @return true if declared as export
    */
   public boolean isExport() {
      return hasDirective(Directive.Export.class);
   }

   /**
    * Declared but not defined. ( "extern" keyword)
    *
    * @return true if the variable is declared but not defined.
    */
   public boolean isDeclarationOnly() {
      return hasDirective(Directive.Extern.class);
   }

   /**
    * Is the variable single-static-assignment ot multi-assignment.
    * Depends on the type and scope of the variable plus directives directly affecting the memory layout ( __mma, __sa, __zp, __address, __align).
    * TODO: Add different handling of different types & scopes
    * TODO: Handle intermediate variables
    * TODO: Add support for memory configuration controlling the assignment-type
    *
    * @return true if the variable is single-static-assignment
    */
   public boolean isSingleStaticAssignment() {
      if(hasDirective(Directive.FormSsa.class))
         // the __ssa directive forces single-static-assignment
         //TODO: FAIL if combined with __ma, __address() or volatile!
         return true;
      if(hasDirective(Directive.FormMa.class))
         // the __ma directive forces multiple-assignment
         return false;
      else if(hasDirective(Directive.Address.class))
         // the __address directive forces multiple-assignment
         return false;
      else if(isVolatile())
         // volatile variables must be load/store
         return false;
      else if(isTypeStruct() && config.isStructModelClassic())
         return false;
      else {
         VariableBuilderConfig.Scope scope = VariableBuilderConfig.getScope(isScopeGlobal(), isScopeLocal(), isScopeIntermediate(), isScopeParameter(), isScopeMember());
         VariableBuilderConfig.Type type = VariableBuilderConfig.getType(isTypeInteger(), isArray(), isTypePointer(), isTypeStruct(), isTypeVar());
         VariableBuilderConfig.Setting setting = config.getSetting(scope, type);
         if(setting != null && VariableBuilderConfig.Optimization.MA.equals(setting.optimization))
            return false;
         else
            return true;
      }
   }

   /**
    * Get the resulting kind of a variable.
    *
    * @return The variable kind
    */
   public Variable.Kind getKind() {
      if(isIntermediate()) {
         return Variable.Kind.INTERMEDIATE;
      } else if(isConstant())
         return Variable.Kind.CONSTANT;
      else if(isSingleStaticAssignment())
         return Variable.Kind.PHI_MASTER;
      else
         return Variable.Kind.LOAD_STORE;
   }

   /**
    * Get the memory area to use the the variable.
    * Depends on the type and scope of the variable plus directives directly affecting the memory layout ( __mma, __sa, __zp, __address, __align).
    * <p>
    * TODO: Add different handling of different types & scopes
    * TODO: Add support for memory configuration controlling the assignment-type
    *
    * @return The memory area to store the variable data in.
    */
   public Variable.MemoryArea getMemoryArea() {
      if(isConstant())
         return Variable.MemoryArea.MAIN_MEMORY;
      else if(hasDirective(Directive.MemZp.class))
         return Variable.MemoryArea.ZEROPAGE_MEMORY;
      else if(hasDirective(Directive.MemMain.class))
         return Variable.MemoryArea.MAIN_MEMORY;
      Directive.Address addressDirective = findDirective(Directive.Address.class, directives);
      if(addressDirective != null)
         return (addressDirective.addressLiteral < 0x100) ? Variable.MemoryArea.ZEROPAGE_MEMORY : Variable.MemoryArea.MAIN_MEMORY;
      else if(!isConstant() && isOptimize())
         return Variable.MemoryArea.ZEROPAGE_MEMORY;
      else {
         VariableBuilderConfig.Scope scope = VariableBuilderConfig.getScope(isScopeGlobal(), isScopeLocal(), isScopeIntermediate(), isScopeParameter(), isScopeMember());
         VariableBuilderConfig.Type type = VariableBuilderConfig.getType(isTypeInteger(), isArray(), isTypePointer(), isTypeStruct(), isTypeVar());
         VariableBuilderConfig.Setting setting = config.getSetting(scope, type);
         if(setting != null && VariableBuilderConfig.MemoryArea.MEM.equals(setting.memoryArea))
            return Variable.MemoryArea.MAIN_MEMORY;
         else
            return Variable.MemoryArea.ZEROPAGE_MEMORY;
      }
   }

   /**
    * Get any memory-alignment of the variables data
    *
    * @return The memory alignment
    */
   public Integer getAlignment() {
      Directive.Align alignDirective = findDirective(Directive.Align.class, directives);
      if(alignDirective != null) {
         if(isArray()) {
            return alignDirective.alignment;
         } else {
            // TODO: Add information about which variable (name) and the offending source line
            throw new CompileError("Error! Cannot align variable that is not an array.");
         }
      }
      return null;
   }

   /**
    * Get any memory-address of the variables data
    *
    * @return The memory alignment
    */
   public ConstantValue getAddress() {
      Directive.Address addressDirective = findDirective(Directive.Address.class, directives);
      if(addressDirective != null) {
         if(isArray()) {
            return addressDirective.addressValue;
         }
      }
      return null;
   }

   /**
    * Get any hard-coded register allocation.
    *
    * @return Hard-coded register allocation. Null if not hard-coded.
    */
   public Registers.Register getRegister() {

      if(isArray())
         // Arrays are not put into registers
         return null;

      Directive.Address addressDirective = findDirective(Directive.Address.class, directives);
      if(addressDirective != null) {
         Variable.MemoryArea memoryArea = (addressDirective.addressLiteral < 0x100) ? Variable.MemoryArea.ZEROPAGE_MEMORY : Variable.MemoryArea.MAIN_MEMORY;
         if(Variable.MemoryArea.ZEROPAGE_MEMORY.equals(memoryArea)) {
            return new Registers.RegisterZpMem(addressDirective.addressLiteral.intValue(), -1, true);
         } else {
            // TODO: Fix VariableRef for the hard-coded register
            return new Registers.RegisterMainMem(null, -1, addressDirective.addressLiteral);
         }
      }

      Directive.NamedRegister registerDirective = findDirective(Directive.NamedRegister.class, directives);
      if(registerDirective != null) {
         Registers.Register register = Registers.getRegister(registerDirective.name);
         if(register == null) {
            // TODO: Add statement source
            throw new CompileError("Error! Unknown register " + registerDirective.name);
         }
         return register;
      }

      // No hard-coded register
      return null;
   }

   /**
    * Examines whether a specific directive is present in the source
    *
    * @param directiveClass The class of the type to look for
    * @param <DirectiveClass> The class of the type to look for
    * @return true if the directive if found. false otherwise.
    */
   private <DirectiveClass extends Directive> boolean hasDirective(Class<DirectiveClass> directiveClass) {
      return findDirective(directiveClass, directives) != null;
   }

   /**
    * Examines whether a specific directive is present in the source
    *
    * @param directiveClass The class of the type to look for
    * @param <DirectiveClass> The class of the type to look for
    * @return true if the directive if found. false otherwise.
    */
   public static <DirectiveClass extends Directive> boolean hasDirective(Class<DirectiveClass> directiveClass, List<Directive> directives) {
      return findDirective(directiveClass, directives) != null;
   }

   /**
    * Look for a specific directive type in a list of directives
    *
    * @param directiveClass The class of the type to look for
    * @param <DirectiveClass> The class of the type to look for
    * @return The directive if found. null if not found.
    */
   private static <DirectiveClass extends Directive> DirectiveClass findDirective(Class<DirectiveClass> directiveClass, List<Directive> directives) {
      if(directives == null) return null;
      for(Directive directive : directives) {
         if(directiveClass.isInstance(directive)) {
            return (DirectiveClass) directive;
         }
      }
      // Not found!
      return null;
   }

}
