package dk.camelot64.kickc.icl;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * The register weights for each variable.
 * The register weight signifies how beneficial it would be for the variable to assigned to a register (instead of zero page).
 */
public class VariableRegisterWeights {

   private Map<VariableRef, Double> registerWeights;

   public VariableRegisterWeights() {
      this.registerWeights = new LinkedHashMap<>();
   }

   /**
    * Add to the weight of a variable
    *
    * @param variableRef The variable
    * @param w           The amount to add to the weight
    */
   public void addWeight(VariableRef variableRef, double w) {
      Double weight = this.registerWeights.get(variableRef);
      if (weight == null) {
         weight = 0.0;
      }
      weight = weight + w;
      this.registerWeights.put(variableRef, weight);
   }

   public Double getWeight(VariableRef variable) {
      return registerWeights.get(variable);
   }
}
