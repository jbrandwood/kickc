package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.*;

/**
 * Optimization on Single Static Assignment form (Control Flow Graph) performed during Compiler Pass 2.
 * Optimizations are performed repeatedly until none of them yield any result
 */
public abstract class Pass2SsaOptimization {

   protected CompileLog log;
   private ControlFlowGraph graph;
   private ProgramScope scope;

   public Pass2SsaOptimization(Program program,CompileLog log) {
      this.log = log;
      this.graph = program.getGraph();
      this.scope = program.getScope();
   }

   public CompileLog getLog() {
      return log;
   }

   public ControlFlowGraph getGraph() {
      return graph;
   }

   public ProgramScope getSymbols() {
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
         return toString(null);
      }

      @Override
      public String toString(ProgramScope scope) {
         return "VOID";
      }

   };

   /**
    * Replace all usages of variables in statements with aliases.
    *
    * @param aliases Variables that have alias values.
    */
   public void replaceVariables(final Map<VariableRef, ? extends RValue> aliases) {
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitAssignment(StatementAssignment assignment) {
            LValue lValue = assignment.getlValue();
            if (getAlias(aliases, lValue) != null) {
               RValue alias = getAlias(aliases, lValue);
               if (alias instanceof LValue) {
                  assignment.setlValue((LValue) alias);
               } else {
                  throw new RuntimeException("Error replacing LValue variable " + lValue + " with " + alias);
               }
            }
            if (getAlias(aliases, assignment.getrValue1()) != null) {
               assignment.setrValue1(getAlias(aliases, assignment.getrValue1()));
            }
            if (getAlias(aliases, assignment.getrValue2()) != null) {
               assignment.setrValue2(getAlias(aliases, assignment.getrValue2()));
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
            if (getAlias(aliases, conditionalJump.getrValue1()) != null) {
               conditionalJump.setrValue1(getAlias(aliases, conditionalJump.getrValue1()));
            }
            if (getAlias(aliases, conditionalJump.getrValue2()) != null) {
               conditionalJump.setrValue2(getAlias(aliases, conditionalJump.getrValue2()));
            }
            return null;
         }

         @Override
         public Void visitReturn(StatementReturn aReturn) {
            if (getAlias(aliases, aReturn.getValue()) != null) {
               aReturn.setValue(getAlias(aliases, aReturn.getValue()));
            }
            return null;
         }

         @Override
         public Void visitCall(StatementCall call) {
            if(call.getParameters()!=null) {
               List<RValue> newParams = new ArrayList<>();
               for (RValue parameter : call.getParameters()) {
                  RValue newParam = parameter;
                  if (getAlias(aliases, parameter) != null) {
                     newParam = getAlias(aliases, parameter);
                  }
                  newParams.add(newParam);
               }
               call.setParameters(newParams);
            }
            return null;
         }

         @Override
         public Void visitPhiBlock(StatementPhiBlock phi) {
            for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
               if (getAlias(aliases, phiVariable.getVariable()) != null) {
                  RValue alias = getAlias(aliases, phiVariable.getVariable());
                  if (alias instanceof LValue) {
                     phiVariable.setVariable((VariableRef) alias);
                  }
               }
               List<StatementPhiBlock.PhiRValue> phirValues = phiVariable.getValues();
               Iterator<StatementPhiBlock.PhiRValue> it = phirValues.iterator();
               while (it.hasNext()) {
                  StatementPhiBlock.PhiRValue phirValue = it.next();
                  if (getAlias(aliases, phirValue.getrValue()) != null) {
                     RValue alias = getAlias(aliases, phirValue.getrValue());
                     if (VOID.equals(alias)) {
                        it.remove();
                     } else {
                        phirValue.setrValue(alias);
                     }
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
   private static RValue getAlias(Map<VariableRef, ? extends RValue> aliases, RValue rValue) {
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
   public void replaceLabels(ControlFlowBlock block, final Map<LabelRef, LabelRef> replacements) {
      ControlFlowGraphBaseVisitor<Void> visitor = getLabelReplaceVisitor(replacements);
      visitor.visitBlock(block);
   }

   /** Creates a visitor that can replace labels. */
   private ControlFlowGraphBaseVisitor<Void> getLabelReplaceVisitor(final Map<LabelRef, LabelRef> replacements) {
      return new ControlFlowGraphBaseVisitor<Void>() {

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
         public Void visitPhiBlock(StatementPhiBlock phi) {
            for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
               for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                  if (getReplacement(replacements, phiRValue.getPredecessor()) != null) {
                     phiRValue.setPredecessor(getReplacement(replacements, phiRValue.getPredecessor()));
                  }
               }
            }
            return null;
         }
      };
   }

   /**
    * Get the label to use as replacement for another label.
    *
    * @param replacements The label replacement map
    * @param label        The label to find a replacement for
    * @return The alias to use. Null if no replacement exists.
    */
   private static LabelRef getReplacement(Map<LabelRef, LabelRef> replacements, LabelRef label) {
      LabelRef replacement = replacements.get(label);
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
               if (variables.contains(assignment.getlValue())) {
                  iterator.remove();
               }
            } else if (statement instanceof StatementPhiBlock) {
               StatementPhiBlock phiBlock = (StatementPhiBlock) statement;
               Iterator<StatementPhiBlock.PhiVariable> variableIterator = phiBlock.getPhiVariables().iterator();
               while (variableIterator.hasNext()) {
                  StatementPhiBlock.PhiVariable phiVariable = variableIterator.next();
                  if(variables.contains(phiVariable.getVariable())) {
                     variableIterator.remove();
                  }
               }
               if(phiBlock.getPhiVariables().size()==0) {
                  iterator.remove();
               }
            }
         }
      }
   }

   /**
    * Remove symbols from the symbol table
    *
    * @param symbols The symbols to remove
    */
   public void deleteSymbols(Collection<? extends Symbol> symbols) {
      for (Symbol symbol : symbols) {
         symbol.getScope().remove(symbol);
      }
   }

   public void deleteVariables(Collection<? extends VariableRef> symbols) {
      for (VariableRef variableRef : symbols) {
         Symbol symbol = getSymbols().getSymbol(variableRef.getFullName());
         symbol.getScope().remove(symbol);
      }
   }

   public Map<LValue, StatementAssignment> getAllAssignments() {
      final HashMap<LValue, StatementAssignment> assignments = new LinkedHashMap<>();
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitAssignment(StatementAssignment assignment) {
            assignments.put(assignment.getlValue(), assignment);
            return null;
         }
      };
      visitor.visitGraph(getGraph());
      return assignments;
   }

   public Map<RValue, List<Statement>> getAllUsages() {
      final HashMap<RValue, List<Statement>> usages = new LinkedHashMap<>();
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitAssignment(StatementAssignment assignment) {
            addUsage(assignment.getrValue1(), assignment);
            addUsage(assignment.getrValue2(), assignment);
            return null;
         }

         @Override
         public Void visitConditionalJump(StatementConditionalJump conditionalJump) {
            addUsage(conditionalJump.getrValue1(), conditionalJump);
            addUsage(conditionalJump.getrValue2(), conditionalJump);
            return null;
         }

         @Override
         public Void visitPhiBlock(StatementPhiBlock phi) {
            for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
               for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                  addUsage(phiRValue.getrValue(), phi);
               }
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

   protected Map<VariableRef, Integer> countVarUsages() {
      final HashMap<VariableRef, Integer> usages = new LinkedHashMap<>();
      ControlFlowGraphBaseVisitor usageVisitor = new ControlFlowGraphBaseVisitor() {
         private void addUsage(RValue rVal) {
            if(rVal instanceof VariableRef) {
               VariableRef var = (VariableRef) rVal;
               Integer usage = usages.get(var);
               if (usage == null) {
                  usage = 0;
               }
               usage = usage + 1;
               usages.put(var, usage);
            } else if(rVal instanceof PointerDereference) {
               throw new RuntimeException("Unexpected pointer dereference!");
            }
         }


         @Override
         public Object visitAssignment(StatementAssignment assignment) {
            addUsage(assignment.getrValue1());
            addUsage(assignment.getrValue2());
            return null;
         }

         @Override
         public Object visitReturn(StatementReturn aReturn) {
            addUsage(aReturn.getValue());
            return null;
         }

         @Override
         public Object visitCall(StatementCall call) {
            if(call.getParameters()!=null) {
               for (RValue param : call.getParameters()) {
                  addUsage(param);
               }
            }
            return null;
         }

         @Override
         public Void visitPhiBlock(StatementPhiBlock phi) {
            for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
               for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                  addUsage(phiRValue.getrValue());
               }
            }
            return null;
         }

      };
      usageVisitor.visitGraph(getGraph());
      return usages;
   }
}
