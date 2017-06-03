package dk.camelot64.kickc.icl;

import java.util.*;

/** Compiler Pass eliminating alias assignments */
public class Pass2AliasElimination extends Pass2SsaOptimization {

   public Pass2AliasElimination(ControlFlowGraph graph, SymbolTable symbolTable) {
      super(graph, symbolTable);
   }


   /**
    * Eliminate alias assignments replacing them with the aliassed variable.
    */
   @Override
   public boolean optimize() {
      final Aliases aliases = findAliases();
      removeAssignments(aliases.getAssignmentsToRemove());
      replaceVariables(aliases.getReplacements());
      deleteSymbols(aliases.getSymbolsToRemove());
      for (Alias alias : aliases.getAliases()) {
         System.out.println("Alias " + alias.getKeep() + " " + alias.getEliminate());
      }
      return (aliases.size()>0);
   }

   private static class Aliases {
      private List<Alias> aliases;

      public Aliases() {
         this.aliases = new ArrayList<>();
      }

      public List<Alias> getAliases() {
         return aliases;
      }

      public List<Variable> getAssignmentsToRemove() {
         ArrayList<Variable> eliminates = new ArrayList<>();
         for (Alias alias : aliases) {
            if(alias.isKeepHasDefinition()) {
               eliminates.add(alias.getEliminate());
            } else {
               eliminates.add(alias.getKeep());
            }
         }
         return eliminates;
      }

      public List<Variable> getSymbolsToRemove() {
         ArrayList<Variable> eliminates = new ArrayList<>();
         for (Alias alias : aliases) {
            eliminates.add(alias.getEliminate());
         }
         return eliminates;
      }

      public Map<Variable, Variable> getReplacements() {
         HashMap<Variable, Variable> replacements = new HashMap<>();
         for (Alias alias : aliases) {
            replacements.put(alias.getEliminate(), alias.getKeep());
         }
         return replacements;
      }

      public int size() {
         return aliases.size();
      }

      public void add(Variable lValue, Variable rValue) {
         if(lValue instanceof VariableVersion && rValue instanceof VariableIntermediate) {
            aliases.add(new Alias(lValue, rValue, false));
         } else {
            aliases.add(new Alias(rValue, lValue, true));
         }
      }

   }

   private static class Alias {
      private Variable keep;
      private Variable eliminate;
      // true if the symbol to keep has the proper definition of the value.
      private boolean keepHasDefinition;

      public Alias(Variable keep, Variable eliminate, boolean keepHasDefinition) {
         this.keep = keep;
         this.eliminate = eliminate;
         this.keepHasDefinition = keepHasDefinition;
      }

      public Variable getEliminate() {
         return eliminate;
      }

      public Variable getKeep() {
         return keep;
      }

      public boolean isKeepHasDefinition() {
         return keepHasDefinition;
      }
   }



   private Aliases findAliases() {
      Aliases candidates = findAliasesCandidates();
      cleanupCandidates(candidates);
      return candidates;
   }

   // Remove all candidates that are used after assignment in phi blocks
   private void cleanupCandidates(Aliases candidates) {
      Iterator<Alias> candidateIt = candidates.getAliases().iterator();
      while (candidateIt.hasNext()) {
         Alias candidate = candidateIt.next();
         final Variable varEliminate = candidate.getEliminate();
         final Variable varKeep = candidate.getKeep();
         final Boolean[] rMatch = {false};
         final Boolean[] lMatch = {false};
         ControlFlowGraphBaseVisitor<Void> candidateEliminator = new ControlFlowGraphBaseVisitor<Void>() {
            @Override
            public Void visitPhi(StatementPhi phi) {
               for (StatementPhi.PreviousSymbol previousSymbol : phi.getPreviousVersions()) {
                  if (previousSymbol.getRValue().equals(varKeep)) {
                     rMatch[0] = true;
                     break;
                  }
               }
               if (phi.getLValue().equals(varEliminate)) {
                  lMatch[0] = true;
               }
               return null;
            }
         };
         candidateEliminator.visitGraph(getGraph());
         if (rMatch[0] && lMatch[0]) {
            System.out.println("Alias candidate removed " + varEliminate + " " + varKeep);
            candidateIt.remove();
         }
      }
   }

   /**
    * Find variables that have constant values.
    * @return Map from Variable to the Constant value
    */
   private Aliases  findAliasesCandidates() {
      final Aliases aliases = new Aliases();
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitAssignment(StatementAssignment assignment) {
            if (assignment.getLValue() instanceof VariableVersion || assignment.getLValue() instanceof VariableIntermediate) {
               Variable variable = (Variable) assignment.getLValue();
               if (assignment.getRValue1() == null && assignment.getOperator() == null && assignment.getRValue2() instanceof Variable) {
                  // Alias assignment
                  Variable alias = (Variable) assignment.getRValue2();
                  aliases.add(variable, alias);
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
                  aliases.add(variable, alias);
               }
            }
            return null;
         }
      };
      visitor.visitGraph(getGraph());
      return aliases;
   }


}
