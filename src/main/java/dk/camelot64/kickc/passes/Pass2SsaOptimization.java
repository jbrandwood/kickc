package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.passes.utils.AliasReplacer;

import java.util.*;

/**
 * Optimization on Single Static Assignment form (Control Flow Graph) performed during Compiler Pass 2.
 * Optimizations are performed repeatedly until none of them yield any result
 */
public abstract class Pass2SsaOptimization extends Pass1Base implements PassStep {

   public Pass2SsaOptimization(Program program) {
      super(program);
   }

   /**
    * Get the label to use as replacement for another label.
    *
    * @param replacements The label replacement map
    * @param label The label to find a replacement for
    * @return The alias to use. Null if no replacement exists.
    */
   private static LabelRef getReplacement(Map<LabelRef, LabelRef> replacements, LabelRef label) {
      LabelRef replacement = replacements.get(label);
      while(replacements.get(replacement) != null) {
         replacement = replacements.get(replacement);
      }
      return replacement;
   }

   /**
    * Attempt to perform optimization.
    *
    * @return true if an optimization was performed. false if no optimization was possible.
    */
   public abstract boolean step();

   /**
    * Replace all usages of variables in statements (or symbol table) with aliases.
    *
    * @param aliases Variables that have alias values.
    */
   public void replaceVariables(final Map<? extends SymbolRef, ? extends RValue> aliases) {
      ProgramValueIterator.execute(getProgram(), new AliasReplacer(aliases));
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
            if(getReplacement(replacements, conditionalJump.getDestination()) != null) {
               conditionalJump.setDestination(getReplacement(replacements, conditionalJump.getDestination()));
            }
            return null;
         }

         @Override
         public Void visitJump(StatementJump jump) {
            if(getReplacement(replacements, jump.getDestination()) != null) {
               jump.setDestination(getReplacement(replacements, jump.getDestination()));
            }
            return null;
         }

         @Override
         public Void visitPhiBlock(StatementPhiBlock phi) {
            for(StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
               for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                  if(getReplacement(replacements, phiRValue.getPredecessor()) != null) {
                     phiRValue.setPredecessor(getReplacement(replacements, phiRValue.getPredecessor()));
                  }
               }
            }
            return null;
         }
      };
   }

   /**
    * Remove all assignments to specific LValues from the control flow graph (as they are no longer needed).
    *
    * @param variables The variables to eliminate
    */
   public static void removeAssignments(ControlFlowGraph graph, Collection<? extends LValue> variables) {
      for(ControlFlowBlock block : graph.getAllBlocks()) {
         for(Iterator<Statement> iterator = block.getStatements().iterator(); iterator.hasNext(); ) {
            Statement statement = iterator.next();
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(variables.contains(assignment.getlValue())) {
                  iterator.remove();
               }
            } else if(statement instanceof StatementPhiBlock) {
               StatementPhiBlock phiBlock = (StatementPhiBlock) statement;
               phiBlock.getPhiVariables().removeIf(phiVariable -> variables.contains(phiVariable.getVariable()));
               if(phiBlock.getPhiVariables().size() == 0) {
                  iterator.remove();
               }
            }
         }
      }
   }

   public static void deleteSymbols(ProgramScope programScope, Collection<? extends SymbolRef> symbols) {
      for(SymbolRef symbolRef : symbols) {
         Symbol symbol = programScope.getSymbol(symbolRef);
         symbol.getScope().remove(symbol);
      }
   }


}
