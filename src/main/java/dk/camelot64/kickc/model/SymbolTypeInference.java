package dk.camelot64.kickc.model;

import java.util.Collection;

/**
 * Type inference of expressions (rValues & unary/binary operators)
 */
public class SymbolTypeInference {


   /**
    * Infer the type of a unary operator on a value
    *
    * @param programScope The program scope usable for accessing the symbol table
    * @param operator     The unary operator
    * @param rValue       The value
    * @return The type of the resulting value
    */
   public static SymbolType inferType(ProgramScope programScope, Operator operator, RValue rValue) {
      if (operator.equals(Operator.CAST_BYTE)) {
         return SymbolType.BYTE;
      } else if (operator.equals(Operator.CAST_SBYTE)) {
         return SymbolType.SBYTE;
      } else if (operator.equals(Operator.CAST_WORD)) {
         return SymbolType.WORD;
      } else if (operator.equals(Operator.CAST_SWORD)) {
         return SymbolType.SWORD;
      } else if (operator.equals(Operator.CAST_PTRBY)) {
         return new SymbolTypePointer(SymbolType.BYTE);
      }
      if (rValue instanceof ConstantValue) {
         ConstantValue value = ConstantValueCalculator.calcValue(programScope, operator, (ConstantValue) rValue);
         if (value != null) {
            return value.getType(programScope);
         }
      }
      SymbolType valueType = inferType(programScope, rValue);
      return inferType(operator, valueType);
   }

   public static SymbolType inferType(ProgramScope programScope, RValue rValue1, Operator operator, RValue rValue2) {
      if (rValue1 instanceof ConstantValue && rValue2 instanceof ConstantValue) {
         ConstantValue value = ConstantValueCalculator.calcValue(programScope, (ConstantValue) rValue1, operator, (ConstantValue) rValue2);
         if (value != null) {
            return value.getType(programScope);
         }
      }
      SymbolType valueType1 = inferType(programScope, rValue1);
      SymbolType valueType2 = inferType(programScope, rValue2);
      return inferType(valueType1, operator, valueType2);
   }


   public static SymbolType inferType(Operator operator, SymbolType subType) {
      if (operator == null) {
         return subType;
      }
      if (Operator.DEREF.equals(operator)) {
         if (subType instanceof SymbolTypePointer) {
            return ((SymbolTypePointer) subType).getElementType();
         } else {
            throw new RuntimeException("Type error: Dereferencing a non-pointer " + subType);
         }
      } else if (Operator.LOWBYTE.equals(operator)) {
         if (subType instanceof SymbolTypePointer || SymbolType.WORD.equals(subType)) {
            return SymbolType.BYTE;
         }
      } else if (Operator.HIBYTE.equals(operator)) {
         if (subType instanceof SymbolTypePointer || SymbolType.WORD.equals(subType)) {
            return SymbolType.BYTE;
         }
      } else if (Operator.CAST_BYTE.equals(operator)) {
         return SymbolType.BYTE;
      } else if (Operator.CAST_SBYTE.equals(operator)) {
         return SymbolType.SBYTE;
      } else if (Operator.CAST_WORD.equals(operator)) {
         return SymbolType.WORD;
      } else if (Operator.CAST_SWORD.equals(operator)) {
         return SymbolType.SWORD;
      } else {
         return subType;
      }
      throw new RuntimeException("Type inference problem unary " + operator + " " + subType);
   }

