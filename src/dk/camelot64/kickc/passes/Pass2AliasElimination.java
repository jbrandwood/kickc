package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.*;

/**
 * Compiler Pass eliminating alias assignments
 */
public class Pass2AliasElimination extends Pass2SsaOptimization {

   public Pass2AliasElimination(ControlFlowGraph graph, ProgramScope scope, CompileLog log) {
      super(graph, scope, log);
   }


   /**
    * Eliminate alias assignments replacing them with the aliassed variable.
    */
   @Override
   public boolean optimize() {
      final Aliases aliases = findAliases();
      removeAliasAssignments(aliases);
      replaceVariables(aliases.getReplacements());
      for (AliasSet aliasSet : aliases.getAliasSets()) {
         StringBuilder str = new StringBuilder();
         str.append(aliasSet.getKeepVar().getAsTypedString(getSymbols()));
         str.append(" = ");
         for (VariableRef var : aliasSet.getEliminateVars()) {
            str.append(var.getAsTypedString(getSymbols()) + " ");
         }
         log.append("Alias " + str);
      }
      deleteVariables(aliases.getSymbolsToRemove());
      return (aliases.size() > 0);
   }

   /**
    * Remove all assignments that just assign an alias to itself
    *
    * @param aliases The aliases
    */

   private void removeAliasAssignments(Aliases aliases) {
      for (ControlFlowBlock block : getGraph().getAllBlocks()) {
         for (Iterator<Statement> iterator = block.getStatements().iterator(); iterator.hasNext(); ) {
            Statement statement = iterator.next();
            if (statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               AliasSet aliasSet = aliases.findAliasSet(assignment.getlValue());
               if (aliasSet != null) {
                  if ((assignment.getrValue1() == null) && (assignment.getOperator() == null) && aliasSet.contains(assignment.getrValue2())) {
                     iterator.remove();
                  }
               }
            } else if (statement instanceof StatementPhi) {
               StatementPhi phi = (StatementPhi) statement;
               AliasSet aliasSet = aliases.findAliasSet(phi.getlValue());
               if (aliasSet != null) {
                  if (phi.getPreviousVersions().size() == 1 && aliasSet.contains(phi.getPreviousVersion(0).getRValue())) {
                     iterator.remove();
                  }
               }
            }
         }
      }
   }

   public static class Aliases {

      private List<AliasSet> aliases;

      public Aliases() {
         this.aliases = new ArrayList<>();
      }

      public List<VariableRef> getSymbolsToRemove() {
         ArrayList<VariableRef> eliminates = new ArrayList<>();
         for (AliasSet alias : aliases) {
            eliminates.addAll(alias.getEliminateVars());
         }
         return eliminates;
      }

      public Map<VariableRef, VariableRef> getReplacements() {
         HashMap<VariableRef, VariableRef> replacements = new LinkedHashMap<>();
         for (AliasSet aliasSet : aliases) {
            VariableRef keepVar = aliasSet.getKeepVar();
            for (VariableRef var : aliasSet.getEliminateVars()) {
               if(!var.equals(keepVar)) {
                  replacements.put(var, keepVar);
               }
            }
         }
         return replacements;
      }

      public int size() {
         return aliases.size();
      }

      public void add(VariableRef var1, VariableRef var2) {
         AliasSet aliasSet1 = findAliasSet(var1);
         AliasSet aliasSet2 = findAliasSet(var2);
         if (aliasSet1 != null) {
            if (aliasSet2 != null) {
               aliasSet1.addAll(aliasSet2);
               aliases.remove(aliasSet2);
            } else {
               aliasSet1.add(var2);
            }
         } else {
            if (aliasSet2 != null) {
               aliasSet2.add(var1);
            } else {
               AliasSet newSet = new AliasSet();
               newSet.add(var1);
               newSet.add(var2);
               aliases.add(newSet);
            }
         }
      }

      public AliasSet findAliasSet(LValue lValue) {
         if (lValue instanceof VariableRef) {
            for (AliasSet alias : aliases) {
               if (alias.contains(lValue)) {
                  return alias;
               }
            }
         }
         return null;
      }

      public List<AliasSet> getAliasSets() {
         return aliases;
      }
   }

   public static class AliasSet {

      private List<VariableRef> vars;

      public AliasSet() {
         this.vars = new ArrayList<>();
      }

