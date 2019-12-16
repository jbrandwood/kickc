package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.List;

/**
 * Used for creating a {@link Variable} with the right properties based on the declaration incl. all directives and configuration.
 *
 * Holds information about the variable while it is being built.
 */
public class VariableBuilder {

   /** The scope of the variable. */
   private Scope scope;

   /** The variable is a function parameter declaration. */
   private boolean isParameter;

   /** The type of the variable. */
   private SymbolType type;

   /** Tye variable is an array. */
   private boolean isArray;

   /** A compile-time constant (const keyword and no volatile keyword and initValue is a compile-time constant) */
   private boolean isConstant;

   /** Declared as global private (static keyword and global variable) */
   private boolean isPrivate;

   /** Declared as local permanent (static keyword and local variable) */
   private boolean isPermanent;

   /** Declared as volatile (volatile keyword) */
   private boolean isVolatile;

   /** Declared as no-modify (const keyword) */
   private boolean isNoModify;

   /** Declared as optimize (register keyword) */
   private boolean isOptimize;

   /** Declared as pointer to volatile (volatile* keyword) */
   private boolean isToVolatile;

   /** Declared as pointer to no-modify (const* keyword) */
   private boolean isToNoModify;

   /**
    * Is the type is a simple integer type.
    * @return True if the type is a simple integer type.
    */
   boolean isTypeInteger() {
      return SymbolType.isInteger(type) || SymbolType.BOOLEAN.equals(type);
   }

   /**
    * Is the type is a pointer type.
    * @return True if the type is a pointer type.
    */
   boolean isTypePointer() {
      return type instanceof SymbolTypePointer;
   }

   /**
    * Is the type is a struct type.
    * @return True if the type is a struct type.
    */
   boolean isTypeStruct() {
      return type instanceof SymbolTypeStruct;
   }

   /** The different scopes deciding directive defaults. */
   public enum DirectiveScope {
      GLOBAL, LOCAL, PARAMETER, MEMBER;

      private static DirectiveScope getFor(Scope scope, boolean isParameter) {
         if(isParameter) {
            return PARAMETER;
         }
         if(ScopeRef.ROOT.equals(scope.getRef())) {
            return GLOBAL;
         } else if(scope instanceof Procedure) {
            return LOCAL;
         } else if(scope instanceof StructDefinition) {
            return MEMBER;
         } else if(scope instanceof BlockScope) {
            return getFor(scope.getScope(), false);
         } else {
            throw new InternalError("Scope type not handled " + scope);
         }
      }
   }

   public VariableBuilder() {
   }

   /**
    * Find the variable kind for a declared variable (not used for intermediates or PHI-versions)
    *
    * @param type The type of the variable
    * @param scope The scope
    * @param isParameter true if the variable is a procedure parameter
    * @param sourceDirectives The directives in the source code
    * @param source The source line (for exceptions)
    * @return The variable kind
    */
   public Variable.Kind getKind(SymbolType type, Scope scope, boolean isParameter, boolean isArray, List<Directive> sourceDirectives, StatementSource source) {
      // Look for const without volatile
      if(hasDirective(Directive.Const.class, sourceDirectives))
         if(!hasDirective(Directive.Volatile.class, sourceDirectives))
            return Variable.Kind.CONSTANT;
      // Look for array (which is implicitly const
      //DirectiveType directiveType = DirectiveType.getFor(type);
      if(isArray)
         return Variable.Kind.CONSTANT;
      // It is not a constant - determine PHI_MASTER vs LOAD_STORE
      if(hasDirective(Directive.FormSsa.class, sourceDirectives))
         return Variable.Kind.PHI_MASTER;
      if(hasDirective(Directive.FormMa.class, sourceDirectives))
         return Variable.Kind.LOAD_STORE;
      if(hasDirective(Directive.Register.class, sourceDirectives))
         return Variable.Kind.PHI_MASTER;
      if(hasDirective(Directive.NamedRegister.class, sourceDirectives))
         return Variable.Kind.PHI_MASTER;
      // TODO: Add strategy for selecting LOAD_STORE for global vars
      return Variable.Kind.PHI_MASTER;
   }

