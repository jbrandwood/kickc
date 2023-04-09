package dk.camelot64.kickc.passes.utils;

import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ProcedureRef;

import java.util.Collection;
import java.util.LinkedHashSet;

public class StatementsBetween {
   /**
    * Get all statements executed between two statements (none of these are included in the result)
    *
    * @param from The statement to start at
    * @param to The statement to end at
    * @return All statements executed between the two passed statements
    */
   public static Collection<Statement> find(Statement from, Graph.Block fromBlock, Statement to, Graph graph) {
      Collection<Statement> between = new LinkedHashSet<>();
      populateStatementsBetween(fromBlock, from, to, false, between, graph);
      return between;
   }

   /**
    * Fill the between collection with all statements executed between two statements (none of these are included in the result)
    *
    * @param block The block to start from
    * @param from The statement where we start counting (not included)
    * @param to The statement to end at (not included)
    * @param isBetween Are we already between from and to?
    * @param between The between collection, being populated
    */
   private static void populateStatementsBetween(Graph.Block block, Statement from, Statement to, boolean isBetween, Collection<Statement> between, Graph graph) {
      for(Statement statement : block.getStatements()) {
         if(between.contains(statement))
            // Stop infinite recursion
            return;
         if(isBetween) {
            if(statement.equals(to))
               // The end was reached!
               isBetween = false;
            else
               // We are between - add the statement
               between.add(statement);
         } else {
            if(statement.equals(from))
               // We are now between!
               isBetween = true;
         }
      }
      if(isBetween) {
         // Recurse to successor blocks
         final Collection<LabelRef> successors = block.getSuccessors();
         for(LabelRef successor : successors) {
            if(successor.getFullName().equals(ProcedureRef.PROCEXIT_BLOCK_NAME))
               continue;
            final Graph.Block successorBlock = graph.getBlock(successor);
            populateStatementsBetween(successorBlock, from, to, true, between, graph);
         }
      }
   }
}
