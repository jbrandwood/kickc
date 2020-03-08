package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.passes.Pass2AliasElimination;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;

/**
 * Simple and fast implementation of effective alive variables that combines all call-path combinations into a single set and callpath aliases are not handled
 */
public class LiveRangeVariablesEffectiveSimple implements LiveRangeVariablesEffective {

   /** All variables potentially effective alive by statement index. */
   private Map<Integer, Collection<VariableRef>> statementAliveEffective;

   public LiveRangeVariablesEffectiveSimple(Map<Integer, Collection<VariableRef>> statementAliveEffective) {
      this.statementAliveEffective = statementAliveEffective;
   }

   /**
    * Get all variables potentially alive at a statement.
    * If the statement is inside a method this also includes all variables alive at the exit of any call.
    * </p>
    *
    * @param statement The statement to examine
    * @return All variables potentially alive at the statement
    */
   @Override
   public Collection<VariableRef> getAliveEffective(Statement statement) {
      return statementAliveEffective.get(statement.getIndex());
   }

   @Override
   public AliveCombinations getAliveCombinations(Statement statement) {
      return new AliveCombinationsSimple(getAliveEffective(statement));
   }

   public class AliveCombinationsSimple implements AliveCombinations {

      private Collection<VariableRef> alive;

      public AliveCombinationsSimple(Collection<VariableRef> alive) {
         this.alive = alive;
      }

      @Override
      public Collection<AliveCombination> getAll() {
         final ArrayList<AliveCombination> aliveCombinations = new ArrayList<>();
         aliveCombinations.add(new AliveCombinationSimple(alive));
         return aliveCombinations;
      }
   }

   public class AliveCombinationSimple implements AliveCombination {

      private Collection<VariableRef> alive;

      public AliveCombinationSimple(Collection<VariableRef> alive) {
         this.alive = alive;
      }

      @Override
      public Collection<VariableRef> getEffectiveAliveAtStmt() {
         return alive;
      }

      @Override
      public Pass2AliasElimination.Aliases getEffectiveAliasesAtStmt() {
         return null;
      }

      @Override
      public String toString() {
         return getAliveString(alive);
      }

      private String getAliveString(Collection<VariableRef> alive) {
         StringBuilder str = new StringBuilder();
         str.append(" [ ");
         for(VariableRef variableRef : alive) {
            str.append(variableRef.getFullName());
            str.append(" ");
         }
         str.append("]");
         return str.toString();
      }
   }

   @Override
   public String getSizeInfo() {
      StringBuilder sizeInfo = new StringBuilder();
      if(this.statementAliveEffective != null) {
         sizeInfo.append("SIZE statementAliveEffective ").append(statementAliveEffective.size()).append(" statements ");
         int sub = 0;
         for(Collection<VariableRef> variableRefs : statementAliveEffective.values()) {
            sub += variableRefs.size();
         }
         sizeInfo.append(" ").append(sub).append(" varrefs").append("\n");
      }
      return sizeInfo.toString();
   }
}
