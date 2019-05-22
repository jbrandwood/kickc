package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.values.*;

/**
 * Type inference of expressions (rValues & unary/binary operators)
 */
public class SymbolTypeInference {

   /**
    * Infer the type of a unary operator on a value
    *
    * @param programScope The program scope usable for accessing the symbol table
    * @param operator The unary operator
    * @param rValue The value
    * @return The type of the resulting value
    */
   public static SymbolType inferType(ProgramScope programScope, OperatorUnary operator, RValue rValue) {
      SymbolType valueType = inferType(programScope, rValue);
      return operator.inferType(valueType);
   }

   /**
    * Infer the type of a binary operator on a value
    *
    * @param programScope The program scope usable for accessing the symbol table
    * @param left The left value
    * @param operator The binary operator
    * @param rValue The right value
    * @return The type of the resulting value
    */
   public static SymbolType inferType(ProgramScope programScope, RValue left, OperatorBinary operator, RValue right) {
      SymbolType leftType = inferType(programScope, left);
      SymbolType rightType = inferType(programScope, right);
      return operator.inferType(leftType, rightType);
   }

   public static SymbolType inferType(ProgramScope symbols, RValue rValue) {
      SymbolType type = null;
      if(rValue instanceof VariableRef) {
         Variable variable = symbols.getVariable((VariableRef) rValue);
         type = variable.getType();
      } else if(rValue instanceof ConstantRef) {
         ConstantVar constVar = symbols.getConstant((ConstantRef) rValue);
         type = constVar.getType();
      } else if(rValue instanceof Symbol) {
         Symbol rSymbol = (Symbol) rValue;
         type = rSymbol.getType();
      } else if(rValue instanceof ConstantInteger) {
         return ((ConstantInteger) rValue).getType(symbols);
      } else if(rValue instanceof ConstantString) {
         type = SymbolType.STRING;
      } else if(rValue instanceof ConstantChar) {
         type = SymbolType.BYTE;
      } else if(rValue instanceof ConstantBool) {
         type = SymbolType.BOOLEAN;
      } else if(rValue instanceof ConstantUnary) {
         ConstantUnary constUnary = (ConstantUnary) rValue;
         return inferType(symbols, constUnary.getOperator(), constUnary.getOperand());
      } else if(rValue instanceof ConstantBinary) {
         ConstantBinary constBin = (ConstantBinary) rValue;
         return inferType(symbols, constBin.getLeft(), constBin.getOperator(), constBin.getRight());
      } else if(rValue instanceof ValueList) {
         type = inferTypeList(symbols, (ValueList) rValue);
      } else if(rValue instanceof PointerDereference) {
         SymbolType pointerType = inferType(symbols, ((PointerDereference) rValue).getPointer());
         if(pointerType instanceof SymbolTypePointer) {
            return ((SymbolTypePointer) pointerType).getElementType();
         } else if(pointerType.equals(SymbolType.STRING)) {
            return SymbolType.BYTE;
         } else {
            throw new RuntimeException("Cannot infer pointer element type from pointer type " + pointerType);
         }
      } else if(rValue instanceof ConstantArrayList) {
         return new SymbolTypeArray(((ConstantArrayList) rValue).getElementType());
      } else if(rValue instanceof ArrayFilled) {
         return new SymbolTypeArray(((ArrayFilled) rValue).getElementType(), ((ArrayFilled) rValue).getSize());
      } else if(rValue instanceof ConstantArrayFilled) {
         return new SymbolTypeArray(((ConstantArrayFilled) rValue).getElementType(), ((ConstantArrayFilled) rValue).getSize());
      } else if(rValue instanceof ConstantSymbolPointer) {
         return ((ConstantSymbolPointer) rValue).getType(symbols);
      } else if(rValue instanceof CastValue) {
         return ((CastValue) rValue).getToType();
      } else if(rValue instanceof ConstantCastValue) {
         return ((ConstantCastValue) rValue).getToType();
      } else if(rValue instanceof ConstantPointer) {
         return new SymbolTypePointer(((ConstantPointer) rValue).getElementType());
      } else if(rValue instanceof RangeComparison) {
         return ((RangeComparison) rValue).getType();
      } else if(rValue instanceof RangeNext) {
         SymbolType rangedType = inferType(symbols, ((RangeNext) rValue).getRangeFirst());
         if(SymbolType.SBYTE.equals(rangedType) || SymbolType.SWORD.equals(rangedType) || SymbolType.SDWORD.equals(rangedType)) {
            return SymbolType.SBYTE;
         } else {
            return SymbolType.BYTE;
         }
      } else if(rValue instanceof ProcedureRef) {
         Procedure procedure = symbols.getProcedure((ProcedureRef) rValue);
         return procedure.getType();
      } else if(rValue instanceof AssignmentRValue) {
         return inferTypeRValue(symbols, ((AssignmentRValue) rValue).getAssignment());
      }
      if(type == null) {
         throw new RuntimeException("Cannot infer type for " + rValue.toString());
      }
      return type;
   }

   private static SymbolType inferTypeList(ProgramScope symbols, ValueList list) {
      SymbolType elmType = null;
      for(RValue elm : list.getList()) {
         SymbolType type = inferType(symbols, elm);
         if(elmType == null) {
            elmType = type;
         } else {
            if(!elmType.equals(type)) {
               if(SymbolType.NUMBER.equals(elmType) && SymbolType.isInteger(type)) {
                  elmType = SymbolType.NUMBER;
               } else if(SymbolType.isInteger(elmType) && SymbolType.NUMBER.equals(type)) {
                  elmType = SymbolType.NUMBER;
               } else {
                  throw new CompileError("Array element has type mismatch "+elm.toString() + " not matching type " + elmType.getTypeName());
               }
            }
         }
      }
      if(elmType != null) {
         long size = list.getList().size();
         return new SymbolTypeArray(elmType, new ConstantInteger(size, size<256?SymbolType.BYTE:SymbolType.WORD));
      } else {
         throw new RuntimeException("Cannot infer list element type " + list.toString());
      }
   }

   public static SymbolType inferTypeRValue(ProgramScope symbols, StatementAssignment assignment) {
      SymbolType rValueType;
      RValue rValue1 = assignment.getrValue1();
      RValue rValue2 = assignment.getrValue2();
      if(assignment.getrValue1() == null && assignment.getOperator() == null) {
         rValueType = inferType(symbols, rValue2);
      } else if(assignment.getrValue1() == null && assignment.getOperator() instanceof OperatorUnary) {
         rValueType = inferType(symbols, (OperatorUnary) assignment.getOperator(), rValue2);
      } else if(assignment.getOperator() instanceof OperatorBinary) {
         rValueType = inferType(symbols, rValue1, (OperatorBinary) assignment.getOperator(), rValue2);
      } else {
         throw new CompileError("Cannot infer type of " + assignment.toString());
      }
      return rValueType;
   }

}
