package dk.camelot64.kickc.icl;

import java.util.Collection;
import java.util.Iterator;
import java.util.Map;

/** Helper functions for creating compiler passes */
public class PassHelper {

   /**
    * Replace all usages of variables in statements with aliases.
    * @param aliases Variables that have alias values.
    */
   public static void replace(ControlFlowGraph graph, final Map<Variable, ? extends RValue> aliases) {
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor() {
         @Override
         public Object visitAssignment(StatementAssignment assignment) {
            if(getAlias(aliases, assignment.getLValue()) !=null) {
               RValue alias = getAlias(aliases, assignment.getLValue());
               if(alias instanceof LValue) {
                  assignment.setLValue((LValue) alias);
               }
            }
            if(getAlias(aliases, assignment.getRValue1())!=null) {
               assignment.setRValue1(getAlias(aliases, assignment.getRValue1()));
            }
            if(getAlias(aliases, assignment.getRValue2())!=null) {
               assignment.setRValue2(getAlias(aliases, assignment.getRValue2()));
            }
            return null;
         }

         @Override
         public Object visitConditionalJump(StatementConditionalJump conditionalJump) {
            if(getAlias(aliases, conditionalJump.getCondition())!=null) {
               conditionalJump.setCondition(getAlias(aliases, conditionalJump.getCondition()));
            }
            return null;
         }

         @Override
         public Object visitPhi(StatementPhi phi) {
            if(getAlias(aliases, phi.getLValue())!=null) {
               RValue alias = getAlias(aliases, phi.getLValue());
               if(alias instanceof LValue) {
                  phi.setLValue((Variable) alias);
               }
            }
            for (StatementPhi.PreviousSymbol previousSymbol : phi.getPreviousVersions()) {
               if(getAlias(aliases, previousSymbol.getRValue())!=null) {
                  previousSymbol.setRValue(getAlias(aliases, previousSymbol.getRValue()));
               }
            }
            return null;
         }
      };
      visitor.visitGraph(graph);
   }

   /** Get the alias to use for an RValue.
    *
    * @param aliases The alias map
    * @param rValue The RValue to find an alias for
    * @return The alias to use. Null if no alias exists.
    */
   private static RValue getAlias(Map<Variable, ? extends RValue> aliases,RValue rValue) {
      RValue alias = aliases.get(rValue);
      while (aliases.get(alias)!=null) {
         alias = aliases.get(alias);
      }
      return alias;
   }

   /**
    * Remove all assignments to specific LValues from the control frlo graph (as they are no longer needed).
    * @param graph The control flow graph
    * @param symbolTable The symbol table
    * @param variables The variables to eliminate
    */
   public static void removeAssignments(ControlFlowGraph graph, SymbolTable symbolTable, Collection<? extends LValue> variables) {
      for (ControlFlowBlock block : graph.getAllBlocks()) {
         for (Iterator<Statement> iterator = block.getStatements().iterator(); iterator.hasNext(); ) {
            Statement statement = iterator.next();
            if (statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if (variables.contains(assignment.getLValue())) {
                  iterator.remove();
                  symbolTable.remove((Symbol) assignment.getLValue());
               }
            } else if(statement instanceof StatementPhi) {
               StatementPhi phi = (StatementPhi) statement;
               if (variables.contains(phi.getLValue())) {
                  iterator.remove();
                  symbolTable.remove(phi.getLValue());
               }
            }
         }
      }
   }


}
