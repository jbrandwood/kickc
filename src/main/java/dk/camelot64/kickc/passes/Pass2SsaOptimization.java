package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.model.*;

import java.util.*;

/**
 * Optimization on Single Static Assignment form (Control Flow Graph) performed during Compiler Pass 2.
 * Optimizations are performed repeatedly until none of them yield any result
 */
public abstract class Pass2SsaOptimization {

   private Program program;

   public Pass2SsaOptimization(Program program) {
      this.program = program;
   }

   public CompileLog getLog() {
      return program.getLog();
   }

   public ControlFlowGraph getGraph() {
      return program.getGraph();
   }

   public ProgramScope getSymbols() {
      return program.getScope();
   }

   public Program getProgram() {
      return program;
   }

   /**
    * Attempt to perform optimization.
    *
    * @return true if an optimization was performed. false if no optimization was possible.
    */
   public abstract boolean optimize();


   /**
    * Replace all usages of variables in statements with aliases.
    *
    * @param aliases Variables that have alias values.
    */
   public void replaceVariables(final Map<? extends SymbolRef, ? extends RValue> aliases) {
      VariableReplacer replacer = new VariableReplacer(aliases);
      replacer.getReplacement(getGraph());
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

   /** Creates a visitor that can getReplacement labels. */
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
      for (ControlFlowBlock block : getGraph().getAllBlocks()) {
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

   public void deleteSymbols(Collection<? extends SymbolRef> symbols) {
      for (SymbolRef symbolRef : symbols) {
         Symbol symbol = getSymbols().getSymbol(symbolRef.getFullName());
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
               Value pointer = ((PointerDereference) rVal).getPointer();
               if(pointer instanceof RValue) {
                  addUsage((RValue) pointer);
               }
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
