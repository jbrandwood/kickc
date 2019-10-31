package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeArray;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.*;

/**
 * The parser directive context is used for determining which directives to apply to a variable.
 * It keeps track of values for the #pragmas that control default directives for variables.
 * Uses the following priority
 * <ol>
 * <li>If the directive is present in source - use that.
 * <li>If the register keyword present in source - Look in #pragma variables_register_implies for setting (register in #pragma variables_xxx does not trigger this)
 * <li>Look in #pragma variables_<i>scope</i>_<i>type</i> for setting (<i>scope</i> is global/local/parameter <i>type</i> is integer/pointer/array)
 * <li>Look in #pragma variables_<i>type</i> for setting (<i>type</i> is integer/pointer/array)
 * <li>Look in #pragma variables_<i>scope</i> for setting (<i>scope</i> is global/local/parameter)
 * <li>Look in #pragma variables_default for setting
 * <li>Use compiler default for the setting (__notconst __notregister _notalign __notvolatile __zp __initcode)
 * </ol>
 */
public class DirectiveParserContext {

   /** The different scopes deciding directive defaults. */
   public enum DirectiveScope {
      GLOBAL, LOCAL, PARAMETER, MEMBER;

      public static DirectiveScope getFor(SymbolVariable lValue, boolean isParameter) {
         if(isParameter) {
            return PARAMETER;
         }
         Scope scope = lValue.getScope();
         return getFor(scope);
      }

      private static DirectiveScope getFor(Scope scope) {
         if(ScopeRef.ROOT.equals(scope.getRef())) {
            return GLOBAL;
         } else if(scope instanceof Procedure) {
            return LOCAL;
         } else if(scope instanceof StructDefinition) {
            return MEMBER;
         } else if(scope instanceof BlockScope) {
            return getFor(scope.getScope());
         } else {
            throw new InternalError("Scope type not handled " + scope);
         }
      }
   }

   /** The different types deciding directive defaults. */
   public enum DirectiveType {
      INTEGER, POINTER, ARRAY, STRUCT;

      /**
       * Get a directive type from a variable type.
       *
       * @param type The variable type
       * @return The directive type
       */
      public static DirectiveType getFor(SymbolType type) {
         if(SymbolType.isInteger(type)) {
            return INTEGER;
         } else if(SymbolType.BOOLEAN.equals(type)) {
            return INTEGER;
         } else if(SymbolType.STRING.equals(type)) {
            return ARRAY;
         } else if(type instanceof SymbolTypeArray) {
            return ARRAY;
         } else if(type instanceof SymbolTypePointer) {
            return POINTER;
         } else if(type instanceof SymbolTypeStruct) {
            return STRUCT;
         } else {
            throw new InternalError("Variable type not handled " + type);
         }
      }
   }

   /** Combination of a scope and type deciding directive defaults. */
   public static class DirectiveScopeType {
      DirectiveScope directiveScope;
      DirectiveType directiveType;

      public DirectiveScopeType(DirectiveScope directiveScope, DirectiveType directiveType) {
         this.directiveScope = directiveScope;
         this.directiveType = directiveType;
      }

      @Override
      public boolean equals(Object o) {
         if(this == o) return true;
         if(o == null || getClass() != o.getClass()) return false;
         DirectiveScopeType that = (DirectiveScopeType) o;
         return directiveScope == that.directiveScope &&
               directiveType == that.directiveType;
      }

      @Override
      public int hashCode() {
         return Objects.hash(directiveScope, directiveType);
      }
   }

   /** Directives of a specific statement. Only non-null if this is a stored copy of the context for later resolution. */
   List<Directive> statementDirectives;

   /** Directives implied by the 'register' keyword. */
   List<Directive> registerImpliesDirectives;

   /** Default directives for a specific scope/type combination. */
   Map<DirectiveScopeType, List<Directive>> scopeTypeDirectives;

