package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeIntegerFixed;
import dk.camelot64.kickc.model.values.*;
import kickass.nonasm.c64.CharToPetsciiConverter;

import java.util.*;

/**
 * A fragment specification generated from a {@link Statement} used to load/synthesize an {@link AsmFragmentInstance} for creating ASM code for the statement
 */
public class AsmFragmentInstanceSpec {

   /**
    * The symbol table.
    */
   private Program program;

   /**
    * The string signature/name of the fragment template.
    */
   private String signature;

   /**
    * Binding of named values in the fragment to values (constants, variables, ...) .
    */
   private Map<String, Value> bindings;

   /**
    * The scope containing the fragment. Used when referencing symbols defined in other scopes.
    */
   private ScopeRef codeScopeRef;

   /**
    * Creates an asm fragment instance specification.
    *
    * @param program The symbol table
    * @param signature The fragment signature.
    * @param bindings Binding of named values in the fragment to values (constants, variables, ...)
    * @param codeScopeRef The scope containing the fragment. Used when referencing symbols defined in other scopes.
    */
   public AsmFragmentInstanceSpec(Program program, String signature, Map<String, Value> bindings, ScopeRef codeScopeRef) {
      this.program = program;
      this.signature = signature;
      this.bindings = bindings;
      this.codeScopeRef = codeScopeRef;
   }


   public String getSignature() {
      return signature;
   }

   public Program getProgram() {
      return program;
   }

   public Map<String, Value> getBindings() {
      return bindings;
   }

   public ScopeRef getCodeScope() {
      return codeScopeRef;
   }

   /** When iterating variations this is the constant value we are generating variations of. */
   private ConstantValue variationConstant;

   /** When iterating variations this is iterates the potential types for the constant value. */
   private Iterator<SymbolTypeIntegerFixed> variationIterator;

   /** The name of the current variation in the bindings. */
   private String variationCurrentName;

   /** The current variation value. */
   private SymbolType variationCurrentValue;

   /**
    * Does any more variations of the ASM fragment instance specification exist?
    * Variations are used for finding the right fragment to use for constant numbers.
    * For instance the number 1000 can be represented as several different types (unsigned/signed word/dword).
    *
    * @return true if more variations exits
    */
   public boolean hasNextVariation() {
      if(variationIterator == null) {
         // Look for variations
         // TODO Currently only one iterable constant value is handled - add support for multiple iterable constant values!
         for(String name : bindings.keySet()) {
            if(name.matches("v..c[1-9]")) {
               // Found a constant value that may be multi-typed
               Value value = bindings.get(name);
               if(value instanceof ConstantValue) {
                  ConstantLiteral constantLiteral = ((ConstantValue) value).calculateLiteral(program.getScope());
                  Long constIntValue = null;
                  if(constantLiteral instanceof ConstantInteger) {
                     constIntValue = ((ConstantInteger) constantLiteral).getValue();
                  } else if(constantLiteral instanceof ConstantChar) {
                     constIntValue = ((ConstantChar) constantLiteral).getInteger();
                  }
                  if(constIntValue != null) {
                     List<SymbolTypeIntegerFixed> types = getVariationTypes(constIntValue);
                     if(types.size() > 1) {
                        // Found constant value with multiple types
                        variationConstant = (ConstantValue) value;
                        variationIterator = types.iterator();
                        // Current name
                        variationCurrentName = name;
                        // Current value is the first value
                        variationCurrentValue = variationIterator.next();
                     }
                  }
               }
            }
         }
         // If no variations exist add empty iterator
         if(variationIterator == null) {
            List<SymbolTypeIntegerFixed> empty = new ArrayList<>();
            variationIterator = empty.iterator();
         }
      }
      return variationIterator.hasNext();
   }

   /**
    * Find any fixed integer types that can contain the passed integer value
    *
    * @param value the value to examine
    * @return All fixed size integer types capable of representing the passed value
    */
   public static List<SymbolTypeIntegerFixed> getVariationTypes(Long value) {
      ArrayList<SymbolTypeIntegerFixed> potentialTypes = new ArrayList<>();
      for(SymbolTypeIntegerFixed typeInteger : SymbolTypeIntegerFixed.getIntegerFixedTypes()) {
         if(typeInteger.contains(value)) {
            potentialTypes.add(typeInteger);
         }
      }
      return potentialTypes;
   }


   /**
    * Updates the ASM fragment instance specification to the next available variation.
    * If no more variations exist the ASM fragment instance specification will become unusable.
    */
   public void nextVariation() {
      if(hasNextVariation()) {
         SymbolType nextVariationValue = variationIterator.next();
         // Find the next name
         String variationConstName = "c" + variationCurrentName.substring(variationCurrentName.length() - 1);
         String variationNextName = AsmFragmentInstanceSpecFactory.getTypePrefix(nextVariationValue) + variationConstName;
         // Update bindings
         Value constValue = bindings.get(variationCurrentName);
         bindings.remove(variationCurrentName);
         bindings.put(variationNextName, constValue);
         // Update signature
         this.signature = signature.replace(variationCurrentName, variationNextName);
         variationCurrentName = variationNextName;
         variationCurrentValue = nextVariationValue;
      } else {
         this.signature = "no-more-variations";
         this.bindings = new LinkedHashMap<>();
      }
   }

   @Override
   public String toString() {
      StringBuilder str = new StringBuilder();
      str.append(signature).append("(");
      str.append(codeScopeRef).append(":: ");
      for(String bound : bindings.keySet()) {
         str.append(bound).append("=").append(bindings.get(bound).toString(getProgram())).append(" ");
      }
      str.append(") ");
      return str.toString();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      AsmFragmentInstanceSpec that = (AsmFragmentInstanceSpec) o;
      return
            Objects.equals(signature, that.signature) &&
            Objects.equals(bindings, that.bindings) &&
            Objects.equals(codeScopeRef, that.codeScopeRef);
   }

   @Override
   public int hashCode() {
      return Objects.hash(signature, bindings, codeScopeRef);
   }
}
