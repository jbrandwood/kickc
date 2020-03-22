package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.passes.Pass2AliasElimination;

import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Simple and fast implementation of effective alive variables that combines all call-path combinations into a single set and callpath aliases are not handled
 */
public class LiveRangeVariablesEffectiveSimple implements LiveRangeVariablesEffective {

   /** All variables potentially effective alive by statement index. */
   private Map<Integer, Collection<VariableRef>> statementAliveEffective;
   /** Block aliases for each statement. */
   private Map<Integer, Pass2AliasElimination.Aliases> statementLocalAliases;

   public LiveRangeVariablesEffectiveSimple(LinkedHashMap<Integer, Collection<VariableRef>> statementAliveEffective, Map<Integer, Pass2AliasElimination.Aliases> statementLocalAliases) {
      this.statementAliveEffective = statementAliveEffective;
      this.statementLocalAliases = statementLocalAliases;
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

   /**
    * Get local aliases at a statement.
    *
    * @param statement The statement to examine
    * @return All local aliases
    */
   @Override
   public AliveCombinations getAliveCombinations(Statement statement) {
      return new AliveCombinationsSimple(getAliveEffective(statement), getLocalAliases(statement));
   }

   private Pass2AliasElimination.Aliases getLocalAliases(Statement statement) {
      return statementLocalAliases.get(statement.getIndex());
   }

   public static class AliveCombinationsSimple implements AliveCombinations {

      private Collection<VariableRef> alive;

      private Pass2AliasElimination.Aliases localAliases;

      AliveCombinationsSimple(Collection<VariableRef> alive, Pass2AliasElimination.Aliases localAliases) {
         this.alive = alive;
         this.localAliases = localAliases;
      }

      @Override
      public Collection<AliveCombination> getAll() {
         final ArrayList<AliveCombination> aliveCombinations = new ArrayList<>();
         aliveCombinations.add(new AliveCombinationSimple(alive, localAliases));
         return aliveCombinations;
      }
   }

   public static class AliveCombinationSimple implements AliveCombination {

      private Collection<VariableRef> alive;

      private Pass2AliasElimination.Aliases localAliases;

      AliveCombinationSimple(Collection<VariableRef> alive, Pass2AliasElimination.Aliases localAliases) {
         this.alive = alive;
         this.localAliases = localAliases;
      }

      @Override
      public Collection<VariableRef> getEffectiveAliveAtStmt() {
         return alive;
      }

      @Override
      public Pass2AliasElimination.Aliases getEffectiveAliasesAtStmt() {
         return localAliases;
      }

      public String toString(Program program) {
         final Pass2AliasElimination.Aliases aliases = getEffectiveAliasesAtStmt();
         return getAliveString(alive) + " " + getAliasString(aliases, program);
      }

      private String getAliasString(Pass2AliasElimination.Aliases aliases, Program program) {
         if(aliases == null)
            return "";
         else
            return aliases.toString(program);
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
