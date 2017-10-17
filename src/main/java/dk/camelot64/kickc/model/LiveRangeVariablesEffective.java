package dk.camelot64.kickc.model;

import java.util.*;

/** Effective variable live ranges for all statements. (Including variables alive in calling methods)
 * Created by {@link dk.camelot64.kickc.passes.Pass3CallGraphAnalysis}
 */
public class LiveRangeVariablesEffective {

   /** Effectively alive variables by statement index. */
   Map<Integer, Collection<VariableRef>> effectiveLiveVariables;

   public LiveRangeVariablesEffective(Map<Integer, Collection<VariableRef>> effectiveLiveVariables) {
      this.effectiveLiveVariables = effectiveLiveVariables;
   }

   /**
    * Get all variables alive at a statement.
    * If the statement is inside a method this also includes all variables alive at the exit of the calls.
    * <p>
    * This method requires a number of other analysis to be present and updated in the (global) program - especailly the Call Graph.
    * </p>
    * @param statement The statement to examine
    * @return All variables alive at the statement
    */
   public Collection<VariableRef> getAliveEffective(Statement statement) {
      return effectiveLiveVariables.get(statement.getIndex());
   }


}
