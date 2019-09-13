package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantArray;
import dk.camelot64.kickc.model.values.ConstantRef;
import dk.camelot64.kickc.model.values.ConstantString;
import dk.camelot64.kickc.model.values.ConstantValue;

import java.util.*;

/**
 * Compiler Pass consolidating unnamed constants and constant aliasses into the place using them (instructions or the definition of another constant value).
 * <ul>
 * <li> Unnamed constant:   $1 = VIC+$20 </li>
 * <li> Constant alias:     i#1 = i#0    </li>
 * </ul>
 */
public class Pass2ConstantInlining extends Pass2SsaOptimization {

   public Pass2ConstantInlining(Program program) {
      super(program);
   }

   /**
    * Consolidate unnamed constants into other constants value
    *
    * @return true optimization was performed. false if no optimization was possible.
    */
   @Override
   public boolean step() {
      Map<ConstantRef, ConstantValue> inline = new HashMap<>();
      inline.putAll(findAliasConstants());
      inline.putAll(findUnnamedConstants());
      inline.putAll(findConstVarVersions());

      // Remove all string constants
      List<ConstantRef> refs = new ArrayList(inline.keySet());
      for(ConstantRef constantRef : refs) {
         ConstantValue constantValue = inline.get(constantRef);
         if(constantValue instanceof ConstantString) {
            inline.remove(constantRef);
         }
      }

      // Perform alias replacement within the constant values inside the aliases
      replaceInValues(inline);
      // Replace all usages of the constants in the control flow graph or symbol table
      replaceVariables(inline);
      // Remove from symbol table
      deleteSymbols(getScope(), inline.keySet());

      for(ConstantRef constantRef : inline.keySet()) {
         getLog().append("Constant inlined " + constantRef.toString() + " = " + inline.get(constantRef).toString(getProgram()));
      }

      return inline.size() > 0;

   }

   /**
    * Replace any aliases within the constant values themselves
    *
    * @param inline The replacements
    */
   private void replaceInValues(Map<ConstantRef, ConstantValue> inline) {
      boolean replaced = true;
      while(replaced) {
         replaced = false;
         for(ConstantRef constantRef : inline.keySet()) {
            ConstantValue constantValue = inline.get(constantRef);
            ProgramValue.GenericValue genericValue = new ProgramValue.GenericValue(constantValue);
            AliasReplacer replacer = new AliasReplacer(inline);
            ProgramValueIterator.execute(genericValue, replacer, null, null, null);
            if(replacer.isReplaced()) {
               inline.put(constantRef, (ConstantValue) genericValue.get());
            }
         }
      }
   }

   /**
    * Find all unnamed constants $1 = VIC+$20
    *
    * @return Map from constant name to constant value
    */
   private Map<ConstantRef, ConstantValue> findUnnamedConstants() {
      Map<ConstantRef, ConstantValue> unnamed = new HashMap<>();
      Collection<ConstantVar> allConstants = getProgram().getScope().getAllConstants(true);
      for(ConstantVar constant : allConstants) {
         if(constant.getRef().isIntermediate()) {
            if(!(constant.getType().equals(SymbolType.STRING)) && !(constant.getValue() instanceof ConstantArray)) {
               unnamed.put(constant.getRef(), constant.getValue());
            }
         }
      }
      return unnamed;
   }

   /**
    * Find all constant aliases. An alias is a constant with the exact same value as another constant eg. i#2 = i#0
    *
    * @return Map from constant name to constant value
    */
   private Map<ConstantRef, ConstantValue> findAliasConstants() {
      Map<ConstantRef, ConstantValue> aliases = new HashMap<>();
      ProgramScope programScope = getProgram().getScope();
      Collection<ConstantVar> allConstants = programScope.getAllConstants(true);
      for(ConstantVar constant : allConstants) {
         ConstantValue constantValue = constant.getValue();
         if(constantValue instanceof ConstantRef) {
            if(((ConstantRef) constantValue).isIntermediate()) {
               // The value is an intermediate constant - replace all uses of the intermediate with uses of the referrer instead.
               aliases.put((ConstantRef) constant.getValue(), constant.getRef());
               constant.setValue(programScope.getConstant((ConstantRef) constantValue).getValue());
            } else {
               aliases.put(constant.getRef(), constant.getValue());
            }
         }
      }
      return aliases;
   }

   /**
    * Find
    * - variable versions that are constant, while other versions are still variable eg. i#0 = 0, i#1 = i#0 + 1
    * - constant versions where other constant versions have different values eg. line(1); line(2); (the constants here are the parameters to the method line)
    *
    * @return Map from constant name to constant value
    */
   private Map<ConstantRef, ConstantValue> findConstVarVersions() {
      Map<ConstantRef, ConstantValue> aliases = new HashMap<>();

      Collection<ConstantVar> allConstants = getProgram().getScope().getAllConstants(true);
      for(ConstantVar constant : allConstants) {
         if(constant.getRef().isVersion()) {
            // Constant is a version - find the other versions
            String baseName = constant.getRef().getFullNameUnversioned();
            Collection<Symbol> scopeSymbols = constant.getScope().getAllSymbols();
            for(Symbol symbol : scopeSymbols) {
               if(symbol.getRef().isVersion() && symbol.getRef().getFullNameUnversioned().equals(baseName)) {
                  ConstantValue value = constant.getValue();
                  if(symbol instanceof Variable) {
                     aliases.put(constant.getRef(), value);
                     getLog().append("Inlining constant with var siblings " + constant);
                     break;
                  } else if(symbol instanceof ConstantVar) {
                     ConstantValue otherValue = ((ConstantVar) symbol).getValue();
                     if(!otherValue.equals(value) && !(value instanceof ConstantString) && !(value instanceof ConstantArray) && !(otherValue instanceof ConstantRef)) {
                        aliases.put(constant.getRef(), value);
                        getLog().append("Inlining constant with different constant siblings " + constant);
                        break;
                     }
                  }
               }
            }
         }
      }
      return aliases;
   }

}
