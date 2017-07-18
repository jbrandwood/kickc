package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.LinkedHashMap;
import java.util.Map;

/** Compiler Pass eliminating redundant phi functions */
public class Pass2RedundantPhiElimination extends Pass2SsaOptimization {

   public Pass2RedundantPhiElimination(ControlFlowGraph graph, Scope scope, CompileLog log) {
      super(graph, scope, log);
   }

   /**
    * Eliminate alias assignments replacing them with the aliased variable.
    */
   @Override
   public boolean optimize() {
      final Map<Variable, RValue> aliases = findRedundantPhis();
      removeAssignments(aliases.keySet());
      deleteSymbols(aliases.keySet());
      replaceVariables(aliases);
      for (Variable var : aliases.keySet()) {
         RValue alias = aliases.get(var);
         log.append("Redundant Phi " + var + " " + alias);
      }
      return aliases.size()>0;
   }

   /**
    * Find phi variables where all previous symbols are identical.
    * @return Map from (phi) Variable to the previous value
    */
   private Map<Variable, RValue> findRedundantPhis() {
      final Map<Variable, RValue> aliases = new LinkedHashMap<>();
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
               VariableVersion variable = phi.getlValue();
               if(phiRValue==null) {phiRValue = VOID;}
               aliases.put(variable, phiRValue);
            }
            return null;
         }
      };
      visitor.visitGraph(getGraph());
      return aliases;
   }

}
