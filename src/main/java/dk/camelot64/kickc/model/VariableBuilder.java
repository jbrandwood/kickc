package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.List;

/**
 * Used for creating a {@link Variable} with the right properties based on the declaration incl. all directives and configuration.
 * <p>
 * Holds information about the variable while it is being built.
 */
public class VariableBuilder {

   /** The scope of the variable. */
   private Scope scope;

   /** The variable is a function parameter declaration. */
   private boolean isParameter;

   /** The type of the variable. */
   private SymbolType type;

   /** Non-null if the variable is an array. */
   private ArraySpec arraySpec;

   /** The directives of the variable declaration. */
   private List<Directive> directives;

   public VariableBuilder(Scope scope, boolean isParameter, SymbolType type, ArraySpec arraySpec, List<Directive> directives) {
      this.scope = scope;
      this.isParameter = isParameter;
      this.type = type;
      this.arraySpec = arraySpec;
      this.directives = directives;
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
    * Is the type is a pointer type.
    *
    * @return True if the type is a pointer type.
    */
   public boolean isTypePointer() {
      return type instanceof SymbolTypePointer;
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
    * Is the variable a global variable
    *
    * @return true if the variable is in the global scope
    */
   public boolean isScopeGlobal() {
      return ScopeRef.ROOT.equals(scope.getRef());
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
    * Is the variable a member of a struct definition
    *
    * @return true if the variable is a struct definition member
    */
   public boolean isScopeMember() {
      return scope instanceof StructDefinition;
   }

   /**
    * Is the  variable an array declaration
    *
    * @return true if the variable is an array declaration
    */
   public boolean isArray() {
      return arraySpec != null;
   }

   /**
    * Is the variable a compile-time constant
    *
    * @return true if the variable is a compile-time constant
    */
   public boolean isConstant() {
      if(isScopeGlobal() && hasDirective(Directive.Const.class) && !hasDirective(Directive.Volatile.class))
         // Global const
         return true;
      else if(isScopeLocal() && hasDirective(Directive.Const.class) && hasDirective(Directive.Static.class) && !hasDirective(Directive.Volatile.class))
         // Global static const
         return true;
      else if(isScopeLocal() && hasDirective(Directive.Const.class) && !hasDirective(Directive.Volatile.class))
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
      return hasDirective(Directive.Volatile.class);
   }

   /** Declared as no-modify (const keyword) */
   public boolean isNoModify() {
      return hasDirective(Directive.Const.class);
   }

   /** Declared as optimize (register keyword) */
   public boolean isOptimize() {
      return hasDirective(Directive.Register.class) || hasDirective(Directive.NamedRegister.class);
   }

   /** Declared as pointer to volatile (volatile* keyword) */
   public boolean isToVolatile() {
      return hasDirective(Directive.ToVolatile.class);
   }

   /** Declared as pointer to no-modify (const* keyword) */
   public boolean isToNoModify() {
      return hasDirective(Directive.ToConst.class);
   }

   /** Declared as export (__export keyword)
    *
    * @return true if declared as export
    */
   public boolean isExport() {
      return hasDirective(Directive.Export.class);
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
      if(hasDirective(Directive.FormMa.class))
         return false;
      else if(!isConstant())
         return true;
      else
         return false;
   }

   /**
    * Get the resulting kind of a variable.
    *
    * @return The variable kind
    */
   public Variable.Kind getKind() {
      if(isConstant())
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
      else if(!isConstant() && isOptimize())
         return Variable.MemoryArea.ZEROPAGE_MEMORY;
      else if(isArray())
         return Variable.MemoryArea.MAIN_MEMORY;
      else if(hasDirective(Directive.MemZp.class))
         return Variable.MemoryArea.ZEROPAGE_MEMORY;
      else if(hasDirective(Directive.MemMain.class))
         return Variable.MemoryArea.MAIN_MEMORY;
      Directive.Address addressDirective = findDirective(Directive.Address.class);
      if(addressDirective != null)
         return (addressDirective.address < 0x100) ? Variable.MemoryArea.ZEROPAGE_MEMORY : Variable.MemoryArea.MAIN_MEMORY;
      else
         return Variable.MemoryArea.ZEROPAGE_MEMORY;
   }

   /**
    * Get any memory-alignment of the variables data
    * @return
    */
   public Integer getAlignment() {
      Directive.Align alignDirective = findDirective(Directive.Align.class);
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
    * Get any hard-coded register allocation.
    *
    * @return Hard-coded register allocation. Null if not hard-coded.
    */
   public Registers.Register getRegister() {

      Directive.Address addressDirective = findDirective(Directive.Address.class);
      if(addressDirective != null) {
         Variable.MemoryArea memoryArea = (addressDirective.address < 0x100) ? Variable.MemoryArea.ZEROPAGE_MEMORY : Variable.MemoryArea.MAIN_MEMORY;
         if(Variable.MemoryArea.ZEROPAGE_MEMORY.equals(memoryArea)) {
            return new Registers.RegisterZpMem(addressDirective.address.intValue(), -1, true);
         } else {
            // TODO: Fix VariableRef for the hard-coded register
            return new Registers.RegisterMainMem(null, -1, addressDirective.address);
         }
      }

      Directive.NamedRegister registerDirective = findDirective(Directive.NamedRegister.class);
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
    * @param directives The list of directives to search
    * @param <DirectiveClass> The class of the type to look for
    * @return true if the directive if found. false otherwise.
    */
   private <DirectiveClass extends Directive> boolean hasDirective(Class<DirectiveClass> directiveClass) {
      return findDirective(directiveClass) != null;
   }

   /**
    * Look for a specific directive type in a list of directives
    *
    * @param directiveClass The class of the type to look for
    * @param directives The list of directives to search
    * @param <DirectiveClass> The class of the type to look for
    * @return The directive if found. null if not found.
    */
   private <DirectiveClass extends Directive> DirectiveClass findDirective(Class<DirectiveClass> directiveClass) {
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
