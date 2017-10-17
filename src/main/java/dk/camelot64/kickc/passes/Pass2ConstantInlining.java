package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/** Compiler Pass consolidating unnamed constants and constant aliasses into the place using them (instructions or the definition of another constant value).
 *    <ul>
 *       <li> Unnamed constant:   $1 = VIC+$20 </li>
 *       <li> Constant alias:     i#1 = i#0    </li>
 *    </ul>
 * */
public class Pass2ConstantInlining extends Pass2SsaOptimization {

   public Pass2ConstantInlining(Program program) {
      super(program);
   }

   /**
    * Consolidate unnamed constants into other constants value
    * @return true optimization was performed. false if no optimization was possible.
    */
   @Override
   public boolean optimize() {
      Map<ConstantRef, ConstantValue> inline = new HashMap<>();
      inline.putAll(findUnnamedConstants());
      inline.putAll(findAliasConstants());
      inline.putAll(findConstVarVersions());

      // Perform alias replacement within the constant values inside the aliases
      replaceInValues(inline);
      // Replace all usages of the constants in the control flow graph
      replaceVariables(inline);
      // Remove from symbol table
      deleteSymbols(inline.keySet());
      // Replace all usages of the constants in constant definitions inside the symbol table
      replaceInSymbolTable(inline);


      for (ConstantRef constantRef : inline.keySet()) {
         getLog().append("Constant inlined " + constantRef.toString()+" = "+inline.get(constantRef).toString(getProgram()));
      }

      return inline.size()>0;

   }

   /**
    * Replace any alias within the constant defimtions inside the symbol table
    * @param inline The replacements to make
    */
   private void replaceInSymbolTable(Map<ConstantRef, ConstantValue> inline) {
      VariableReplacer replacer = new VariableReplacer(inline);
      Collection<ConstantVar> allConstants = getProgram().getScope().getAllConstants(true);
      for (ConstantVar constantVar : allConstants) {
         ConstantValue constantValue = constantVar.getValue();
         RValue replacement = replacer.getReplacement(constantValue);
         if(replacement!=null) {
            constantVar.setValue((ConstantValue) replacement);
         }
      }
   }

   /**
    * Replace any aliases within the constant values themselves
    * @param inline The replacements
    */
   private void replaceInValues(Map<ConstantRef, ConstantValue> inline) {
      VariableReplacer replacer = new VariableReplacer(inline);
      boolean replaced = true;
      while(replaced) {
         replaced = false;
         for (ConstantRef constantRef : inline.keySet()) {
            ConstantValue constantValue = inline.get(constantRef);
            ConstantValue replacement = (ConstantValue) replacer.getReplacement(constantValue);
            if (replacement != null) {
               replaced = true;
               inline.put(constantRef, replacement);
            }
         }
      }
   }

   /**
    * Find all unnamed constants $1 = VIC+$20
    * @return Map from constant name to constant value
    */
   private Map<ConstantRef, ConstantValue> findUnnamedConstants() {
      Map<ConstantRef, ConstantValue> unnamed = new HashMap<>();
      Collection<ConstantVar> allConstants = getProgram().getScope().getAllConstants(true);
      for (ConstantVar constant : allConstants) {
         if(constant.getRef().isIntermediate()) {
            unnamed.put(constant.getRef(), constant.getValue());
         }
      }
      return unnamed;
   }

   /**
    * Find all constant aliases. An alias is a constant with the exact same value as another constant eg. i#2 = i#0
    * @return Map from constant name to constant value
    */
   private Map<ConstantRef, ConstantValue> findAliasConstants() {
      Map<ConstantRef, ConstantValue> aliases = new HashMap<>();
      Collection<ConstantVar> allConstants = getProgram().getScope().getAllConstants(true);
      for (ConstantVar constant : allConstants) {
         ConstantValue constantValue = constant.getValue();
         if(constantValue instanceof ConstantRef) {
            aliases.put(constant.getRef(), constant.getValue());
         }
      }
      return aliases;
   }

   /**
    * Find single variable versions that are constant eg. i#0 = 0
    * @return Map from constant name to constant value
    */
   private Map<ConstantRef, ConstantValue> findConstVarVersions() {
      Map<ConstantRef, ConstantValue> aliases = new HashMap<>();

      Collection<ConstantVar> allConstants = getProgram().getScope().getAllConstants(true);
      for (ConstantVar constant : allConstants) {
         if(constant.getRef().isVersion()) {
            // Constant is a version - find the other versions
            String baseName = constant.getRef().getFullNameUnversioned();
            Collection<Symbol> scopeSymbols = constant.getScope().getAllSymbols();
            for (Symbol symbol : scopeSymbols) {
               if(symbol.getRef().isVersion() && symbol.getRef().getFullNameUnversioned().equals(baseName)) {
                  if(symbol instanceof Variable) {
                     aliases.put(constant.getRef(), constant.getValue());
                  }
               }
            }
         }
      }
      return aliases;
   }


}
