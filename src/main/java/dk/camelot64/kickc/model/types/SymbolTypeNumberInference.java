package dk.camelot64.kickc.model.types;

import java.util.ArrayList;
import java.util.List;

/**
 * Interference of possible types for constant expressions with the {@link SymbolType#NUMBER} type.
 * This is done by evaluating the constant expression to find the literal value.
 */
public class SymbolTypeNumberInference {

   /**
    * Find any fixed integer types that can contain the passed integer value
    * @param value the value to examine
    * @return All fixed size integer types capable of representing the passed value
    */
   public static List<SymbolTypeIntegerFixed> inferTypes(Long value) {
      ArrayList<SymbolTypeIntegerFixed> potentialTypes = new ArrayList<>();
      for(SymbolTypeIntegerFixed typeInteger : SymbolTypeIntegerFixed.getIntegerFixedTypes()) {
         if(typeInteger.contains(value)) {
            potentialTypes.add(typeInteger);
         }
      }
      return potentialTypes;
   }

}
