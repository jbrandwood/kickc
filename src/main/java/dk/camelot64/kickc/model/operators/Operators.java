package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;

/** Constainer for all the expression operators */
public class Operators {

   public static final Operator INCREMENT = new OperatorIncrement(1);
   public static final Operator DECREMENT = new OperatorDecrement(1);
   public static final Operator POS = new OperatorPos(2);
   public static final Operator NEG = new OperatorNeg(2);
   public static final Operator BOOL_NOT = new OperatorBoolNot(2);
   public static final Operator LOGIC_NOT = new OperatorLogicNot(2);
   public static final Operator DEREF = new OperatorDeref(2);
   public static final Operator ADDRESS_OF = new OperatorAddressOf(2);
   public static final Operator WORD = new OperatorWord(2);
   public static final Operator DWORD = new OperatorDWord(2);
   public static final Operator DEREF_IDX = new OperatorDerefIdx(2);
   public static final Operator SET_LOWBYTE = new OperatorSetLow(2);
   public static final Operator SET_HIBYTE = new OperatorSetHigh(2);
   public static final Operator CAST_BYTE = new OperatorCastByte(2);
   public static final Operator CAST_SBYTE = new OperatorCastSByte(2);
   public static final Operator CAST_WORD = new OperatorCastWord(2);
   public static final Operator CAST_SWORD = new OperatorCastSWord(2);
   public static final Operator CAST_DWORD = new OperatorCastDWord(2);
   public static final Operator CAST_SDWORD = new OperatorCastSDWord(2);
   public static final Operator CAST_PTRBY = new OperatorCastPtrByte(2);
   public static final Operator MULTIPLY = new OperatorMultiply(3);
   public static final Operator DIVIDE = new OperatorDivide(3);
   public static final Operator PLUS = new OperatorPlus(4);
   public static final Operator MINUS = new OperatorMinus(4);
   public static final Operator SHIFT_LEFT = new OperatorShiftLeft(5);
   public static final Operator SHIFT_RIGHT = new OperatorShiftRight(5);
   public static final Operator LOWBYTE = new OperatorGetLow(6);
   public static final Operator HIBYTE = new OperatorGetHigh(6);
   public static final Operator LT = new OperatorLessThan(7);
   public static final Operator LE = new OperatorLessThanEqual(7);
   public static final Operator GT = new OperatorGreaterThan(7);
   public static final Operator GE = new OperatorGreaterThanEqual(7);
   public static final Operator EQ = new OperatorEqual(8);
   public static final Operator NEQ = new OperatorNotEqual(8);
   public static final Operator BOOL_AND = new OperatorBoolAnd(9);
   public static final Operator BOOL_XOR = new OperatorBoolXor(10);
   public static final Operator BOOL_OR = new OperatorBoolOr(11);
   public static final Operator LOGIC_AND = new OperatorLogicAnd(12);
   public static final Operator LOGIC_OR = new OperatorLogicOr(13);

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
         case "lo=":
            return SET_LOWBYTE;
         case "hi=":
            return SET_HIBYTE;
         default:
            throw new RuntimeException("Unknown operator " + op);
      }
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
         case "<":
            return LOWBYTE;
         case ">":
            return HIBYTE;
         case "&":
            return ADDRESS_OF;
         default:
            throw new RuntimeException("Unknown operator " + op);
      }
   }

   public static Operator getCastUnary(SymbolType castType) {
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
      } else if(castType instanceof SymbolTypePointer && SymbolType.BYTE.equals(((SymbolTypePointer) castType).getElementType())) {
         return CAST_PTRBY;
      } else {
         throw new RuntimeException("Unknown cast type " + castType);

      }
   }
}
