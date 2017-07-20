package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.LinkedHashMap;
import java.util.Map;

/** Compiler Pass eliminating redundant phi functions */
public class Pass2RedundantPhiElimination extends Pass2SsaOptimization {

   public Pass2RedundantPhiElimination(Program program, CompileLog log) {
      super(program, log);
   }

   /**
    * Eliminate alias assignments replacing them with the aliased variable.
    */
   @Override
   public boolean optimize() {
      final Map<VariableRef, RValue> aliases = findRedundantPhis();
      removeAssignments(aliases.keySet());
      replaceVariables(aliases);
      for (VariableRef var : aliases.keySet()) {
         RValue alias = aliases.get(var);
         log.append("Redundant Phi " + var.getAsTypedString(getSymbols()) + " " + alias.getAsTypedString(getSymbols()));
      }
      deleteVariables(aliases.keySet());
      return aliases.size()>0;
   }

   /**
    * Find phi variables where all previous symbols are identical.
    * @return Map from (phi) Variable to the previous value
    */
   private Map<VariableRef, RValue> findRedundantPhis() {
      final Map<VariableRef, RValue> aliases = new LinkedHashMap<>();
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitPhi(StatementPhi phi) {
            boolean found = true;
            RValue phiRValue = null;
            for (StatementPhi.PreviousSymbol previousSymbol : phi.getPreviousVersions()) {
               if(phiRValue==null) {
                  phiRValue = previousSymbol.getrValue();
               } else {
                  if(!phiRValue.equals(previousSymbol.getrValue())) {
                     found = false;
                     break;
                  }
               }
            }
            if(found) {
               VariableRef variable = phi.getlValue();
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
