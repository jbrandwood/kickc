package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.Stack;

/**
 * Replaces all LValueLoHi with a separate assignment to the modified variable.
 * <br>Example: <code>&lt;plotter = x &amp; 8 </code>
 * <br>Becomes: <code> $1 =x &amp; 8 ,  plotter = plotter lo= $1 </code>
 */
public class Pass1FixLvalueLoHi extends Pass1Base {

   public Pass1FixLvalueLoHi(Program program) {
      super(program);
   }

   @Override
   boolean executeStep() {
      Stack<Scope> scopeStack = new Stack<>();
      scopeStack.push(getScope());
      StatementSequence fixedSequence = new StatementSequence();
      for (Statement statement : getProgram().getStatementSequence().getStatements()) {
         if (statement instanceof StatementAssignment) {
            StatementAssignment assignment = (StatementAssignment) statement;
            if (assignment.getlValue() instanceof LvalueLoHiByte) {
               LvalueLoHiByte loHiByte = (LvalueLoHiByte) assignment.getlValue();
               if (assignment.getOperator() != null || assignment.getrValue1()!=null) {
                  Scope currentScope = scopeStack.peek();
                  VariableIntermediate tmpVar = currentScope.addVariableIntermediate();
                  VariableRef tmpVarRef = tmpVar.getRef();
                  Statement tmpAssignment = new StatementAssignment(tmpVarRef, assignment.getrValue1(), assignment.getOperator(), assignment.getrValue2());
                  fixedSequence.addStatement(tmpAssignment);
                  Statement setLoHiAssignment = new StatementAssignment(loHiByte.getVariable(), loHiByte.getVariable(), loHiByte.getOperator(), tmpVarRef);
                  fixedSequence.addStatement(setLoHiAssignment);
                  getLog().append("Fixing lo/hi-lvalue with new tmpVar " + tmpVarRef + " " + assignment.toString());
               } else {
                  Statement setLoHiAssignment = new StatementAssignment(loHiByte.getVariable(), loHiByte.getVariable(), loHiByte.getOperator(), assignment.getrValue2());
                  fixedSequence.addStatement(setLoHiAssignment);
                  getLog().append("Fixing lo/hi-lvalue " + assignment.toString());
               }
            } else {
               fixedSequence.addStatement(statement);
            }
         } else {
            fixedSequence.addStatement(statement);
         }
         if (statement instanceof StatementProcedureBegin) {
            ProcedureRef procedureRef = ((StatementProcedureBegin) statement).getProcedure();
            Procedure procedure = getScope().getProcedure(procedureRef);
            scopeStack.push(procedure);
         } else if (statement instanceof StatementProcedureEnd) {
            scopeStack.pop();
         }
      }
      getProgram().setStatementSequence(fixedSequence);
      return false;
   }

}
