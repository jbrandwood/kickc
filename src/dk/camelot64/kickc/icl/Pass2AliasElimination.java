package dk.camelot64.kickc.icl;

import java.util.HashMap;
import java.util.Map;

/** Compiler Pass eliminating alias assignments */
public class Pass2AliasElimination extends Pass2Optimization {

   public Pass2AliasElimination(ControlFlowGraph graph, SymbolTable symbolTable) {
      super(graph, symbolTable);
   }

   /**
    * Eliminate alias assignments replacing them with the aliassed variable.
    */
   @Override
   public boolean optimize() {
      final Map<Variable, Variable> aliases = findAliases();
      removeAssignments(aliases.values());
      replaceVariables(aliases);
      deleteSymbols(aliases.keySet());
      for (Variable var : aliases.keySet()) {
         Variable alias = aliases.get(var);
         System.out.println("Alias " + var + " " + alias);
      }
      return (aliases.size()>0);
   }

   /**
    * Find variables that have constant values.
    * @return Map from Variable to the Constant value
    */
   private Map<Variable, Variable> findAliases() {
      final Map<Variable, Variable> aliases = new HashMap<>();
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitAssignment(StatementAssignment assignment) {
            if (assignment.getLValue() instanceof VariableVersion || assignment.getLValue() instanceof VariableIntermediate) {
               Variable variable = (Variable) assignment.getLValue();
               if (assignment.getRValue1() == null && assignment.getOperator() == null && assignment.getRValue2() instanceof Variable) {
                  // Alias assignment
                  Variable alias = (Variable) assignment.getRValue2();
                  aliases.put(alias, variable);
               }
            }
            return null;
         }

         @Override
         public Void visitPhi(StatementPhi phi) {
            if(phi.getPreviousVersions().size()==1) {
               StatementPhi.PreviousSymbol previousSymbol = phi.getPreviousVersions().get(0);
               if(previousSymbol.getRValue() instanceof Variable) {
                  VariableVersion variable = phi.getLValue();
                  Variable alias = (Variable) previousSymbol.getRValue();
                  aliases.put(alias, variable);
               }
            }
            return null;
         }
      };
      visitor.visitGraph(getGraph());
      return aliases;
   }


}