   public static SymbolType inferType(SymbolType type1, Operator operator, SymbolType type2) {

      if (Operator.PLUS.equals(operator)) {
         return inferPlus(type1, type2);
      } else if (Operator.MINUS.equals(operator)) {
         return inferMinus(type1, type2);
      } else if(Operator.SET_HIBYTE.equals(operator)) {
         return type1;
      } else if(Operator.SET_LOWBYTE.equals(operator)) {
         return type1;
      }

      String op = operator.getOperator();
      switch (op) {
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
            if (type1 == null && type2 instanceof SymbolTypePointer) {
               return ((SymbolTypePointer) type2).getElementType();
            }
            if (SymbolType.WORD.equals(type1) || SymbolType.WORD.equals(type2)) {
               return SymbolType.WORD;
            } else if (isByte(type1) && isByte(type2)) {
               return SymbolType.BYTE;
            } else if (SymbolType.SBYTE.equals(type1) && SymbolType.SBYTE.equals(type2)) {
               return SymbolType.SBYTE;
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         case "*idx":
            if (type1 instanceof SymbolTypePointer) {
               return ((SymbolTypePointer) type1).getElementType();
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         case "/":
            if (type1 instanceof SymbolTypePointer && isByte(type2)) {
               return type1;
            }
         case "&":
         case "|":
         case "^":
            if (SymbolType.WORD.equals(type1) || SymbolType.WORD.equals(type2)) {
               return SymbolType.WORD;
            } else if (isByte(type1) && isByte(type2)) {
               return SymbolType.BYTE;
            }

            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         case "<<":
         case ">>":
            if (SymbolType.WORD.equals(type1)) {
               return SymbolType.WORD;
            } else if (isByte(type1)) {
               return SymbolType.BYTE;
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         default:
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
      }
   }

   private static SymbolType inferPlus(SymbolType type1, SymbolType type2) {
      if (type1.equals(SymbolType.STRING) && isByte(type2)) {
         return SymbolType.STRING;
      } else if (type1.equals(SymbolType.STRING) && SymbolType.STRING.equals(type2)) {
         return SymbolType.STRING;
      }
      if (type1 instanceof SymbolTypePointer && isInteger(type2)) {
         return new SymbolTypePointer(((SymbolTypePointer) type1).getElementType());
      }
      if (isByte(type1) && isByte(type2)) {
         return SymbolType.BYTE;
      }
      if (isSByte(type1) && isSByte(type2)) {
         return SymbolType.SBYTE;
      }
      if (isWord(type1) && isWord(type2) || isByte(type2)) {
         return SymbolType.WORD;
      }
      if (isSWord(type1) && isSWord(type2) || isSByte(type2)) {
         return SymbolType.SWORD;
      }
      throw new RuntimeException("Type inference case not handled " + type1 + " " + "+" + " " + type2);
   }

   private static SymbolType inferMinus(SymbolType type1, SymbolType type2) {
      if (type1 instanceof SymbolTypePointer && isInteger(type2)) {
         return new SymbolTypePointer(((SymbolTypePointer) type1).getElementType());
      }
      if (type1 instanceof SymbolTypePointer && type2 instanceof SymbolTypePointer) {
         return SymbolType.WORD;
      }
      if (isByte(type1) && isByte(type2)) {
         return SymbolType.BYTE;
      }
      if (isSByte(type1) && isSByte(type2)) {
         return SymbolType.SBYTE;
      }
      if (isWord(type1) && isWord(type2)) {
         return SymbolType.WORD;
      }
      if (isSWord(type1) && isSWord(type2)) {
         return SymbolType.SWORD;
      }
      throw new RuntimeException("Type inference case not handled " + type1 + " " + "+" + " " + type2);
   }


   private static boolean isInteger(SymbolType type) {
      if (SymbolType.BYTE.equals(type)) {
         return true;
      } else if (SymbolType.WORD.equals(type)) {
         return true;
      } else if (SymbolType.SBYTE.equals(type)) {
         return true;
      } else if (SymbolType.SWORD.equals(type)) {
         return true;
      } else if (type instanceof SymbolTypeInline) {
         return true;
      } else {
         return false;
      }
   }

   private static boolean isByte(SymbolType type) {
      if (SymbolType.BYTE.equals(type)) {
         return true;
      } else if (type instanceof SymbolTypeInline) {
         return ((SymbolTypeInline) type).isByte();
      } else {
         return false;
      }
   }

   private static boolean isSByte(SymbolType type) {
      if (SymbolType.SBYTE.equals(type)) {
         return true;
      } else if (type instanceof SymbolTypeInline) {
         return ((SymbolTypeInline) type).isSByte();
      } else {
         return false;
      }
   }

   private static boolean isWord(SymbolType type) {
      if (SymbolType.WORD.equals(type)) {
         return true;
      } else if (type instanceof SymbolTypeInline) {
         return ((SymbolTypeInline) type).isWord();
      } else {
         return false;
      }
   }

   private static boolean isSWord(SymbolType type) {
      if (SymbolType.SWORD.equals(type)) {
         return true;
      } else if (type instanceof SymbolTypeInline) {
         return ((SymbolTypeInline) type).isSWord();
      } else {
         return false;
      }
   }


   public static SymbolType inferType(ProgramScope symbols, RValue rValue) {
      SymbolType type = null;
      if (rValue instanceof VariableRef) {
         Variable variable = symbols.getVariable((VariableRef) rValue);
         type = variable.getType();
      } else if (rValue instanceof ConstantRef) {
         ConstantVar constVar = symbols.getConstant((ConstantRef) rValue);
         type = constVar.getType();
      } else if (rValue instanceof Symbol) {
         Symbol rSymbol = (Symbol) rValue;
         type = rSymbol.getType();
      } else if (rValue instanceof ConstantInteger) {
         ConstantInteger rInt = (ConstantInteger) rValue;
         return rInt.getType(symbols);
      } else if (rValue instanceof ConstantString) {
         type = SymbolType.STRING;
      } else if (rValue instanceof ConstantChar) {
         type = SymbolType.BYTE;
      } else if (rValue instanceof ConstantBool) {
         type = SymbolType.BOOLEAN;
      } else if (rValue instanceof ConstantUnary) {
         ConstantUnary constUnary = (ConstantUnary) rValue;
         return inferType(symbols, constUnary.getOperator(), constUnary.getOperand());
      } else if (rValue instanceof ConstantBinary) {
         ConstantBinary constBin = (ConstantBinary) rValue;
         return inferType(symbols, constBin.getLeft(), constBin.getOperator(), constBin.getRight());
      } else if (rValue instanceof ValueArray) {
         type = inferTypeArray(symbols, (ValueArray)rValue);
      } else if (rValue instanceof PointerDereference) {
         SymbolType pointerType = inferType(symbols, ((PointerDereference) rValue).getPointer());
         if (pointerType instanceof SymbolTypePointer) {
            return ((SymbolTypePointer) pointerType).getElementType();
         } else {
            throw new RuntimeException("Cannot infer pointer element type from pointer type " + pointerType);
         }
      }
      if (type == null) {
         throw new RuntimeException("Cannot infer type for " + rValue);
      }
      return type;
   }

   private static SymbolType inferTypeArray(ProgramScope symbols, ValueArray array) {
      SymbolType elmType = null;
      for (RValue elm : array.getList()) {
         SymbolType type = inferType(symbols, elm);
         if(elmType==null) {
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
      if(elmType!=null) {
         return new SymbolTypeArray(elmType);
      } else {
         throw new RuntimeException("Cannot infer array element type "+array.toString());
      }
   }

   public static SymbolType inferTypeRValue(ProgramScope symbols, StatementAssignment assignment) {
      SymbolType rValueType;
      RValue rValue1 = assignment.getrValue1();
      RValue rValue2 = assignment.getrValue2();
      if (assignment.getrValue1() == null && assignment.getOperator() == null) {
         rValueType = inferType(symbols, rValue2);
      } else if (assignment.getrValue1() == null) {
         rValueType = inferType(symbols, assignment.getOperator(), rValue2);
      } else {
         rValueType = inferType(symbols, rValue1, assignment.getOperator(), rValue2);
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
      if (lValueType.equals(rValueType)) {
         // Types match directly
         return true;
      } else if (rValueType instanceof SymbolTypeInline) {
         if(lValueType instanceof SymbolTypeInline) {
            // Both are inline types - RValue type must be superset of LValue
            Collection<SymbolTypeInteger> lValueTypes = ((SymbolTypeInline) lValueType).getTypes();
            Collection<SymbolTypeInteger> rValueTypes = ((SymbolTypeInline) rValueType).getTypes();
            if(rValueTypes.containsAll(lValueTypes)) {
               return true;
            }
         }  else if (((SymbolTypeInline) rValueType).getTypes().contains(lValueType)) {
               // Types match because the right side is a constant that matches the left side
               return true;
         }
      } else if (lValueType instanceof SymbolTypePointer && rValueType instanceof SymbolTypePointer) {
         return typeMatch(((SymbolTypePointer) lValueType).getElementType(), ((SymbolTypePointer) rValueType).getElementType());
      } else if (SymbolType.STRING.equals(rValueType)) {
         if(lValueType instanceof SymbolTypePointer && SymbolType.isByte(((SymbolTypePointer) lValueType).getElementType())) {
            return true;
         }
      }
      return false;
   }
}
