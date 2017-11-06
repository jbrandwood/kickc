package dk.camelot64.kickc.model;

import java.util.*;

/** Effective variable live ranges for all statements. (Including variables alive in calling methods)
 * Created by {@link dk.camelot64.kickc.passes.Pass3CallGraphAnalysis}
 */
public class LiveRangeVariablesEffective {

   /** Effectively alive variables by statement index. */
   Map<Integer, AliveCombinations> effectiveLiveCombinations;

   public LiveRangeVariablesEffective(Map<Integer, AliveCombinations> effectiveLiveCombinations) {
      this.effectiveLiveCombinations = effectiveLiveCombinations;
   }

   /**
    * Get all variables potentially alive at a statement.
    * If the statement is inside a method this also includes all variables alive at the exit of any call.
    * </p>
    * @param statement The statement to examine
    * @return All variables potentially alive at the statement
    */
   public Collection<VariableRef> getAliveEffective(Statement statement) {
      Set<VariableRef> effectiveAliveTotal = new LinkedHashSet<>();
      AliveCombinations aliveCombinations = effectiveLiveCombinations.get(statement.getIndex());
      for (AliveCombination aliveCombination : aliveCombinations.getCombinations()) {
         effectiveAliveTotal.addAll(aliveCombination.getAlive());
      }
      return effectiveAliveTotal;
   }

   /**
    * Get all combinations of variables alive at a statement.
    * If the statement is inside a method the different combinations in the result arises from different calls of the method
    * (recursively up til the main()-method.
    * Each combination includes all variables alive at the exit of any surrounding call.
    * </p>
    * @param statement The statement to examine
    * @return All combinations of variables alive at the statement
    */
   public AliveCombinations getAliveCombinations(Statement statement) {
      return effectiveLiveCombinations.get(statement.getIndex());
   }

   /** Combinations of variables effectively alive at a specific statement.
    * If the statement is inside a method the combinations are the live variables inside the method combined with each calling statements alive vars.
    * As each caller might also be inside a methos there may be a large amount of combinations.
    */
   public static class AliveCombinations {

      private Collection<AliveCombination> combinations;

      public AliveCombinations(Collection<Collection<VariableRef>> aliveCombinations) {
         ArrayList<AliveCombination> combinations = new ArrayList<>();
         for (Collection<VariableRef> aliveCombination : aliveCombinations) {
            combinations.add(new AliveCombination(aliveCombination));
         }
         this.combinations = combinations;
      }

      public Collection<AliveCombination> getCombinations() {
         return combinations;
      }

   }

   /** One single combinations of variables effectively alive at a specific statement. */
   public static class AliveCombination {

      private Collection<VariableRef> alive;

      public AliveCombination(Collection<VariableRef> alive) {
         this.alive = alive;
      }

      public Collection<VariableRef> getAlive() {
         return alive;
      }

   }


}
