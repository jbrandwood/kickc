package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.ConstantValueCalculator;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.model.symbols.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;

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
         ConstantValue value = null;
         try {
            value = operator.calculate(ConstantValueCalculator.calcValue(programScope, (ConstantValue) rValue));
         } catch(ConstantNotLiteral e) {
            value = null;
         }
         if(value != null) {
            return value.getType(programScope);
         }
      }
      if(operator.equals(Operators.CAST_BYTE)) {
         return SymbolType.BYTE;
      } else if(operator.equals(Operators.CAST_SBYTE)) {
         return SymbolType.SBYTE;
      } else if(operator.equals(Operators.CAST_WORD)) {
         return SymbolType.WORD;
      } else if(operator.equals(Operators.CAST_SWORD)) {
         return SymbolType.SWORD;
      } else if(operator.equals(Operators.CAST_DWORD)) {
         return SymbolType.DWORD;
      } else if(operator.equals(Operators.CAST_SDWORD)) {
         return SymbolType.SDWORD;
      } else if(operator.equals(Operators.CAST_PTRBY)) {
         return new SymbolTypePointer(SymbolType.BYTE);
      } else if(operator.equals(Operators.ADDRESS_OF)) {
         SymbolType valueType = inferType(programScope, rValue);
         return new SymbolTypePointer(valueType);
      }
      SymbolType valueType = inferType(programScope, rValue);
      return inferType(operator, valueType);
   }

   public static SymbolType inferType(ProgramScope programScope, RValue rValue1, OperatorBinary operator, RValue rValue2) {
      if(rValue1 instanceof ConstantValue && rValue2 instanceof ConstantValue) {
         //ConstantValue value = ConstantValueCalculator.calcValue(programScope,(ConstantValue) rValue1,operator,(ConstantValue) rValue2);
         ConstantValue value = null;
         try {
            value = operator.calculate(
                  ConstantValueCalculator.calcValue(programScope, (ConstantValue) rValue1),
                  ConstantValueCalculator.calcValue(programScope, (ConstantValue) rValue2)
            );
         } catch(ConstantNotLiteral e) {
            value = null;
         }
         if(value != null) {
            return value.getType(programScope);
         }
      }
      SymbolType valueType1 = inferType(programScope, rValue1);
      SymbolType valueType2 = inferType(programScope, rValue2);
      return inferType(valueType1, operator, valueType2);
   }


   public static SymbolType inferType(Operator operator, SymbolType subType) {
      if(operator == null) {
         return subType;
      }
      if(Operators.DEREF.equals(operator)) {
         if(subType instanceof SymbolTypePointer) {
            return ((SymbolTypePointer) subType).getElementType();
         } else {
            throw new RuntimeException("Type error: Dereferencing a non-pointer " + subType);
         }
      } else if(Operators.LOWBYTE.equals(operator)) {
         if(subType instanceof SymbolTypePointer || SymbolType.isWord(subType) || SymbolType.isSWord(subType)) {
            return SymbolType.BYTE;
         } else if(SymbolType.isDWord(subType) || SymbolType.isSDWord(subType)) {
            return SymbolType.WORD;
         }
      } else if(Operators.HIBYTE.equals(operator)) {
         if(subType instanceof SymbolTypePointer || SymbolType.isWord(subType) || SymbolType.isSWord(subType)) {
            return SymbolType.BYTE;
         } else if(SymbolType.isDWord(subType) || SymbolType.isSDWord(subType)) {
            return SymbolType.WORD;
         }
      } else if(Operators.CAST_BYTE.equals(operator)) {
         return SymbolType.BYTE;
      } else if(Operators.CAST_SBYTE.equals(operator)) {
         return SymbolType.SBYTE;
      } else if(Operators.CAST_WORD.equals(operator)) {
         return SymbolType.WORD;
      } else if(Operators.CAST_SWORD.equals(operator)) {
         return SymbolType.SWORD;
      } else {
         return subType;
      }
      throw new RuntimeException("Type inference problem unary " + operator + " " + subType);
   }

   public static SymbolType inferType(SymbolType type1, Operator operator, SymbolType type2) {

      if(Operators.PLUS.equals(operator)) {
         return inferPlus(type1, type2);
      } else if(Operators.MINUS.equals(operator)) {
         return inferMinus(type1, type2);
      } else if(Operators.BOOL_AND.equals(operator)) {
         return inferBoolAnd(type1, type2);
      } else if(Operators.SET_HIBYTE.equals(operator)) {
         return type1;
      } else if(Operators.SET_LOWBYTE.equals(operator)) {
         return type1;
      } else if(Operators.WORD.equals(operator)) {
         return SymbolType.WORD;
      } else if(Operators.DWORD.equals(operator)) {
         return SymbolType.DWORD;
      }

      String op = operator.getOperator();
      switch(op) {
         case "==":
         case "<":
         case "<=":
         case "=<":
         case ">":
         case ">=":
         case "=>":
         case "<>":
         case "!=":
         case "&&":
         case "||":
         case "and":
         case "or":
            return SymbolType.BOOLEAN;
         case "*":
            if(type1 == null && type2 instanceof SymbolTypePointer) {
               return ((SymbolTypePointer) type2).getElementType();
            }
            if(SymbolType.isByte(type1) && SymbolType.isByte(type2)) {
               return SymbolType.BYTE;
            } else if(SymbolType.SBYTE.equals(type1) && SymbolType.SBYTE.equals(type2)) {
               return SymbolType.SBYTE;
            } else if(SymbolType.isWord(type1) && SymbolType.isWord(type2)) {
               return SymbolType.WORD;
            } else if(SymbolType.isSWord(type1) && SymbolType.isSWord(type2)) {
               return SymbolType.SWORD;
            } else if(SymbolType.isDWord(type1) && SymbolType.isDWord(type2)) {
               return SymbolType.DWORD;
            } else if(SymbolType.isSDWord(type1) && SymbolType.isSDWord(type2)) {
               return SymbolType.SDWORD;
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         case "*idx":
            if(type1 instanceof SymbolTypePointer) {
               return ((SymbolTypePointer) type1).getElementType();
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         case "/":
            if(type1 instanceof SymbolTypePointer && SymbolType.isByte(type2)) {
               return type1;
            }
         case "&":
         case "|":
         case "^":
            if(SymbolType.isByte(type1) && SymbolType.isByte(type2)) {
               return SymbolType.BYTE;
            } else if(SymbolType.isWord(type1) && SymbolType.isWord(type2)) {
               return SymbolType.WORD;
            } else if(SymbolType.isDWord(type1) || SymbolType.isSDWord(type2)) {
               return SymbolType.DWORD;
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         case "<<":
         case ">>":
            if(SymbolType.isByte(type1)) {
               return SymbolType.BYTE;
            } else if(SymbolType.isSByte(type1)) {
               return SymbolType.SBYTE;
            } else if(SymbolType.isWord(type1)) {
               return SymbolType.WORD;
            } else if(SymbolType.isSWord(type1)) {
               return SymbolType.SWORD;
            } else if(SymbolType.isDWord(type1)) {
               return SymbolType.DWORD;
            } else if(SymbolType.isSDWord(type1)) {
               return SymbolType.SDWORD;
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         default:
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
      }
   }

   private static SymbolType inferPlus(SymbolType type1, SymbolType type2) {
      if(type1.equals(SymbolType.STRING) && SymbolType.isByte(type2)) {
         return SymbolType.STRING;
      } else if(type1.equals(SymbolType.STRING) && SymbolType.STRING.equals(type2)) {
         return SymbolType.STRING;
      } else if(type1.equals(SymbolType.STRING) && type2 instanceof SymbolTypeArray && SymbolType.isByte(((SymbolTypeArray) type2).getElementType())) {
         return SymbolType.STRING;
      } else if(type1 instanceof SymbolTypeArray && SymbolType.isByte(((SymbolTypeArray) type1).getElementType()) && type2.equals(SymbolType.STRING)) {
         return SymbolType.STRING;
      } else if(type1 instanceof SymbolTypeArray && type2 instanceof SymbolTypeArray) {
         SymbolType elemType1 = ((SymbolTypeArray) type1).getElementType();
         SymbolType elemType2 = ((SymbolTypeArray) type2).getElementType();
         if(typeMatch(elemType1, elemType2)) {
            return new SymbolTypeArray(elemType1);
         } else if(typeMatch(elemType2, elemType1)) {
            return new SymbolTypeArray(elemType2);
         } else {
            throw new RuntimeException("Type inference case not handled " + type1 + " " + "+" + " " + type2);
         }
      } else if(type1 instanceof SymbolTypePointer && isInteger(type2)) {
         return new SymbolTypePointer(((SymbolTypePointer) type1).getElementType());
      } else if(SymbolType.isByte(type1) && SymbolType.isByte(type2)) {
         return new SymbolTypeInline(Arrays.asList(SymbolType.BYTE, SymbolType.WORD));
      } else if(SymbolType.isSByte(type1) && SymbolType.isSByte(type2)) {
         return SymbolTypeInline.NUMERIC;
      } else if(SymbolType.isWord(type1) && (SymbolType.isWord(type2) || SymbolType.isByte(type2))) {
         return SymbolType.WORD;
      } else if(SymbolType.isSWord(type1) && (SymbolType.isSWord(type2) || SymbolType.isSByte(type2))) {
         return SymbolType.SWORD;
      } else if(SymbolType.isDWord(type1) && (SymbolType.isDWord(type2) || SymbolType.isWord(type2)) || SymbolType.isByte(type2)) {
         return SymbolType.DWORD;
      } else if(SymbolType.isSDWord(type1) && (SymbolType.isSDWord(type2) || SymbolType.isSWord(type2) || SymbolType.isSByte(type2))) {
         return SymbolType.SDWORD;
      }
      throw new RuntimeException("Type inference case not handled " + type1 + " " + "+" + " " + type2);
   }

   private static SymbolType inferBoolAnd(SymbolType type1, SymbolType type2) {
      if(SymbolType.isSByte(type1) && SymbolType.isSByte(type2)) {
         return SymbolTypeInline.SBYTE;
      } else if(SymbolType.isByte(type1) || SymbolType.isByte(type2)) {
         return SymbolType.BYTE;
      } else if(SymbolType.isSWord(type1) && SymbolType.isSWord(type2)) {
         return SymbolType.SWORD;
      } else if(SymbolType.isWord(type1) || SymbolType.isWord(type2)) {
         return SymbolType.WORD;
      } else if(SymbolType.isSDWord(type1) || SymbolType.isSDWord(type2)) {
         return SymbolType.SDWORD;
      } else if(SymbolType.isDWord(type1) || SymbolType.isDWord(type2)) {
         return SymbolType.DWORD;
      }
      throw new RuntimeException("Type inference case not handled " + type1 + " " + "+" + " " + type2);
   }

   private static SymbolType inferMinus(SymbolType type1, SymbolType type2) {
      if(type1 instanceof SymbolTypePointer && isInteger(type2)) {
         return new SymbolTypePointer(((SymbolTypePointer) type1).getElementType());
      }
      if(type1 instanceof SymbolTypePointer && type2 instanceof SymbolTypePointer) {
         return SymbolType.WORD;
      }
      if(SymbolType.isByte(type1) && SymbolType.isByte(type2)) {
         return SymbolTypeInline.NUMERIC;
      }
      if(SymbolType.isSByte(type1) && SymbolType.isSByte(type2)) {
         return SymbolTypeInline.NUMERIC;
      }
      if(SymbolType.isWord(type1) && (SymbolType.isWord(type2) || SymbolType.isByte(type2))) {
         return SymbolType.WORD;
      }
      if(SymbolType.isSWord(type1) && (SymbolType.isSWord(type2) || SymbolType.isSByte(type2))) {
         return SymbolType.SWORD;
      }
      if(SymbolType.isDWord(type1) && (SymbolType.isDWord(type2) || SymbolType.isWord(type2) || SymbolType.isByte(type2))) {
         return SymbolType.DWORD;
      }
      if(SymbolType.isSDWord(type1) && (SymbolType.isSDWord(type2) || SymbolType.isSWord(type2) || SymbolType.isSByte(type2))) {
         return SymbolType.SDWORD;
      }
      throw new RuntimeException("Type inference case not handled " + type1 + " - " + type2);
   }


   private static boolean isInteger(SymbolType type) {
      if(SymbolType.BYTE.equals(type)) {
         return true;
      } else if(SymbolType.WORD.equals(type)) {
         return true;
      } else if(SymbolType.SBYTE.equals(type)) {
         return true;
      } else if(SymbolType.SWORD.equals(type)) {
         return true;
      } else if(type instanceof SymbolTypeInline) {
         SymbolTypeInline typeInline = (SymbolTypeInline) type;
         return typeInline.isByte() || typeInline.isSByte() || typeInline.isWord() || typeInline.isSWord() || typeInline.isDWord() || typeInline.isSDWord();
      } else {
         return false;
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
      } else if(rValue instanceof ConstantArrayFilled) {
         return new SymbolTypeArray(((ConstantArrayFilled) rValue).getElementType(), ((ConstantArrayFilled) rValue).getSize());
      } else if(rValue instanceof ConstantVarPointer) {
         return ((ConstantVarPointer) rValue).getType(symbols);
      } else if(rValue instanceof CastValue) {
         return ((CastValue) rValue).getToType();
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
            return new SymbolTypeInline(types);
         } else if((list.getList().size() == 2 && SymbolType.isWord(elmType) )) {
            // Potentially a dword constructor - return a composite type
            ArrayList<SymbolType> types = new ArrayList<>();
            types.add(new SymbolTypeArray(elmType));
            types.add(SymbolType.DWORD);
            return new SymbolTypeInline(types);
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
         throw new CompileError("Cannot infer type of "+assignment.toString());
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
      } else if(rValueType instanceof SymbolTypeInline) {
         Collection<SymbolType> rTypes = ((SymbolTypeInline) rValueType).getTypes();
         if(lValueType instanceof SymbolTypeInline) {
            // Both are inline types - RValue type must be superset of LValue
            Collection<SymbolType> lTypes = ((SymbolTypeInline) lValueType).getTypes();
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

   public static void inferCallLValue(ProgramScope programScope, StatementCall call) {
      LValue lValue = call.getlValue();
      if(lValue instanceof VariableRef) {
         Variable lValueVar = programScope.getVariable((VariableRef) lValue);
         if(SymbolType.VAR.equals(lValueVar.getType())) {
            Procedure procedure = programScope.getProcedure(call.getProcedure());
            lValueVar.setTypeInferred(procedure.getReturnType());
         }
      }
   }

   public static void inferAssignmentLValue(ProgramScope programScope, StatementAssignment assignment) {
      LValue lValue = assignment.getlValue();
      if(lValue instanceof VariableRef) {
         Variable symbol = programScope.getVariable((VariableRef) lValue);
         if(SymbolType.VAR.equals(symbol.getType())) {
            // Unresolved symbol - perform inference
            Operator operator = assignment.getOperator();
            if(assignment.getrValue1()==null && operator == null ) {
               // Copy operation
               RValue rValue = assignment.getrValue2();
               SymbolType type = inferType(programScope, rValue);
               symbol.setTypeInferred(type);
            } else if(assignment.getrValue1() == null && operator instanceof OperatorUnary) {
               // Unary operation
               RValue rValue = assignment.getrValue2();
               SymbolType type = inferType(programScope, (OperatorUnary) operator, rValue);
               symbol.setTypeInferred(type);
            } else if(operator instanceof OperatorBinary){
               // Binary operation
               SymbolType type = inferType(
                     programScope, assignment.getrValue1(),
                     (OperatorBinary) assignment.getOperator(),
                     assignment.getrValue2());
               symbol.setTypeInferred(type);
            } else {
               throw new CompileError("Cannot infer type of "+assignment);
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

   public static void inferLValue(ProgramScope programScope, StatementLValue statementLValue) {
      if(statementLValue instanceof StatementAssignment) {
         inferAssignmentLValue(programScope, (StatementAssignment) statementLValue);
      } else if(statementLValue instanceof StatementCall) {
         inferCallLValue(programScope, (StatementCall) statementLValue);
      } else {
         throw new RuntimeException("LValue statement not implemented " + statementLValue);
      }
   }
}
