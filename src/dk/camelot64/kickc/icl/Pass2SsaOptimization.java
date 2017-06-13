package dk.camelot64.kickc.icl;

import java.util.*;

/**
 * Optimization on Single Static Assignment form (Control Flow Graph) performed during Compiler Pass 2.
 * Optimizations are performed repeatedly until none of them yield any result
 */
public abstract class Pass2SsaOptimization {

   private ControlFlowGraph graph;
   private Scope scope;

   public Pass2SsaOptimization(ControlFlowGraph graph, Scope scope) {
      this.graph = graph;
      this.scope = scope;
   }

   public ControlFlowGraph getGraph() {
      return graph;
   }

   public Scope getSymbols() {
      return scope;
   }

   /**
    * Attempt to perform optimization.
    *
    * @return true if an optimization was performed. false if no optimization was possible.
    */
   public abstract boolean optimize();

   /**
    * Singleton signalling that an RValue is never assigned and can safely be discarded as rvalue in phi-functions.
    */
   public static RValue VOID = new RValue() {
      @Override
      public String toString() {
         return "VOID";
      }
   };

   /**
    * Replace all usages of variables in statements with aliases.
    *
    * @param aliases Variables that have alias values.
    */
   public void replaceVariables(final Map<Variable, ? extends RValue> aliases) {
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitAssignment(StatementAssignment assignment) {
            LValue lValue = assignment.getLValue();
            if (getAlias(aliases, lValue) != null) {
               RValue alias = getAlias(aliases, lValue);
               if (alias instanceof LValue) {
                  assignment.setLValue((LValue) alias);
               } else {
                  throw new RuntimeException("Error replacing LValue variable " + lValue + " with " + alias);
               }
            }
            if (getAlias(aliases, assignment.getRValue1()) != null) {
               assignment.setRValue1(getAlias(aliases, assignment.getRValue1()));
            }
            if (getAlias(aliases, assignment.getRValue2()) != null) {
               assignment.setRValue2(getAlias(aliases, assignment.getRValue2()));
            }
            // Handle pointer dereference in LValue
            if (lValue instanceof PointerDereferenceSimple) {
               PointerDereferenceSimple deref = (PointerDereferenceSimple) lValue;
               RValue pointer = deref.getPointer();
               if (getAlias(aliases, pointer) != null) {
                  RValue alias = getAlias(aliases, pointer);
                  deref.setPointer(alias);
               }
            }
            if (lValue instanceof PointerDereferenceIndexed) {
               PointerDereferenceIndexed deref = (PointerDereferenceIndexed) lValue;
               RValue pointer = deref.getPointer();
               if (getAlias(aliases, pointer) != null) {
                  RValue alias = getAlias(aliases, pointer);
                  deref.setPointer( alias);
               }
               RValue index = deref.getIndex();
               if (getAlias(aliases, index) != null) {
                  RValue alias = getAlias(aliases, index);
                  deref.setIndex(alias);
               }
            }
            return null;
         }

         @Override
         public Void visitConditionalJump(StatementConditionalJump conditionalJump) {
            if (getAlias(aliases, conditionalJump.getRValue1()) != null) {
               conditionalJump.setRValue1(getAlias(aliases, conditionalJump.getRValue1()));
            }
            if (getAlias(aliases, conditionalJump.getRValue2()) != null) {
               conditionalJump.setRValue2(getAlias(aliases, conditionalJump.getRValue2()));
            }
            return null;
         }

         @Override
         public Void visitReturn(StatementReturn aReturn) {
            if (getAlias(aliases, aReturn.getValue()) != null) {
               aReturn.setValue(getAlias(aliases, aReturn.getValue()));
            }
         }

         @Override
         public Void visitCallLValue(StatementCallLValue callLValue) {

            for (RValue parameter: callLValue.getParameters()) {

            }
         }

         @Override
         public Void visitPhi(StatementPhi phi) {
            if (getAlias(aliases, phi.getLValue()) != null) {
               RValue alias = getAlias(aliases, phi.getLValue());
               if (alias instanceof LValue) {
                  phi.setLValue((Variable) alias);
               }
            }
            for (Iterator<StatementPhi.PreviousSymbol> iterator = phi.getPreviousVersions().iterator(); iterator.hasNext(); ) {
               StatementPhi.PreviousSymbol previousSymbol = iterator.next();
               if (getAlias(aliases, previousSymbol.getRValue()) != null) {
                  RValue alias = getAlias(aliases, previousSymbol.getRValue());
                  if (VOID.equals(alias)) {
                     iterator.remove();
                  } else {
                     previousSymbol.setRValue(alias);
                  }
               }
            }
            return null;
         }
      };
      visitor.visitGraph(graph);
   }

   /**
    * Get the alias to use for an RValue.
    *
    * @param aliases The alias map
    * @param rValue  The RValue to find an alias for
    * @return The alias to use. Null if no alias exists.
    */
   private static RValue getAlias(Map<Variable, ? extends RValue> aliases, RValue rValue) {
      RValue alias = aliases.get(rValue);
      while (aliases.get(alias) != null) {
         alias = aliases.get(alias);
      }
      return alias;
   }

   /**
    * Replace all usages of a label in statements with another label.
    *
    * @param replacements Variables that have alias values.
    */
   public void replaceLabels(final Map<Label, Label> replacements) {
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {

         @Override
         public Void visitConditionalJump(StatementConditionalJump conditionalJump) {
            if (getReplacement(replacements, conditionalJump.getDestination()) != null) {
               conditionalJump.setDestination(getReplacement(replacements, conditionalJump.getDestination()));
            }
            return null;
         }

         @Override
         public Void visitJump(StatementJump jump) {
            if (getReplacement(replacements, jump.getDestination()) != null) {
               jump.setDestination(getReplacement(replacements, jump.getDestination()));
            }
            return null;
         }

         @Override
         public Void visitPhi(StatementPhi phi) {
            for (StatementPhi.PreviousSymbol previousSymbol : phi.getPreviousVersions()) {
               Label replacement = getReplacement(replacements, previousSymbol.getBlock());
               if (replacement != null) {
                  previousSymbol.setBlock(replacement);
               }
            }
            return null;
         }
      };
      visitor.visitGraph(graph);
   }

   /**
    * Get the label to use as replacement for another label.
    *
    * @param replacements The label replacement map
    * @param label        The label to find a replacement for
    * @return The alias to use. Null if no replacement exists.
    */
   private static Label getReplacement(Map<Label, Label> replacements, Label label) {
      Label replacement = replacements.get(label);
      while (replacements.get(replacement) != null) {
         replacement = replacements.get(replacement);
      }
      return replacement;
   }


   /**
    * Remove all assignments to specific LValues from the control flow graph (as they are no longer needed).
    *
    * @param variables The variables to eliminate
    */
   public void removeAssignments(Collection<? extends LValue> variables) {
      for (ControlFlowBlock block : graph.getAllBlocks()) {
         for (Iterator<Statement> iterator = block.getStatements().iterator(); iterator.hasNext(); ) {
            Statement statement = iterator.next();
            if (statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if (variables.contains(assignment.getLValue())) {
                  iterator.remove();
               }
            } else if (statement instanceof StatementPhi) {
               StatementPhi phi = (StatementPhi) statement;
               if (variables.contains(phi.getLValue())) {
                  iterator.remove();
               }
            }
         }
      }
   }

   /**
    * Remove variables from the symbol table
    *
    * @param variables The variables to remove
    */
   public void deleteSymbols(Collection<? extends LValue> variables) {
      for (LValue variable : variables) {
         scope.remove((Symbol) variable);
      }
   }

   public Map<LValue, StatementAssignment> getAllAssignments() {
      final HashMap<LValue, StatementAssignment> assignments = new HashMap<>();
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitAssignment(StatementAssignment assignment) {
            assignments.put(assignment.getLValue(), assignment);
            return null;
         }
      };
      visitor.visitGraph(getGraph());
      return assignments;
   }

   public Map<RValue, List<Statement>> getAllUsages() {
      final HashMap<RValue, List<Statement>> usages = new HashMap<>();
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitAssignment(StatementAssignment assignment) {
            addUsage(assignment.getRValue1(), assignment);
            addUsage(assignment.getRValue2(), assignment);
            return null;
         }

         @Override
         public Void visitConditionalJump(StatementConditionalJump conditionalJump) {
            addUsage(conditionalJump.getRValue1(), conditionalJump);
            addUsage(conditionalJump.getRValue2(), conditionalJump);
            return null;
         }

         @Override
         public Void visitPhi(StatementPhi phi) {
            for (StatementPhi.PreviousSymbol previousSymbol : phi.getPreviousVersions()) {
               addUsage(previousSymbol.getRValue(), phi);
            }
            return null;
         }

         private void addUsage(RValue rValue, Statement statement) {
            if (rValue == null) {
               return;
            }
            List<Statement> use = usages.get(rValue);
            if (use == null) {
               use = new ArrayList<>();
               usages.put(rValue, use);
            }
            use.add(statement);
         }

      };
      visitor.visitGraph(getGraph());

      return usages;
   }
}
