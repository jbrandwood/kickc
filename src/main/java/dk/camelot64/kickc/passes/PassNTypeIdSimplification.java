package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.iterator.ProgramExpressionUnary;
import dk.camelot64.kickc.model.operators.OperatorTypeId;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.ConstantRef;
import dk.camelot64.kickc.model.values.RValue;

import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Converts typeid() operators to constants
 */
public class PassNTypeIdSimplification extends Pass2SsaOptimization {

   public PassNTypeIdSimplification(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);
      ProgramExpressionIterator.execute(getProgram(), (programExpression, currentStmt, stmtIt, currentBlock) -> {
         if(programExpression instanceof ProgramExpressionUnary) {
            ProgramExpressionUnary unary = (ProgramExpressionUnary) programExpression;
            if(Operators.TYPEID.equals(unary.getOperator())) {
               RValue rValue = unary.getOperand();
               SymbolType symbolType = SymbolTypeInference.inferType(getScope(), rValue);
               if(SymbolType.VAR.equals(symbolType) || SymbolType.NUMBER.equals(symbolType)) {

               }  else {
                  getLog().append("Resolving typeid() " + currentStmt.toString(getProgram(), false));
                  ConstantRef typeIDConstantVar = OperatorTypeId.getTypeIdConstantVar(getScope(), symbolType);
                  unary.set(typeIDConstantVar);
                  modified.set(true);
               }
            }
         }
      });

      /*
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(Operators.TYPEID.equals(assignment.getOperator())) {
                  RValue rValue = assignment.getrValue2();
                  SymbolType symbolType = SymbolTypeInference.inferType(getSymbols(), rValue);
                  if(SymbolType.NUMBER.equals(symbolType)) {
                     if(rValue instanceof ConstantValue) {
                        List<SymbolTypeIntegerFixed> fixedTypes = SymbolTypeNumberInference.inferTypes(getSymbols(), (ConstantLiteral) rValue);
                        throw new InternalError("TODO: Implement typeof(const)!");
                     }
                  } else {
                     getLog().append("Resolving typeid() " + assignment.toString(getProgram(), false));
                     ConstantRef typeIDConstantVar = OperatorTypeId.getTypeIdConstantVar(getSymbols(), symbolType);
                     assignment.setrValue2(typeIDConstantVar);
                     assignment.setOperator(null);
                     modified = true;
                  }
               }
            }
         }
      }
      */
      return modified.get();
   }
}