   /** Default directives for a specific scope. */
   Map<DirectiveScope, List<Directive>> scopeDirectives;

   /** Default directives for a specific type. */
   Map<DirectiveType, List<Directive>> typeDirectives;

   /** Default directives. */
   List<Directive> defaultDirectives;

   public DirectiveParserContext() {
      this.statementDirectives = null;
      // Setup default directives
      this.defaultDirectives = Arrays.asList(
            new Directive.MemoryArea(SymbolVariable.MemoryArea.ZEROPAGE_MEMORY, null),
            new Directive.FormSsa(true),
            new Directive.Const(SymbolVariable.ConstantDeclaration.MAYBE_CONST)
      );
      this.registerImpliesDirectives = new ArrayList<>();
      this.typeDirectives = new HashMap<>();
      this.typeDirectives.put(DirectiveType.ARRAY, Arrays.asList(
            new Directive.Const(SymbolVariable.ConstantDeclaration.CONST),
            new Directive.MemoryArea(SymbolVariable.MemoryArea.MAIN_MEMORY, null)
      ));
      this.typeDirectives.put(DirectiveType.POINTER, Arrays.asList(
            new Directive.MemoryArea(SymbolVariable.MemoryArea.ZEROPAGE_MEMORY, null)
      ));
      this.scopeDirectives = new HashMap<>();
      //this.scopeDirectives.put(DirectiveScope.GLOBAL, Arrays.asList(
      //      new Directive.MemoryArea(SymbolVariable.MemoryArea.MAIN_MEMORY, null),
      //      new Directive.FormSsa(false)
      //));
      this.scopeTypeDirectives = new HashMap<>();
   }

   /**
    * Applies directives to a variable. Applies directives using the correct priority.
    *
    * @param lValue The variable to apply directives to
    * @param sourceDirectives The directives found in the source code
    * @param source The source line.
    * @return
    */
   public void applyDirectives(SymbolVariable lValue, boolean isParameter, List<Directive> sourceDirectives, StatementSource source) {
      DirectiveType directiveType = DirectiveType.getFor(lValue.getType());
      DirectiveScope directiveScope = DirectiveScope.getFor(lValue, isParameter);

      Directive.FormSsa ssaDirective = findDirective(Directive.FormSsa.class, sourceDirectives, directiveScope, directiveType);
      if(ssaDirective != null) {
         if(ssaDirective.ssa) {
            lValue.setStorageStrategy(SymbolVariable.StorageStrategy.PHI_MASTER);
         } else {
            lValue.setStorageStrategy(SymbolVariable.StorageStrategy.LOAD_STORE);
         }
      }

      Directive.Const constDirective = findDirective(Directive.Const.class, sourceDirectives, directiveScope, directiveType);
      if(constDirective != null) {
         lValue.setConstantDeclaration(constDirective.constantDeclaration);
         if(SymbolVariable.ConstantDeclaration.CONST.equals(constDirective.constantDeclaration)) {
            lValue.setStorageStrategy(SymbolVariable.StorageStrategy.CONSTANT);
            if(!(lValue.getType() instanceof SymbolTypePointer))
               lValue.setMemoryArea(SymbolVariable.MemoryArea.MAIN_MEMORY);
         }
      }

      Directive.Volatile volatileDirective = findDirective(Directive.Volatile.class, sourceDirectives, directiveScope, directiveType);
      if(volatileDirective != null) {
         lValue.setDeclaredVolatile(volatileDirective.isVolatile);
      }

      Directive.Export exportDirective = findDirective(Directive.Export.class, sourceDirectives, directiveScope, directiveType);
      if(exportDirective != null) {
         lValue.setDeclaredExport(true);
      }

      Directive.Align alignDirective = findDirective(Directive.Align.class, sourceDirectives, directiveScope, directiveType);
      if(alignDirective != null) {
         SymbolType type = lValue.getType();
         if(type instanceof SymbolTypeArray || type.equals(SymbolType.STRING)) {
            lValue.setDeclaredAlignment(alignDirective.alignment);
         } else {
            throw new CompileError("Error! Cannot align variable that is not a string or an array " + lValue.toString(), source);
         }
      }

      Directive.MemoryArea memoryAreaDirective = findDirective(Directive.MemoryArea.class, sourceDirectives, directiveScope, directiveType);
      if(memoryAreaDirective != null) {
         lValue.setMemoryArea(memoryAreaDirective.memoryArea);
         if(memoryAreaDirective.address != null) {
            if(SymbolVariable.MemoryArea.ZEROPAGE_MEMORY.equals(memoryAreaDirective.memoryArea)) {
               Registers.Register register = new Registers.RegisterZpMem(memoryAreaDirective.address.intValue(), -1, true);
               lValue.setDeclaredRegister(register);
            } else {
               Registers.Register register = new Registers.RegisterMainMem((VariableRef) lValue.getRef(), -1, memoryAreaDirective.address);
               lValue.setDeclaredRegister(register);
            }
         }
      }

      Directive.Register registerDirective = findDirective(Directive.Register.class, sourceDirectives, directiveScope, directiveType);
      if(registerDirective != null) {
         if(registerDirective.isRegister) {
            lValue.setDeclaredAsRegister(true);
            lValue.setStorageStrategy(SymbolVariable.StorageStrategy.PHI_MASTER);
            if(registerDirective.name != null) {
               // Ignore register directive without parameter (all variables are placed on ZP and attempted register uplift anyways)
               Registers.Register register = Registers.getRegister(registerDirective.name);
               if(register == null) {
                  throw new CompileError("Error! Unknown register " + registerDirective.name, source);
               }
               lValue.setDeclaredRegister(register);
            }
         } else {
            lValue.setDeclaredNotRegister(true);
            lValue.setStorageStrategy(SymbolVariable.StorageStrategy.LOAD_STORE);
         }
      }

   }


