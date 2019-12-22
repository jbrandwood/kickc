package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.List;

/**
 * Used for creating {@link Variable}s with the right properties based on all their directives
 */
public class VariableBuilderContext {

   public VariableBuilderContext() {
   }

   /**
    * Applies directives to a variable.
    *
    * @param lValue The variable to apply directives to
    * @param sourceDirectives The directives found in the source code
    * @param source The source line (for exceptions)
    */
   public void applyDirectives(Variable lValue, boolean isParameter, boolean isArray, List<Directive> sourceDirectives, StatementSource source) {
      if(hasDirective(Directive.Const.class, sourceDirectives))
         lValue.setDeclaredConst(true);
      if(isArray)
         lValue.setDeclaredConst(true);
      if(hasDirective(Directive.Volatile.class, sourceDirectives))
         lValue.setDeclaredVolatile(true);
      if(hasDirective(Directive.Export.class, sourceDirectives))
         lValue.setDeclaredExport(true);
      if(hasDirective(Directive.Register.class, sourceDirectives)) {
         lValue.setMemoryArea(Variable.MemoryArea.ZEROPAGE_MEMORY);
         lValue.setDeclaredAsRegister(true);
      }
      if(isArray)
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
         if(isArray) {
            lValue.setDeclaredAlignment(alignDirective.alignment);
         } else {
            throw new CompileError("Error! Cannot align variable that is not a string or an array " + lValue.toString(), source);
         }
      }
      // TODO: Add strategy for selecting main memory for non-pointer local variables
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
