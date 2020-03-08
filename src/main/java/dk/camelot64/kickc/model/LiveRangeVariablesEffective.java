package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.passes.Pass2AliasElimination;

import java.util.*;

public interface LiveRangeVariablesEffective {

   Collection<VariableRef> getAliveEffective(Statement statement);

   AliveCombinations getAliveCombinations(Statement statement);

   /**
    * Combinations of variables effectively alive at a specific statement.
    */
   interface AliveCombinations {

      /**
       * Get all effective alive combinations for a specific statement.
       * @return All effective alive combinations
       */
      Collection<AliveCombination> getAll();

   }

   /** An alive combination at a specific statement */
   interface AliveCombination {

      Collection<VariableRef> getEffectiveAliveAtStmt();

      Pass2AliasElimination.Aliases getEffectiveAliasesAtStmt();
   }

}
