package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.*;

/**
 * Compiler Pass eliminating alias assignments
 */
public class Pass2AliasElimination extends Pass2SsaOptimization {

   public Pass2AliasElimination(Program program) {
      super(program);
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
         str.append(aliasSet.getKeepVar().toString(getProgram()));
         str.append(" = ");
         for (VariableRef var : aliasSet.getEliminateVars()) {
            str.append(var.toString(getProgram()) + " ");
         }
         getLog().append("Alias " + str);
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
            } else if (statement instanceof StatementPhiBlock) {
               StatementPhiBlock phiBlock = (StatementPhiBlock) statement;
               Iterator<StatementPhiBlock.PhiVariable> variableIterator = phiBlock.getPhiVariables().iterator();
               while (variableIterator.hasNext()) {
                  StatementPhiBlock.PhiVariable phiVariable = variableIterator.next();
                  AliasSet aliasSet = aliases.findAliasSet(phiVariable.getVariable());
                  if (aliasSet != null) {
                     if (phiVariable.getValues().size() == 1 && aliasSet.contains(phiVariable.getValues().get(0).getrValue())) {
                        variableIterator.remove();
                     }
                  }
               }
               if(phiBlock.getPhiVariables().size()==0) {
                  iterator.remove();
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
               if (var.isVersion()) {
                  if (keep.isVersion()) {
                     if (var.getScopeDepth() < keep.getScopeDepth()) {
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
         for (ControlFlowBlock block : getGraph().getAllBlocks()) {
            if(block.hasPhiBlock()) {
               StatementPhiBlock phi = block.getPhiBlock();
               boolean lMatch = false;
               for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
                  if(lMatch) {
                     for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                        RValue rValue = phiRValue.getrValue();
                        if (aliasSet.contains(rValue)) {
                           getLog().append("Alias candidate removed " + rValue.toString(getProgram()));
                           aliasSet.remove(rValue);
                           break;
                        }
                     }
                  } else {
                     if (aliasSet.contains(phiVariable.getVariable())) {
                        lMatch = true;
                     }
                  }
               }
            }
         }
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
                  if(variable.getScopeNames().equals(alias.getScopeNames())){
                     aliases.add(variable, alias);
                  } else {
                     getLog().append("Not aliassing across scopes: "+variable+" "+alias);
                  }
               }
            }
            return null;
         }

         @Override
         public Void visitPhiBlock(StatementPhiBlock phi) {
            for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
               if(phiVariable.getValues().size()==1) {
                  StatementPhiBlock.PhiRValue phiRValue = phiVariable.getValues().get(0);
                  if (phiRValue.getrValue() instanceof VariableRef) {
                     VariableRef variable = phiVariable.getVariable();
                     VariableRef alias = (VariableRef) phiRValue.getrValue();
                     if(variable.getScopeNames().equals(alias.getScopeNames())){
                        aliases.add(variable, alias);
                     } else {
                        getLog().append("Not aliassing across scopes: "+variable+" "+alias);
                     }
                  }
               }
            }
            return null;
         }
      };
      visitor.visitGraph(getGraph());
      return aliases;
   }


}
