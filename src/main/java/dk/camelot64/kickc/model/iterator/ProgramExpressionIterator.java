package dk.camelot64.kickc.model.iterator;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.values.ConstantBinary;
import dk.camelot64.kickc.model.values.ConstantUnary;

import java.util.ListIterator;

/**
 * Capable of iterating the different structures of a Program (graph, block, statement, symboltable, symbol).
 * Creates appropriate BinaryExpressions and passes them to a ProgramExpressionHandler.
 * Iteration might be guided (eg. filtering some types of the structure to iterate at call-time)
 */
public class ProgramExpressionIterator {

   /**
    * Execute a handler on all values in the entire program (both in the control flow graph and the symbol table.)
    *
    * @param program The program
    * @param handler The handler to execute
    */
   public static void execute(Program program, ProgramExpressionHandler handler) {
      // Iterate all symbols
      ProgramValueIterator.execute(program.getScope(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof ConstantBinary) {
            handler.execute(new ProgramExpressionBinary.ProgramExpressionBinaryConstant(programValue), null, null, null);
         } else if(programValue.get() instanceof ConstantUnary) {
            handler.execute(new ProgramExpressionUnary.ProgramExpressionUnaryConstant(programValue), null, null, null);
         }
      });

      // Iterate all blocks/statements
      for(ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement stmt = stmtIt.next();
            if(stmt instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) stmt;
               if(assignment.getrValue1() != null && assignment.getOperator() != null && assignment.getrValue2() != null) {
                  handler.execute(new ProgramExpressionBinary.ProgramExpressionBinaryAssignmentRValue(assignment), stmt, stmtIt, block);
               } else if(assignment.getrValue1() == null && assignment.getOperator() != null && assignment.getrValue2() != null) {
                  handler.execute(new ProgramExpressionUnary.ProgramExpressionUnaryAssignmentRValue(assignment), stmt, stmtIt, block);
               }
               handler.execute(new ProgramExpressionBinary.ProgramExpressionBinaryAssignmentLValue(assignment), stmt, stmtIt, block);
            } else if(stmt instanceof StatementConditionalJump) {
               StatementConditionalJump condJump = (StatementConditionalJump) stmt;
               if(condJump.getrValue1() != null && condJump.getOperator() != null && condJump.getrValue2() != null) {
                  handler.execute(new ProgramExpressionBinary.ProgramExpressionBinaryConditionalJump(condJump), stmt, stmtIt, block);
               }
            }
            // Iterate all statement values
            ProgramValueIterator.execute(stmt, (programValue, currentStmt, stmtIt1, currentBlock) -> {
               if(programValue.get() instanceof ConstantBinary) {
                  handler.execute(new ProgramExpressionBinary.ProgramExpressionBinaryConstant(programValue), stmt, stmtIt, block);
               } else if(programValue.get() instanceof ConstantUnary) {
                  handler.execute(new ProgramExpressionUnary.ProgramExpressionUnaryConstant(programValue), stmt, stmtIt, block);
               }

            }, stmtIt, block);
         }
      }

   }

}
