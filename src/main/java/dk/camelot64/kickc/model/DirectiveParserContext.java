package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeArray;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.List;

/**
 * The parser directive context is used for determining which directives to apply to a variable.
 */
public class DirectiveParserContext {

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


   public DirectiveParserContext() {
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
   public Variable.Kind getKind(SymbolType type, Scope scope, boolean isParameter, List<Directive> sourceDirectives, StatementSource source) {
      // Look for const without volatile
      if(hasDirective(Directive.Const.class, sourceDirectives))
         if(!hasDirective(Directive.Volatile.class, sourceDirectives))
            return Variable.Kind.CONSTANT;
      // Look for array (which is implicitly const
      DirectiveType directiveType = DirectiveType.getFor(type);
      if(DirectiveType.ARRAY.equals(directiveType))
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
    * @param lValue The variable to apply directives to
    * @param sourceDirectives The directives found in the source code
    * @param source The source line (for exceptions)
    */
   public void applyDirectives(Variable lValue, boolean isParameter, List<Directive> sourceDirectives, StatementSource source) {
      DirectiveType directiveType = DirectiveType.getFor(lValue.getType());
      if(hasDirective(Directive.Const.class, sourceDirectives))
         lValue.setDeclaredConst(true);
      if(directiveType.equals(DirectiveType.ARRAY))
         lValue.setDeclaredConst(true);
      if(hasDirective(Directive.Volatile.class, sourceDirectives))
         lValue.setDeclaredVolatile(true);
      if(hasDirective(Directive.Export.class, sourceDirectives))
         lValue.setDeclaredExport(true);
      if(hasDirective(Directive.Register.class, sourceDirectives)) {
         lValue.setMemoryArea(Variable.MemoryArea.ZEROPAGE_MEMORY);
         lValue.setDeclaredAsRegister(true);
      }
      if(directiveType.equals(DirectiveType.ARRAY))
         lValue.setMemoryArea(Variable.MemoryArea.MAIN_MEMORY);
      if(hasDirective(Directive.MemZp.class, sourceDirectives))
         lValue.setMemoryArea(Variable.MemoryArea.ZEROPAGE_MEMORY);
      if(hasDirective(Directive.MemMain.class, sourceDirectives))
         lValue.setMemoryArea(Variable.MemoryArea.MAIN_MEMORY);
      Directive.Address addressDirective = findDirective(Directive.Address.class, sourceDirectives);
      if(addressDirective != null) {
         Variable.MemoryArea memoryArea = (addressDirective.address < 0x100) ? Variable.MemoryArea.ZEROPAGE_MEMORY : Variable.MemoryArea.MAIN_MEMORY;
         if(Variable.MemoryArea.ZEROPAGE_MEMORY.equals(memoryArea)) {
            lValue.setMemoryArea(Variable.MemoryArea.ZEROPAGE_MEMORY);
            Registers.Register register = new Registers.RegisterZpMem(addressDirective.address.intValue(), -1, true);
            lValue.setDeclaredRegister(register);
         } else {
            lValue.setMemoryArea(Variable.MemoryArea.MAIN_MEMORY);
            Registers.Register register = new Registers.RegisterMainMem((VariableRef) lValue.getRef(), -1, addressDirective.address);
            lValue.setDeclaredRegister(register);
         }
      }

      Directive.NamedRegister registerDirective = findDirective(Directive.NamedRegister.class, sourceDirectives);
      if(registerDirective != null) {
         lValue.setDeclaredAsRegister(true);
         Registers.Register register = Registers.getRegister(registerDirective.name);
         if(register == null) {
            throw new CompileError("Error! Unknown register " + registerDirective.name, source);
         }
         lValue.setDeclaredRegister(register);
      }

      Directive.Align alignDirective = findDirective(Directive.Align.class, sourceDirectives);
      if(alignDirective != null) {
         if(directiveType.equals(DirectiveType.ARRAY)) {
            lValue.setDeclaredAlignment(alignDirective.alignment);
         } else {
            throw new CompileError("Error! Cannot align variable that is not a string or an array " + lValue.toString(), source);
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
