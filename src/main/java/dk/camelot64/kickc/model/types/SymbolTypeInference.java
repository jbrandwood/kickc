package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.values.*;

/**
 * Type inference of an RValue
 */
public class SymbolTypeInference {

   public static SymbolType inferType(ProgramScope symbols, RValue rValue) {
      SymbolType type = null;
      if(rValue instanceof SymbolVariableRef) {
         Variable variable = symbols.getVar((SymbolVariableRef) rValue);
         type = variable.getType();
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
         SymbolType valueType = inferType(symbols, constUnary.getOperand());
         return constUnary.getOperator().inferType(valueType);
      } else if(rValue instanceof ConstantBinary) {
         ConstantBinary constBin = (ConstantBinary) rValue;
         SymbolType leftType = inferType(symbols, constBin.getLeft());
         SymbolType rightType = inferType(symbols, constBin.getRight());
         return constBin.getOperator().inferType(leftType, rightType);
      } else if(rValue instanceof ValueList) {
         return SymbolType.VAR;          
      } else if(rValue instanceof PointerDereference) {
         SymbolType pointerType = inferType(symbols, ((PointerDereference) rValue).getPointer());
         if(pointerType instanceof SymbolTypePointer) {
            return ((SymbolTypePointer) pointerType).getElementType();
         } else if(pointerType.equals(SymbolType.STRING)) {
            return SymbolType.BYTE;
         } else {
            throw new CompileError("Cannot infer pointer element type from type: " + pointerType);
         }
      } else if(rValue instanceof ConstantArrayList) {
         return new SymbolTypePointer(((ConstantArrayList) rValue).getElementType());
      } else if(rValue instanceof ConstantArrayKickAsm) {
         return new SymbolTypePointer(((ConstantArrayKickAsm) rValue).getElementType());
      } else if(rValue instanceof ConstantArrayFilled) {
         return new SymbolTypePointer(((ConstantArrayFilled) rValue).getElementType());
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
         StatementAssignment assignment = ((AssignmentRValue) rValue).getAssignment();
         SymbolType rValueType;
         RValue rValue1 = assignment.getrValue1();
         RValue rValue2 = assignment.getrValue2();
         if(assignment.getrValue1() == null && assignment.getOperator() == null) {
            // Copy assignment
            rValueType = inferType(symbols, rValue2);
         } else if(assignment.getrValue1() == null && assignment.getOperator() instanceof OperatorUnary) {
            // Unary operation assignment
            SymbolType valueType = inferType(symbols, rValue2);
            rValueType = ((OperatorUnary) assignment.getOperator()).inferType(valueType);
         } else if(assignment.getOperator() instanceof OperatorBinary) {
            // Binary operation assignment
            SymbolType leftType = inferType(symbols, rValue1);
            SymbolType rightType = inferType(symbols, rValue2);
            rValueType = ((OperatorBinary) assignment.getOperator()).inferType(leftType, rightType);
         } else {
            throw new InternalError("Cannot infer type of " + assignment.toString());
         }
         return rValueType;
      } else if(rValue instanceof StructMemberRef) {
         StructMemberRef structMemberRef = (StructMemberRef) rValue;
         SymbolType structType = inferType(symbols, structMemberRef.getStruct());
         if(structType instanceof SymbolTypeStruct) {
            String typeName = ((SymbolTypeStruct) structType).getStructTypeName();
            StructDefinition structDefinition = symbols.getStructDefinition(typeName);
            Variable structMember = structDefinition.getVar(structMemberRef.getMemberName());
            return structMember.getType();
         } else {
            throw new CompileError("Dot applied to non-struct "+ structMemberRef.getStruct().toString());
         }
      } else if(rValue instanceof StructZero) {
         return ((StructZero)rValue).getTypeStruct();
      } else if(rValue instanceof ParamValue) {
         return inferType(symbols, ((ParamValue) rValue).getParameter());
      } else if(rValue instanceof StackIdxValue) {
         return SymbolType.BYTE;
      } else if(rValue instanceof StructUnwoundPlaceholder) {
         return ((StructUnwoundPlaceholder) rValue).getTypeStruct();
      } else if(rValue instanceof ConstantStructValue) {
         return ((ConstantStructValue) rValue).getStructType();
      }
      if(type == null) {
         throw new InternalError("Cannot infer type for " + rValue.toString());
      }
      return type;
   }

}
