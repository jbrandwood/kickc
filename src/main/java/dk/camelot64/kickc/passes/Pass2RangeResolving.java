package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeIntegerFixed;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.*;

/**
 * Compiler Pass identifying constant {@link dk.camelot64.kickc.model.values.RangeValue}s and replacing them with proper constants
 * This is part of making ranged for( byte b: A..B ) work.
 */
public class Pass2RangeResolving extends Pass2SsaOptimization {

   public Pass2RangeResolving(Program program) {
      super(program);
   }

   /**
    * Identify constant range values
    *
    * @return true optimization was performed. false if no optimization was possible.
    */
   @Override
   public boolean step() {
      boolean modified = false;

      ProgramValueIterator.execute(getProgram().getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value value = programValue.get();
         if(value instanceof RangeValue) {
            RangeValue rangeValue = (RangeValue) value;
            if(rangeValue.getRangeFirst() instanceof ConstantValue && rangeValue.getRangeLast() instanceof ConstantValue) {
               // Range value with constant first & last found - resolve it
               ConstantLiteral firstLiteral = ((ConstantValue) rangeValue.getRangeFirst()).calculateLiteral(getScope());
               ConstantLiteral lastLiteral = ((ConstantValue) rangeValue.getRangeLast()).calculateLiteral(getScope());
               if(!(firstLiteral instanceof ConstantEnumerable)) {
                  throw new CompileError("Error! Ranged for() has non-integer first value in the range " + currentStmt.getSource().toString());
               }
               if(!(lastLiteral instanceof ConstantEnumerable)) {
                  throw new CompileError("Error! Ranged for() has non-integer first value in the range " + currentStmt.getSource().toString());
               }

               ConstantEnumerable first = (ConstantEnumerable) firstLiteral;
               ConstantEnumerable last = (ConstantEnumerable) lastLiteral;
               Long lastInt = last.getInteger();
               Long firstInt = first.getInteger();

               if(rangeValue instanceof RangeComparison) {
                  SymbolType type = ((RangeComparison) rangeValue).getType();
                  SymbolTypeIntegerFixed valueType;
                  if(type instanceof SymbolTypeIntegerFixed) {
                     valueType = (SymbolTypeIntegerFixed) type;
                  } else if(type instanceof SymbolTypePointer) {
                     valueType = SymbolType.WORD;
                  } else {
                     throw new CompileError("Error! Unknown range value type " + type);
                  }
                  ConstantValue beyondLastVal;
                  if(firstInt <= lastInt) {
                     if(lastInt == valueType.getMaxValue()) {
                        beyondLastVal = new ConstantInteger(valueType.getMinValue());
                     } else if(rangeValue.getRangeLast() instanceof ConstantInteger) {
                        beyondLastVal = new ConstantInteger(lastInt+1);
                     } else {
                        beyondLastVal = new ConstantBinary((ConstantValue) rangeValue.getRangeLast(), Operators.PLUS, new ConstantInteger(1L));
                     }
                  } else {
                     if(lastInt == valueType.getMinValue()) {
                        beyondLastVal = new ConstantInteger(valueType.getMaxValue());
                     } else if(rangeValue.getRangeLast() instanceof ConstantInteger) {
                        beyondLastVal = new ConstantInteger(lastInt-1);
                     } else {
                        beyondLastVal = new ConstantBinary((ConstantValue) rangeValue.getRangeLast(), Operators.MINUS, new ConstantInteger(1L));
                     }
                  }
                  if(type instanceof SymbolTypePointer) {
                     beyondLastVal = new ConstantCastValue(type, beyondLastVal );
                  }
                  getLog().append("Resolved ranged comparison value "+currentStmt+" to "+beyondLastVal.toString(getProgram()));
                  programValue.set(beyondLastVal);
               } else if(rangeValue instanceof RangeNext) {
                  StatementAssignment assignment = (StatementAssignment) currentStmt;
                  if(firstInt <= lastInt) {
                     assignment.setrValue2(assignment.getrValue1());
                     assignment.setrValue1(null);
                     assignment.setOperator(Operators.INCREMENT);
                  } else {
                     assignment.setrValue2(assignment.getrValue1());
                     assignment.setrValue1(null);
                     assignment.setOperator(Operators.DECREMENT);
                  }
                  getLog().append("Resolved ranged next value "+currentStmt+" to "+assignment.getOperator().toString());
               } else {
                  throw new CompileError("Error! Unknown range type " + rangeValue);
               }
            }
         }
      });
      return modified;
   }

}
