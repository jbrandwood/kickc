package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
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
      for(Graph.Block block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
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
}
