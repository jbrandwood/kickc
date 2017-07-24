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
         log.append("Redundant Phi " + var.toString(getSymbols()) + " " + alias.toString(getSymbols()));
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
         public Void visitPhiBlock(StatementPhiBlock phi) {
            for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
               boolean found = true;
               RValue rValue = null;
               for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                  if(rValue==null) {
                     rValue = phiRValue.getrValue();
                  } else {
                     if(!rValue.equals(phiRValue.getrValue())) {
                        found = false;
                        break;
                     }
                  }
               }
               if(found) {
                  VariableRef variable = phiVariable.getVariable();
                  if(rValue==null) {rValue = VOID;}
                  aliases.put(variable, rValue);
               }
            }
            return null;
         }

      };
      visitor.visitGraph(getGraph());
      return aliases;
   }

}