      public void add(VariableRef variable) {
         vars.add(variable);
      }

      public boolean contains(RValue rValue) {
         if (rValue instanceof VariableRef) {
            return vars.contains(rValue);
         } else {
            return false;
         }
      }

      public List<VariableRef> getVars() {
         return vars;
      }

      public void addAll(AliasSet aliasSet) {
         vars.addAll(aliasSet.getVars());
      }

      public VariableRef getKeepVar() {
         VariableRef keep = null;
         List<VariableRef> vars = new ArrayList<>(this.vars);
         Collections.sort(vars, new Comparator<VariableRef>() {
            @Override
            public int compare(VariableRef o1, VariableRef o2) {
               return o1.getFullName().compareTo(o2.getFullName());
            }
         });
         for (VariableRef var : vars) {
            if (keep == null) {
               keep = var;
            } else {
               if (isVersion(var)) {
                  if (isVersion(keep)) {
                     if (getScopeDepth(var) < getScopeDepth(keep)) {
                        keep = var;
                     }
                  } else {
                     keep = var;
                  }
               }
            }
         }
         return keep;
      }

      private int getScopeDepth(VariableRef var) {
         int depth = 0;
         char[] chars = var.getFullName().toCharArray();
         for (char c : chars) {
            if(c==':') depth++;
         }
         return depth/2;
      }

      private boolean isVersion(VariableRef var) {
         return var.getFullName().contains("#");
      }

      public List<VariableRef> getEliminateVars() {
         List<VariableRef> eliminate = new ArrayList<>();
         VariableRef keepVar = getKeepVar();
         for (VariableRef var : vars) {
            if(!var.equals(keepVar)) {
               eliminate.add(var);
            }
         }
         return eliminate;
      }

      public void remove(RValue rValue) {
         if(rValue instanceof VariableRef) {
            vars.remove(rValue);
         }
      }

   }


   private Aliases findAliases() {
      Aliases candidates = findAliasesCandidates();
      cleanupCandidates(candidates);
      return candidates;
   }

   // Remove all candidates that are used after assignment in phi blocks
   private void cleanupCandidates(Aliases candidates) {
      for (final AliasSet aliasSet : candidates.aliases) {
         final Boolean[] lMatch = {false};
         ControlFlowGraphBaseVisitor<Void> candidateEliminator = new ControlFlowGraphBaseVisitor<Void>() {
            @Override
            public Void visitBlock(ControlFlowBlock block) {
               lMatch[0] = false;
               return super.visitBlock(block);
            }
            @Override
            public Void visitPhi(StatementPhi phi) {
               if(lMatch[0]) {
                  for (StatementPhi.PreviousSymbol previousSymbol : phi.getPreviousVersions()) {
                     RValue phiRValue = previousSymbol.getRValue();
                     if (aliasSet.contains(phiRValue)) {
                        log.append("Alias candidate removed " + phiRValue.getAsTypedString(getSymbols()));
                        aliasSet.remove(phiRValue);
                        break;
                     }
                  }
               }
               if (aliasSet.contains(phi.getlValue())) {
                  lMatch[0] = true;
               }
               return null;
            }
         };
         candidateEliminator.visitGraph(getGraph());
      }
   }

   /**
    * Find variables that have constant values.
    *
    * @return Map from Variable to the Constant value
    */
   private Aliases findAliasesCandidates() {
      final Aliases aliases = new Aliases();
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitAssignment(StatementAssignment assignment) {
            if (assignment.getlValue() instanceof VariableRef) {
               VariableRef variable = (VariableRef) assignment.getlValue();
               if (assignment.getrValue1() == null && assignment.getOperator() == null && assignment.getrValue2() instanceof VariableRef) {
                  // Alias assignment
                  VariableRef alias = (VariableRef) assignment.getrValue2();
                  aliases.add(variable, alias);
               }
            }
            return null;
         }

         @Override
         public Void visitPhi(StatementPhi phi) {
            if (phi.getPreviousVersions().size() == 1) {
               StatementPhi.PreviousSymbol previousSymbol = phi.getPreviousVersions().get(0);
               if (previousSymbol.getRValue() instanceof VariableRef) {
                  VariableRef variable = phi.getlValue();
                  VariableRef alias = (VariableRef) previousSymbol.getRValue();
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
