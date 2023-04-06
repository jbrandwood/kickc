package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.VariableBuilder;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.iterator.ProgramExpressionUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.*;

import java.util.ListIterator;

/**
 * Add a cast to boolean everywhere an integer/pointer is used where a boolean is expected.
 */
public class PassNAddBooleanCasts extends Pass2SsaOptimization {

   private boolean pass1;

   public PassNAddBooleanCasts(Program program, boolean pass1) {
      super(program);
      this.pass1 = pass1;
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock currentBlock : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = currentBlock.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement currentStmt = stmtIt.next();
            if(currentStmt instanceof StatementConditionalJump) {
               StatementConditionalJump conditionalJump = (StatementConditionalJump) currentStmt;
               if(conditionalJump.getOperator() == null) {
                  RValue rValue2 = conditionalJump.getrValue2();
                  SymbolType type = SymbolTypeInference.inferType(getProgramScope(), rValue2);
                  if(SymbolType.isInteger(type) || type instanceof SymbolTypePointer) {
                     // Found integer condition - add boolean cast
                     if(!pass1)
                        getLog().append("Warning! Adding boolean cast to non-boolean condition " + rValue2.toString(getProgram()));
                     Variable tmpVar = addBooleanCast(rValue2, type, currentStmt, stmtIt, currentBlock);
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
            SymbolType operandType = SymbolTypeInference.inferType(getProgramScope(), operand);
            if(SymbolType.isInteger(operandType) || operandType instanceof SymbolTypePointer) {
               if(!pass1)
                  getLog().append("Warning! Adding boolean cast to non-boolean sub-expression " + operand.toString(getProgram()));
               if(operand instanceof ConstantValue) {
                  unaryExpression.setOperand(new ConstantBinary(new ConstantInteger(0L, SymbolType.NUMBER), Operators.NEQ, (ConstantValue) operand));
               } else {
                  SymbolType type = SymbolTypeInference.inferType(getProgramScope(), operand);
                  Variable tmpVar = addBooleanCast(operand, type, currentStmt, stmtIt, currentBlock);
                  unaryExpression.setOperand(tmpVar.getRef());
               }
            }
         }
      });
      return false;
   }

   private Variable addBooleanCast(RValue rValue, SymbolType rValueType, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      Scope currentScope = getProgramScope().getScope(currentBlock.getScope());
      stmtIt.previous();
      Variable tmpVar = VariableBuilder.createIntermediate(currentScope, SymbolType.BOOLEAN, getProgram());
      // Go straight to xxx!=0 instead of casting to bool
      ConstantValue nullValue;
      if(rValueType instanceof SymbolTypePointer) {
         nullValue = new ConstantCastValue(rValueType, new ConstantInteger(0L, SymbolType.WORD));
      } else {
         nullValue = new ConstantInteger(0L, SymbolType.NUMBER);
      }
      stmtIt.add(new StatementAssignment((LValue) tmpVar.getRef(), nullValue, Operators.NEQ, rValue, true, currentStmt.getSource(), Comment.NO_COMMENTS));
      stmtIt.next();
      return tmpVar;
   }


}
