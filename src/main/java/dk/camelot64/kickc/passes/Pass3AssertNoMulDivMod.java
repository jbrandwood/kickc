package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.StatementAssignment;

/**
 * Assert that no the code has no multiply/divide/modulo operators left.
 */
public class Pass3AssertNoMulDivMod extends Pass2SsaAssertion {

   public Pass3AssertNoMulDivMod(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      for(var statement : getGraph().getAllStatements()) {
         if(statement instanceof StatementAssignment assignment) {
            if(Operators.MULTIPLY.equals(assignment.getOperator())) {
               throw new CompileError("Runtime multiplication not supported. "+statement.toString(getProgram(), false), statement.getSource());
            }
            if(Operators.DIVIDE.equals(assignment.getOperator())) {
               throw new CompileError("Runtime division not supported. "+statement.toString(getProgram(), false), statement.getSource());
            }
            if(Operators.MODULO.equals(assignment.getOperator())) {
               throw new CompileError("Runtime modulo not supported. "+statement.toString(getProgram(), false), statement.getSource());
            }
         }
      }

   }
}
