package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;

/** Container for all the expression operators */
public class Operators {

   public static final OperatorUnary INCREMENT = new OperatorIncrement(1);
   public static final OperatorUnary DECREMENT = new OperatorDecrement(1);
   public static final OperatorUnary POS = new OperatorPos(2);
   public static final OperatorUnary NEG = new OperatorNeg(2);
   public static final OperatorUnary BOOL_NOT = new OperatorBitwiseNot(2);
   public static final OperatorUnary LOGIC_NOT = new OperatorLogicNot(2);
   public static final OperatorUnary DEREF = new OperatorDeref(2);
   public static final OperatorUnary ADDRESS_OF = new OperatorAddressOf(2);
   public static final OperatorBinary WORD = new OperatorWord(2);
   public static final OperatorBinary DWORD = new OperatorDWord(2);
   public static final OperatorBinary DEREF_IDX = new OperatorDerefIdx(2);
   public static final OperatorBinary SET_BYTE0 = new OperatorSetByte0(2);
   public static final OperatorBinary SET_BYTE1 = new OperatorSetByte1(2);
   public static final OperatorBinary SET_BYTE2 = new OperatorSetByte2(2);
   public static final OperatorBinary SET_BYTE3 = new OperatorSetByte3(2);
   public static final OperatorBinary SET_WORD0 = new OperatorSetWord0(2);
   public static final OperatorBinary SET_WORD1 = new OperatorSetWord1(2);
   public static final OperatorUnary CAST_BYTE = new OperatorCastByte(2);
   public static final OperatorUnary CAST_SBYTE = new OperatorCastSByte(2);
   public static final OperatorUnary CAST_WORD = new OperatorCastWord(2);
   public static final OperatorUnary CAST_SWORD = new OperatorCastSWord(2);
   public static final OperatorUnary CAST_DWORD = new OperatorCastDWord(2);
   public static final OperatorUnary CAST_SDWORD = new OperatorCastSDWord(2);
   public static final OperatorUnary CAST_BOOL= new OperatorCastBool(2);
   public static final OperatorUnary CAST_UNUMBER = new OperatorCastUNumber(2);
   public static final OperatorUnary CAST_SNUMBER = new OperatorCastSNumber(2);
   public static final OperatorUnary SIZEOF = new OperatorSizeOf(2);
   public static final OperatorUnary TYPEID = new OperatorTypeId(2);
   public static final OperatorBinary MULTIPLY = new OperatorMultiply(3);
   public static final OperatorBinary DIVIDE = new OperatorDivide(3);
   public static final OperatorBinary MODULO = new OperatorModulo(3);
   public static final OperatorBinary PLUS = new OperatorPlus(4);
   public static final OperatorBinary MINUS = new OperatorMinus(4);
   public static final OperatorBinary SHIFT_LEFT = new OperatorShiftLeft(5);
   public static final OperatorBinary SHIFT_RIGHT = new OperatorShiftRight(5);
   public static final OperatorBinary LT = new OperatorLessThan(7);
   public static final OperatorBinary LE = new OperatorLessThanEqual(7);
   public static final OperatorBinary GT = new OperatorGreaterThan(7);
   public static final OperatorBinary GE = new OperatorGreaterThanEqual(7);
   public static final OperatorBinary EQ = new OperatorEqual(8);
   public static final OperatorBinary NEQ = new OperatorNotEqual(8);
   public static final OperatorBinary BOOL_AND = new OperatorBitwiseAnd(9);
   public static final OperatorBinary BOOL_XOR = new OperatorBitwiseXor(10);
   public static final OperatorBinary BOOL_OR = new OperatorBitwiseOr(11);
   public static final OperatorBinary LOGIC_AND = new OperatorLogicAnd(12);
   public static final OperatorBinary LOGIC_OR = new OperatorLogicOr(13);
   public static final OperatorBinary ASSIGNMENT = new OperatorAssignment(14);
   public static final OperatorUnary BYTE0 = new OperatorGetByte0(14);
   public static final OperatorUnary BYTE1 = new OperatorGetByte1(14);
   public static final OperatorUnary BYTE2 = new OperatorGetByte2(14);
   public static final OperatorUnary BYTE3 = new OperatorGetByte3(14);
   public static final OperatorUnary WORD0 = new OperatorGetWord0(14);
   public static final OperatorUnary WORD1 = new OperatorGetWord1(14);

   public static Operator getBinary(String op) {
      switch(op) {
         case "+":
            return PLUS;
         case "-":
            return MINUS;
         case "*":
            return MULTIPLY;
         case "/":
            return DIVIDE;
         case "%":
            return MODULO;
         case "==":
            return EQ;
         case "!=":
            return NEQ;
         case "<":
            return LT;
         case "<=":
            return LE;
         case ">":
            return GT;
         case ">=":
            return GE;
         case "*idx":
            return DEREF_IDX;
         case "&&":
            return LOGIC_AND;
         case "||":
            return LOGIC_OR;
         case "&":
            return BOOL_AND;
         case "|":
            return BOOL_OR;
         case "^":
            return BOOL_XOR;
         case "<<":
            return SHIFT_LEFT;
         case ">>":
            return SHIFT_RIGHT;
         default:
            throw new RuntimeException("Unknown operator " + op);
      }
   }

   /**
    * Get the binary operator to use for a sppecific compound assignment
    * @param operator The compound operator as a string
    * @return The binary operator to use
    */
   public static Operator getBinaryCompound(String operator) {
      return getBinary(operator.substring(0, operator.length()-1));
   }


   public static Operator getUnary(String op) {
      switch(op) {
         case "+":
            return POS;
         case "-":
            return NEG;
         case "++":
            return INCREMENT;
         case "--":
            return DECREMENT;
         case "!":
            return LOGIC_NOT;
         case "~":
            return BOOL_NOT;
         case "*":
            return DEREF;
         case "byte0":
            return BYTE0;
         case "byte1":
            return BYTE1;
         case "byte2":
            return BYTE2;
         case "byte3":
            return BYTE3;
         case "word0":
            return WORD0;
         case "word1":
            return WORD1;
         case "&":
            return ADDRESS_OF;
         default:
            throw new RuntimeException("Unknown operator " + op);
      }
   }

   public static OperatorUnary getCastUnary(SymbolType castType) {
      if(SymbolType.BYTE.equals(castType)) {
         return CAST_BYTE;
      } else if(SymbolType.SBYTE.equals(castType)) {
         return CAST_SBYTE;
      } else if(SymbolType.WORD.equals(castType)) {
         return CAST_WORD;
      } else if(SymbolType.SWORD.equals(castType)) {
         return CAST_SWORD;
      } else if(SymbolType.DWORD.equals(castType)) {
         return CAST_DWORD;
      } else if(SymbolType.SDWORD.equals(castType)) {
         return CAST_SDWORD;
      } else if(SymbolType.UNUMBER.equals(castType)) {
         return CAST_UNUMBER;
      } else if(SymbolType.SNUMBER.equals(castType)) {
         return CAST_SNUMBER;
      } else if(SymbolType.BOOLEAN.equals(castType)) {
         return CAST_BOOL;
      } else if(castType instanceof SymbolTypePointer) {
         return new OperatorCastPtr(CAST_BYTE.getPrecedence(), (SymbolTypePointer) castType);
      } else if(castType instanceof SymbolTypeStruct) {
         return new OperatorCastStruct(CAST_BYTE.getPrecedence(), (SymbolTypeStruct) castType);
      } else {
         throw new RuntimeException("Unknown cast type " + castType);

      }
   }


}
