package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.iterator.ProgramExpressionUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.VariableIntermediate;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.ConstantBinary;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.RValue;

import java.util.ListIterator;

/**
 * Add a cast to boolean everywhere an integer/pointer is used where a boolean is expected.
 */
public class PassNAddBooleanCasts extends Pass2SsaOptimization {

   public PassNAddBooleanCasts(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock currentBlock : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = currentBlock.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement currentStmt = stmtIt.next();
            if(currentStmt instanceof StatementConditionalJump) {
               StatementConditionalJump conditionalJump = (StatementConditionalJump) currentStmt;
               if(conditionalJump.getOperator()==null) {
                  RValue rValue2 = conditionalJump.getrValue2();
                  SymbolType type = SymbolTypeInference.inferType(getScope(), rValue2);
                  if(SymbolType.isInteger(type) || type instanceof SymbolTypePointer) {
                     // Found integer condition - add boolean cast
                     getLog().append("Warning! Adding boolean cast to non-boolean condition "+rValue2.toString(getProgram()));
                     VariableIntermediate tmpVar = addBooleanCast(rValue2, currentStmt, stmtIt, currentBlock);
                     conditionalJump.setrValue2(tmpVar.getRef());
                  }
               }
            }
         }
      }
      ProgramExpressionIterator.execute(getProgram(), (programExpression, currentStmt, stmtIt, currentBlock) -> {
         if(Operators.LOGIC_NOT.equals(programExpression.getOperator())) {
            ProgramExpressionUnary unaryExpression = (ProgramExpressionUnary) programExpression;
            RValue operand = unaryExpression.getOperand();
            SymbolType operandType = SymbolTypeInference.inferType(getScope(), operand);
            if(SymbolType.isInteger(operandType) || operandType instanceof SymbolTypePointer) {
               getLog().append("Warning! Adding boolean cast to non-boolean sub-expression "+operand.toString(getProgram()));
               if(operand instanceof ConstantValue) {
                  unaryExpression.setOperand(new ConstantBinary(new ConstantInteger(0L, SymbolType.NUMBER), Operators.NEQ, (ConstantValue) operand));
               }  else {
                  VariableIntermediate tmpVar = addBooleanCast(operand, currentStmt, stmtIt, currentBlock);
                  unaryExpression.setOperand(tmpVar.getRef());
               }
            }
         }
      });
      return false;
   }

   public VariableIntermediate addBooleanCast(RValue rValue, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      Scope currentScope = getScope().getScope(currentBlock.getScope());
      stmtIt.previous();
      VariableIntermediate tmpVar = currentScope.addVariableIntermediate();
      tmpVar.setTypeInferred(SymbolType.BOOLEAN);
      // Go straight to xxx!=0 instead of casting to bool
      stmtIt.add(new StatementAssignment(tmpVar.getRef(), new ConstantInteger(0L, SymbolType.NUMBER), Operators.NEQ, rValue, currentStmt.getSource(), Comment.NO_COMMENTS));
      stmtIt.next();
      return tmpVar;
   }


}
