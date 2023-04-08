package dk.camelot64.kickc.passes.utils;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.ControlFlowGraph;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.SymbolVariableRef;

import java.util.ArrayList;
import java.util.List;

/**
 * Utility for finding all assignments for a variable.
 */
public class VarAssignments {

   /**
    * Get all assignments of value to a variable.
    *
    * @param variable The variable to find the assignment for
    * @return All assignments of values to the variable
    */
   public static List<VarAssignment> get(SymbolVariableRef variable, Graph graph, ProgramScope programScope) {
      ArrayList<VarAssignment> varAssignments = new ArrayList<>();
      Variable varDef = programScope.getVariable(variable);
      if(varDef.getInitValue() != null) {
         varAssignments.add(new VarAssignment(VarAssignment.Type.INIT_VALUE, null, null, null, null, varDef));
      }
      for(var block : graph.getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               StatementLValue assignment = (StatementLValue) statement;
               if(variable.equals(assignment.getlValue())) {
                  varAssignments.add(new VarAssignment(VarAssignment.Type.STATEMENT_LVALUE, block, assignment, null, null, null));
               }
            } else if(statement instanceof StatementPhiBlock) {
               for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                  if(phiVariable.getVariable().equals(variable)) {
                     varAssignments.add(new VarAssignment(VarAssignment.Type.STATEMENT_PHI, block, null, (StatementPhiBlock) statement, phiVariable, null));
                  }
               }
            }
         }
      }
      return varAssignments;
   }

   /**
    * Any assignment of a value to a SymbolVariable.
    * Potential assignments include StatementLValue, StatementPhi and Variable.initValue
    */
   public static class VarAssignment {

      public enum Type {
         STATEMENT_LVALUE,
         STATEMENT_PHI,
         INIT_VALUE
      }

      /** The type of assignment. */
      public final Type type;

      /** The block  containing the assignment statement. Null if type is not STATEMENT_LVALUE or STATEMENT_PHI */
      public final Graph.Block block;

      /* The LValue-statement. Null if type is not STATEMENT_LVALUE. */
      public final StatementLValue statementLValue;

      /* The PHI-statement. Null if type is not STATEMENT_PHI. */
      public final StatementPhiBlock statementPhi;
      public final StatementPhiBlock.PhiVariable statementPhiVariable;

      /* The Variable with initValue. Null if type is not INIT_VALUE. */
      public final Variable variableInitValue;

      public VarAssignment(Type type, Graph.Block block, StatementLValue statementLValue, StatementPhiBlock statementPhi, StatementPhiBlock.PhiVariable statementPhiVariable, Variable variableInitValue) {
         this.type = type;
         this.block = block;
         this.statementLValue = statementLValue;
         this.statementPhi = statementPhi;
         this.statementPhiVariable = statementPhiVariable;
         this.variableInitValue = variableInitValue;
      }

      @Override
      public String toString() {
         StringBuilder s = new StringBuilder();
         if(block != null)
            s.append(block.getLabel()).append("::");
         if(statementLValue != null)
            s.append(statementLValue.toString());
         if(statementPhi != null)
            s.append(statementPhi.toString()).append(" ");
         if(statementPhiVariable != null)
            s.append(statementPhiVariable.toString());
         if(variableInitValue != null)
            s.append(variableInitValue.toString());
         return s.toString();
      }

      public StatementSource getSource() {
         if(statementLValue != null)
            return statementLValue.getSource();
         if(statementPhi != null)
            return statementPhi.getSource();
         return null;
      }

   }
}