   /**
    * Applies directives to a variable.
    *
    * @param variable The variable to apply directives to
    * @param sourceDirectives The directives found in the source code
    * @param source The source line (for exceptions)
    */
   public void applyDirectives(Variable variable, boolean isParameter, boolean isArray, List<Directive> sourceDirectives, StatementSource source) {
      if(hasDirective(Directive.Const.class, sourceDirectives))
         variable.setDeclaredConst(true);
      if(isArray)
         variable.setDeclaredConst(true);
      if(hasDirective(Directive.Volatile.class, sourceDirectives))
         variable.setDeclaredVolatile(true);
      if(hasDirective(Directive.Export.class, sourceDirectives))
         variable.setDeclaredExport(true);
      if(hasDirective(Directive.Register.class, sourceDirectives)) {
         variable.setMemoryArea(Variable.MemoryArea.ZEROPAGE_MEMORY);
         variable.setDeclaredAsRegister(true);
      }
      if(isArray)
         variable.setMemoryArea(Variable.MemoryArea.MAIN_MEMORY);
      if(hasDirective(Directive.MemZp.class, sourceDirectives))
         variable.setMemoryArea(Variable.MemoryArea.ZEROPAGE_MEMORY);
      if(hasDirective(Directive.MemMain.class, sourceDirectives))
         variable.setMemoryArea(Variable.MemoryArea.MAIN_MEMORY);
      Directive.Address addressDirective = findDirective(Directive.Address.class, sourceDirectives);
      if(addressDirective != null) {
         Variable.MemoryArea memoryArea = (addressDirective.address < 0x100) ? Variable.MemoryArea.ZEROPAGE_MEMORY : Variable.MemoryArea.MAIN_MEMORY;
         if(Variable.MemoryArea.ZEROPAGE_MEMORY.equals(memoryArea)) {
            variable.setMemoryArea(Variable.MemoryArea.ZEROPAGE_MEMORY);
            Registers.Register register = new Registers.RegisterZpMem(addressDirective.address.intValue(), -1, true);
            variable.setDeclaredRegister(register);
         } else {
            variable.setMemoryArea(Variable.MemoryArea.MAIN_MEMORY);
            Registers.Register register = new Registers.RegisterMainMem((VariableRef) variable.getRef(), -1, addressDirective.address);
            variable.setDeclaredRegister(register);
         }
      }

      Directive.NamedRegister registerDirective = findDirective(Directive.NamedRegister.class, sourceDirectives);
      if(registerDirective != null) {
         variable.setDeclaredAsRegister(true);
         Registers.Register register = Registers.getRegister(registerDirective.name);
         if(register == null) {
            throw new CompileError("Error! Unknown register " + registerDirective.name, source);
         }
         variable.setDeclaredRegister(register);
      }

      Directive.Align alignDirective = findDirective(Directive.Align.class, sourceDirectives);
      if(alignDirective != null) {
         if(isArray) {
            variable.setDeclaredAlignment(alignDirective.alignment);
         } else {
            throw new CompileError("Error! Cannot align variable that is not a string or an array " + variable.toString(), source);
         }
      }

      // TODO: Add strategy for selecting main memory for non-pointer local variables
      //DirectiveScope directiveScope = DirectiveScope.getFor(lValue.getScope(), isParameter);

   }

   /**
    * Examines whether a specific directive is present in the source
    *
    * @param directiveClass The class of the type to look for
    * @param directives The list of directives to search
    * @param <DirectiveClass> The class of the type to look for
    * @return true if the directive if found. false otherwise.
    */
   private <DirectiveClass extends Directive> boolean hasDirective(Class<DirectiveClass> directiveClass, List<Directive> directives) {
      return findDirective(directiveClass, directives) != null;
   }


   /**
    * Look for a specific directive type in a list of directives
    *
    * @param directiveClass The class of the type to look for
    * @param directives The list of directives to search
    * @param <DirectiveClass> The class of the type to look for
    * @return The directive if found. null if not found.
    */
   private <DirectiveClass extends Directive> DirectiveClass findDirective(Class<DirectiveClass> directiveClass, List<Directive> directives) {
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
