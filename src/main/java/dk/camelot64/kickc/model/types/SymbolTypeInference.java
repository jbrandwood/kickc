package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.values.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

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
      if(rValue instanceof ConstantValue) {
         // Calculate resulting constant literal
         try {
            ConstantValue constRValue = (ConstantValue) rValue;
            ConstantLiteral literalRValue = constRValue.calculateLiteral(programScope);
            ConstantValue value = operator.calculateLiteral(literalRValue);
            return value.getType(programScope);
         } catch(ConstantNotLiteral e) {
            // Value literal cannot be calculated
         }
      }
      // Infer value type - and then infer operator result type
      SymbolType valueType = inferType(programScope, rValue);
      return inferType(operator, valueType);
   }

   /**
    * Infer the type of a unary operator on an operand type
    *
    * @param operator The unary operator
    * @param operandType The operand type
    * @return The type of the result from applying the operator on the operand
    */
   public static SymbolType inferType(OperatorUnary operator, SymbolType operandType) {
      if(operandType instanceof SymbolTypeSimple) {
         return operator.inferType((SymbolTypeSimple) operandType);
      } else {
         // Infer all resulting types for each sub-type of the multi-type
         ArrayList<SymbolType> resultTypes = new ArrayList<>();
         for(SymbolType opType : ((SymbolTypeMulti) operandType).getTypes()) {
            SymbolType resType = inferType(operator, opType);
            if(!resultTypes.contains(resType)) {
               resultTypes.add(resType);
            }
         }
         if(resultTypes.size() == 1) {
            return resultTypes.get(0);
         } else {
            return new SymbolTypeMulti(resultTypes);
         }
      }
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
      if(left instanceof ConstantValue && right instanceof ConstantValue) {
         // Calculate resulting constant literal
         try {
            ConstantValue value = operator.calculateLiteral(
                  ((ConstantValue) left).calculateLiteral(programScope),
                  ((ConstantValue) right).calculateLiteral(programScope)
            );
            return value.getType(programScope);
         } catch(ConstantNotLiteral e) {
            // Value literal cannot be calculated
         }
      }
      SymbolType leftType = inferType(programScope, left);
      SymbolType rightType = inferType(programScope, right);
      return inferType(leftType, operator, rightType);
   }

   public static SymbolType inferType(SymbolType left, OperatorBinary operator, SymbolType right) {
      if(left instanceof SymbolTypeSimple && right instanceof SymbolTypeSimple) {
         return operator.inferType((SymbolTypeSimple) left, (SymbolTypeSimple) right);
      } else {
         // Infer all resulting types for each sub-type of the multi-type
         if(left instanceof SymbolTypeSimple) {
            left = new SymbolTypeMulti(Arrays.asList(left));
         }
         if(right instanceof SymbolTypeSimple) {
            right = new SymbolTypeMulti(Arrays.asList(right));
         }
         ArrayList<SymbolType> resultTypes = new ArrayList<>();
         for(SymbolType leftType : ((SymbolTypeMulti) left).getTypes()) {
            for(SymbolType rightType : ((SymbolTypeMulti) right).getTypes()) {
               SymbolType resType;
               try {
                  resType = inferType(leftType, operator, rightType);
                  if(!resultTypes.contains(resType)) {
                     resultTypes.add(resType);
                  }
               } catch(NoMatchingType e) {
                  // Cannot promote to common type - ignore!
               }
            }
         }
         if(resultTypes.size() == 1) {
            return resultTypes.get(0);
         } else {
            return new SymbolTypeMulti(resultTypes);
         }
      }
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
      } else if(rValue instanceof ConstantVarPointer) {
         return ((ConstantVarPointer) rValue).getType(symbols);
      } else if(rValue instanceof CastValue) {
         return ((CastValue) rValue).getToType();
      } else if(rValue instanceof ConstantCastValue) {
         return ((ConstantCastValue) rValue).getToType();
      } else if(rValue instanceof ConstantPointer) {
         return new SymbolTypePointer(((ConstantPointer) rValue).getElementType());
      } else if(rValue instanceof RangeComparison) {
         return ((RangeComparison) rValue).getType();
      } else if(rValue instanceof RangeNext) {
         return SymbolType.BYTE;
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
            // element type already defined - check for a match
            if(!typeMatch(elmType, type)) {
               if(typeMatch(type, elmType)) {
                  elmType = type;
               } else {
                  throw new RuntimeException("Array element has type mismatch " + elm.toString() + " not matching type " + elmType.getTypeName());
               }
            }
         }
      }
      if(elmType != null) {
         if((list.getList().size() == 2 && SymbolType.isByte(elmType) || SymbolType.isSByte(elmType))) {
            // Potentially a word constructor - return a composite type
            ArrayList<SymbolType> types = new ArrayList<>();
            types.add(new SymbolTypeArray(elmType));
            types.add(SymbolType.WORD);
            return new SymbolTypeMulti(types);
         } else if((list.getList().size() == 2 && SymbolType.isWord(elmType))) {
            // Potentially a dword constructor - return a composite type
            ArrayList<SymbolType> types = new ArrayList<>();
            types.add(new SymbolTypeArray(elmType));
            types.add(SymbolType.DWORD);
            return new SymbolTypeMulti(types);
         } else {
            return new SymbolTypeArray(elmType);
         }
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

   /**
    * Determine if lValue and rValue types match (the same types, not needing a cast).
    *
    * @param lValueType The lValue type
    * @param rValueType The rvalue type
    * @return true if the types match
    */
   public static boolean typeMatch(SymbolType lValueType, SymbolType rValueType) {
      if(lValueType.equals(rValueType)) {
         // Types match directly
         return true;
      } else if(rValueType instanceof SymbolTypeMulti) {
         Collection<SymbolType> rTypes = ((SymbolTypeMulti) rValueType).getTypes();
         if(lValueType instanceof SymbolTypeMulti) {
            // Both are inline types - RValue type must be superset of LValue
            Collection<SymbolType> lTypes = ((SymbolTypeMulti) lValueType).getTypes();
            return typeContainsMatchAll(lTypes, rTypes);
         } else {
            // Types match because the right side matches the left side
            return typeContainsMatch(lValueType, rTypes);
         }
      } else if(lValueType instanceof SymbolTypePointer && rValueType instanceof SymbolTypePointer) {
         return typeMatch(
               ((SymbolTypePointer) lValueType).getElementType(),
               ((SymbolTypePointer) rValueType).getElementType());
      } else if(lValueType instanceof SymbolTypePointer && SymbolType.STRING.equals(rValueType)) {
         if(SymbolType.isByte(((SymbolTypePointer) lValueType).getElementType())) {
            return true;
         }
      } else if(SymbolType.STRING.equals(lValueType) && rValueType instanceof SymbolTypePointer) {
         if(SymbolType.isByte(((SymbolTypePointer) rValueType).getElementType())) {
            return true;
         }
      }
      return false;
   }

   private static boolean typeContainsMatchAll(Collection<SymbolType> lTypes, Collection<SymbolType> rTypes) {
      for(SymbolType lType : lTypes) {
         if(!typeContainsMatch(lType, rTypes)) {
            return false;
         }
      }
      return true;
   }

   /**
    * Determine is a list of potential inferred types contains a match for another type
    *
    * @param lValueType The type (rValue) we want to find a match for in the list
    * @param rTypes The list of inferred potential types
    * @return true if the list has a match
    */
   private static boolean typeContainsMatch(SymbolType lValueType, Collection<SymbolType> rTypes) {
      for(SymbolType rType : rTypes) {
         if(typeMatch(lValueType, rType)) {
            return true;
         }
      }
      return false;
   }

   public static void inferCallLValue(Program program, StatementCall call, boolean reinfer) {
      ProgramScope programScope = program.getScope();
      LValue lValue = call.getlValue();
      if(lValue instanceof VariableRef) {
         Variable symbol = programScope.getVariable((VariableRef) lValue);
         if(SymbolType.VAR.equals(symbol.getType()) || (reinfer && symbol.isInferredType())) {
            Procedure procedure = programScope.getProcedure(call.getProcedure());
            SymbolType type = procedure.getReturnType();
            setInferedType(program, call, symbol, type);
         }
      }
   }

   public static void inferAssignmentLValue(Program program, StatementAssignment assignment, boolean reinfer) {
      ProgramScope programScope = program.getScope();
      LValue lValue = assignment.getlValue();
      if(lValue instanceof VariableRef) {
         Variable symbol = programScope.getVariable((VariableRef) lValue);
         if(SymbolType.VAR.equals(symbol.getType()) || (reinfer && symbol.isInferredType())) {
            // Unresolved symbol - perform inference
            Operator operator = assignment.getOperator();
            if(assignment.getrValue1() == null && operator == null) {
               // Copy operation
               RValue rValue = assignment.getrValue2();
               SymbolType type = inferType(programScope, rValue);
               setInferedType(program, assignment, symbol, type);
            } else if(assignment.getrValue1() == null && operator instanceof OperatorUnary) {
               // Unary operation
               RValue rValue = assignment.getrValue2();
               SymbolType type = inferType(programScope, (OperatorUnary) operator, rValue);
               setInferedType(program, assignment, symbol, type);
            } else if(operator instanceof OperatorBinary) {
               // Binary operation
               SymbolType type = inferType(
                     programScope, assignment.getrValue1(),
                     (OperatorBinary) assignment.getOperator(),
                     assignment.getrValue2());
               setInferedType(program, assignment, symbol, type);
            } else {
               throw new CompileError("Cannot infer type of " + assignment);
            }
            // If the type is an array or a string the symbol is constant
            if(symbol.getType() instanceof SymbolTypeArray) {
               symbol.setDeclaredConstant(true);
            } else if(SymbolType.STRING.equals(symbol.getType())) {
               symbol.setDeclaredConstant(true);
            }
         }
      }
   }

   private static void setInferedType(Program program, StatementLValue statementLValue, Variable symbol, SymbolType type) {
      if(!SymbolType.VAR.equals(symbol.getType()) && !type.equals(symbol.getType())) {
         program.getLog().append("Inferred type updated to " + type + " in " + statementLValue.toString(program, false));
      }
      symbol.setTypeInferred(type);
   }

   public static void inferLValue(Program program, StatementLValue statementLValue, boolean reinfer) {
      if(statementLValue instanceof StatementAssignment) {
         inferAssignmentLValue(program, (StatementAssignment) statementLValue, reinfer);
      } else if(statementLValue instanceof StatementCall) {
         inferCallLValue(program, (StatementCall) statementLValue, reinfer);
      } else {
         throw new RuntimeException("LValue statement not implemented " + statementLValue);
      }
   }

   /**
    * Find the symbol type that is the intersection between the two passed types.
    * Handles SymbolTypeMulti by intersecting the sub type lists.
    * @param type1 The first type
    * @param type2 The second type
    * @return The intersection between the two types (handling multi-types)
    */
   public static SymbolType intersectTypes(SymbolType type1, SymbolType type2) {
      List<SymbolType> newSubTypes = new ArrayList<>();
      if(type1 instanceof SymbolTypeMulti) {
         Collection<SymbolType> subTypes1 = ((SymbolTypeMulti) type1).getTypes();
         if(type2 instanceof SymbolTypeMulti) {
            Collection<SymbolType> subTypes2 = ((SymbolTypeMulti) type2).getTypes();
            for(SymbolType subType1 : subTypes1) {
               if(subTypes2.contains(subType1)) {
                  newSubTypes.add(subType1);
               }
            }
         } else {
            // Element type is not multi - check if the list type contains it
            if(subTypes1.contains(type2)) {
               newSubTypes.add(type2);
            }
         }
      } else {
         // List-type not multi - check if the element type contains it
         if(type2 instanceof SymbolTypeMulti) {
            Collection<SymbolType> subTypes2 = ((SymbolTypeMulti) type2).getTypes();
            if(subTypes2.contains(type1)) {
               newSubTypes.add(type1);
            }
         } else {
            // Element type is not multi - check if the list type is the same
            if(type1.equals(type2)) {
               newSubTypes.add(type1);
            }
         }
      }
      if(newSubTypes.size()==0) {
         return  null;
      }  else if(newSubTypes.size()==1) {
         // A single type matching - use it
         return newSubTypes.get(0);
      }  else {
         // Multiple matches was found - use them
         return new SymbolTypeMulti(newSubTypes);
      }
   }
}