   private <DirectiveClass extends Directive> DirectiveClass findDirective(Class<DirectiveClass> directiveClass, List<Directive> sourceDirectives, DirectiveScope directiveScope, DirectiveType directiveType) {
      // Look in source directives
      {
         DirectiveClass directive = findDirective(directiveClass, sourceDirectives);
         if(directive != null) return directive;
      }

      // Look in register implies - if register directive is present in source
      if(isRegister(sourceDirectives)) {
         // Look in source directives
         DirectiveClass directive = findDirective(directiveClass, registerImpliesDirectives);
         if(directive != null) return directive;
      }
      // Look in #pragma setting for scope/type combination
      {
         List<Directive> directives = scopeTypeDirectives.get(new DirectiveScopeType(directiveScope, directiveType));
         DirectiveClass directive = findDirective(directiveClass, directives);
         if(directive != null) return directive;
      }
      // Look in #pragma setting for type
      {
         List<Directive> directives = typeDirectives.get(directiveType);
         DirectiveClass directive = findDirective(directiveClass, directives);
         if(directive != null) return directive;
      }
      // Look in #pragma setting for scope
      {
         List<Directive> directives = scopeDirectives.get(directiveScope);
         DirectiveClass directive = findDirective(directiveClass, directives);
         if(directive != null) return directive;
      }
      // Look in #pragma setting for default
      {
         DirectiveClass directive = findDirective(directiveClass, defaultDirectives);
         if(directive != null) return directive;
      }
      // Not found!
      return null;
   }

   /**
    * Determine if the register directive is present in the source directives.
    *
    * @param sourceDirectives The source directives
    * @return true if the register keyword is present
    */
   private boolean isRegister(List<Directive> sourceDirectives) {
      Directive.Register registerDirective = findDirective(Directive.Register.class, sourceDirectives);
      return registerDirective != null && registerDirective.isRegister;
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
