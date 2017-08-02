package dk.camelot64.kickc.icl;

import java.util.LinkedHashMap;
import java.util.List;
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

   public double getTotalWeight(LiveRangeEquivalenceClass equivalenceClass) {
      double totalWeight = 0.0;
      List<VariableRef> vars = equivalenceClass.getVariables();
      for (VariableRef var : vars) {
         Double varWeight = getWeight(var);
         totalWeight += varWeight;
      }
      return totalWeight;
   }

   public double getTotalWeights(RegisterUpliftScope upliftScope) {
      double totalWeight = 0.0;
      for (LiveRangeEquivalenceClass equivalenceClass : upliftScope.getEquivalenceClasses()) {
         totalWeight += getTotalWeight(equivalenceClass);
      }
      return totalWeight;
   }

}
