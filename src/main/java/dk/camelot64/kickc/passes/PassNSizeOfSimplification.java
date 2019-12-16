package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.OperatorSizeOf;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.*;

import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Simplifies sizeof() operators whenever the expression is constant
 */
public class PassNSizeOfSimplification extends Pass2SsaOptimization {

   public PassNSizeOfSimplification(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);

      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(Operators.SIZEOF.equals(assignment.getOperator())) {
                  if(assignment.getrValue2() instanceof SymbolVariableRef) {
                     SymbolVariableRef symbolRef = (SymbolVariableRef) assignment.getrValue2();
                     Variable symbolVar = (Variable) getScope().getSymbol(symbolRef);
                     SymbolType symbolType = symbolVar.getType();
                     if(!(symbolVar.isArray())) {
                        getLog().append("Resolving sizeof() " + assignment.toString(getProgram(), false));
                        ConstantRef sizeOfConstantVar = OperatorSizeOf.getSizeOfConstantVar(getScope(), symbolType);
                        assignment.setrValue2(sizeOfConstantVar);
                        assignment.setOperator(null);
                        modified.set(true);
                     }
                  }
               }
            }
         }
      }

      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
               if(programValue.get() instanceof ConstantUnary) {
                  ConstantUnary unary = (ConstantUnary) programValue.get();
                  if(unary.getOperator().equals(Operators.SIZEOF)) {
                     ConstantValue operand = unary.getOperand();
                     resolveConstantSizeOf(modified, programValue, unary, operand);
                  }
               }
            }
      );

      return modified.get();
   }

   public void resolveConstantSizeOf(AtomicBoolean modified, ProgramValue programValue, ConstantUnary unary, ConstantValue operand) {
      if(operand instanceof ConstantRef) {
         Variable constant = getScope().getConstant((ConstantRef) operand);
         SymbolType symbolType = constant.getType();
         if(constant.isArray() && symbolType instanceof SymbolTypePointer) {
            SymbolTypePointer arrayType = (SymbolTypePointer) symbolType;
            ConstantValue arraySize = constant.getArraySize();
            if(arraySize!=null) {
               getLog().append("Resolving array sizeof() " + unary.toString(getProgram()));
               ConstantRef sizeOfConstantVar = OperatorSizeOf.getSizeOfConstantVar(getScope(), arrayType.getElementType());
               programValue.set(new ConstantBinary((ConstantValue) arraySize, Operators.MULTIPLY, sizeOfConstantVar));
               modified.set(true);
            } else if(constant.getInitValue() instanceof ConstantArrayList) {
               getLog().append("Resolving array sizeof() " + unary.toString(getProgram()));
               int size = ((ConstantArrayList) constant.getInitValue()).getElements().size();
               ConstantRef sizeOfConstantVar = OperatorSizeOf.getSizeOfConstantVar(getScope(), arrayType.getElementType());
               programValue.set(new ConstantBinary(new ConstantInteger((long) size), Operators.MULTIPLY, sizeOfConstantVar));
               modified.set(true);
            } else {
               // Try to calculate the literal to check if it is a string
               ConstantLiteral stringLiteral = null;
               try {
                  stringLiteral = constant.getInitValue().calculateLiteral(getProgram().getScope());
               } catch(ConstantNotLiteral e) {
                  // Ignore
               }
               if(stringLiteral instanceof ConstantString) {
                  ConstantString constString = (ConstantString) stringLiteral;
                  int length = constString.getStringLength();
                  getLog().append("Resolving string sizeof() " + unary.toString(getProgram()));
                  ConstantRef sizeOfChar = OperatorSizeOf.getSizeOfConstantVar(getScope(), SymbolType.BYTE);
                  programValue.set(new ConstantBinary(new ConstantInteger((long) length), Operators.MULTIPLY, sizeOfChar));
                  modified.set(true);
               } else {
                  throw new CompileError("Not implemented!");
               }
            }
         } else if(symbolType instanceof SymbolTypePointer ){
            getLog().append("Resolving sizeof() " + unary.toString(getProgram()));
            ConstantRef sizeOfConstantVar = OperatorSizeOf.getSizeOfConstantVar(getScope(), symbolType);
            programValue.set(sizeOfConstantVar);
            modified.set(true);
         } else {
            getLog().append("Resolving sizeof() " + unary.toString(getProgram()));
            ConstantLiteral literal = operand.calculateLiteral(getProgram().getScope());
            SymbolType constType = literal.getType(getProgram().getScope());
            ConstantRef sizeOfConstantVar = OperatorSizeOf.getSizeOfConstantVar(getScope(), constType);
            programValue.set(sizeOfConstantVar);
            modified.set(true);
         }
      } else {
         getLog().append("Resolving sizeof() " + unary.toString(getProgram()));
         ConstantLiteral literal = operand.calculateLiteral(getProgram().getScope());
         SymbolType constType = literal.getType(getProgram().getScope());
         ConstantRef sizeOfConstantVar = OperatorSizeOf.getSizeOfConstantVar(getScope(), constType);
         programValue.set(sizeOfConstantVar);
         modified.set(true);
      }
   }

}
