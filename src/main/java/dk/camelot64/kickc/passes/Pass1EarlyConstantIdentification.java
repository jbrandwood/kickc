package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.OperatorCastPtr;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.SymbolVariableRef;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/** Identify any variable that are clearly constant. */
public class Pass1EarlyConstantIdentification extends Pass1Base {

   public Pass1EarlyConstantIdentification(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      Collection<SymbolVariableRef> earlyConstants = new ArrayList<>();
      for(Variable variable : getProgram().getScope().getAllVariables(true)) {
         SymbolVariableRef variableRef = variable.getRef();
         if(!variable.isDeclaredConst() && !variable.isVolatile() && !variableRef.isIntermediate()) {
            if(variable.isDeclaredNotConst())
               // Skip explicit non-constants
               continue;
            if(!isParameter(variableRef)) {
               Collection<StatementLValue> assignments = getAssignments(variable);
               if(assignments.size() == 1) {
                  StatementLValue assignment = assignments.iterator().next();
                  if(assignment instanceof StatementAssignment) {
                     StatementAssignment assign = (StatementAssignment) assignment;
                     if(assign.getrValue1() == null && assign.getOperator() == null && assign.getrValue2() instanceof ConstantValue) {
                        getLog().append("Identified constant variable " + variable.toString(getProgram()));
                        earlyConstants.add(variableRef);
                        variable.setKind(Variable.Kind.CONSTANT);
                     } else if(assign.getrValue1() == null && assign.getOperator() instanceof OperatorCastPtr && assign.getrValue2() instanceof ConstantValue) {
                        getLog().append("Identified constant variable " + variable.toString(getProgram()));
                        earlyConstants.add(variableRef);
                        variable.setKind(Variable.Kind.CONSTANT);
                     }
                  }
               }
            }
         }
      }
      getProgram().setEarlyIdentifiedConstants(earlyConstants);
      return false;
   }

   /**
    * Examines whether a variable is a procedure parameter
    *
    * @param variableRef The variable
    * @return true if the variable is a procedure parameter
    */
   public boolean isParameter(SymbolVariableRef variableRef) {
      Variable var = getScope().getVariable(variableRef);
      Scope varScope = var.getScope();
      if(varScope instanceof Procedure) {
         List<Variable> parameters = ((Procedure) varScope).getParameters();
         if(parameters.contains(var))
            return true;

      }
      return false;
   }

   /**
    * Find all assignments of a variable.
    *
    * @param variable The variable
    * @return all assignments
    */
   private Collection<StatementLValue> getAssignments(Variable variable) {
      Collection<StatementLValue> assignments = new ArrayList<>();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               StatementLValue assignment = (StatementLValue) statement;
               if(variable.getRef().equals(assignment.getlValue())) {
                  assignments.add(assignment);
               }
            }
         }
      }
      return assignments;
   }
}
