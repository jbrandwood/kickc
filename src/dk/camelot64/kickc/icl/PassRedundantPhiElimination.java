package dk.camelot64.kickc.icl;

import java.util.HashMap;
import java.util.Map;

/** Compiler Pass eliminating redundant phi functions */
public class PassRedundantPhiElimination {

   private SymbolTable symbolTable;
   private ControlFlowGraph graph;

   public PassRedundantPhiElimination(SymbolTable symbolTable, ControlFlowGraph graph) {
      this.symbolTable = symbolTable;
      this.graph = graph;
   }

   /**
    * Eliminate alias assignments replacing them with the aliassed variable.
    */
   public void eliminate() {
      final Map<Variable, RValue> aliases = findRedundantPhis();
      PassHelper.removeAssignments(graph, symbolTable, aliases.keySet());
      PassHelper.replace(graph, aliases);
      for (Variable var : aliases.keySet()) {
         RValue alias = aliases.get(var);
         System.out.println("Redundant Phi " + var + " " + alias);
      }
   }

   /**
    * Find phi variables where all previous symbols are identical.
    * @return Map from (phi) Variable to the previous value
    */
   private Map<Variable, RValue> findRedundantPhis() {
      final Map<Variable, RValue> aliases = new HashMap<>();
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitPhi(StatementPhi phi) {
            boolean found = true;
            RValue phiRValue = null;
            for (StatementPhi.PreviousSymbol previousSymbol : phi.getPreviousVersions()) {
               if(phiRValue==null) {
                  phiRValue = previousSymbol.getRValue();
               } else {
                  if(!phiRValue.equals(previousSymbol.getRValue())) {
                     found = false;
                     break;
                  }
               }
            }
            if(found) {
               VariableVersion variable = phi.getLValue();
               aliases.put(variable, phiRValue);
            }
            return null;
         }
      };
      visitor.visitGraph(graph);
      return aliases;
   }

}
