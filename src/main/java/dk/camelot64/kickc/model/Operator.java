package dk.camelot64.kickc.model;

/**
 * An Operator. The operation performed on the rvalues in a Statement.
 */
public class Operator {

   public static final Operator INCREMENT = new Operator("++", "_inc_", Type.UNARY, 1);
   public static final Operator DECREMENT = new Operator("--", "_dec_", Type.UNARY, 1);
   public static final Operator POS = new Operator("+", "_pos_", Type.UNARY, 2);
   public static final Operator NEG = new Operator("-", "_neg_", Type.UNARY, 2);
   public static final Operator BOOL_NOT = new Operator("~", "_not_", Type.UNARY, 2);
   public static final Operator LOGIC_NOT = new Operator("!", "_not_", Type.UNARY, 2);
   public static final Operator DEREF = new Operator("*", "_deref_", Type.UNARY, 2);
   public static final Operator ADDRESS_OF = new Operator("&", "_addr_", Type.UNARY, 2);
   public static final Operator WORD = new Operator("w=", "_word_", Type.BINARY, 2);
   public static final Operator DEREF_IDX = new Operator("*idx", "_derefidx_", Type.BINARY, 2);
   public static final Operator SET_LOWBYTE = new Operator("lo=", "_setlo_", Type.BINARY, 2);
   public static final Operator SET_HIBYTE = new Operator("hi=", "_sethi_", Type.BINARY, 2);
   public static final Operator CAST_BYTE = new Operator("((byte))", "_byte_", Type.UNARY, 2);
   public static final Operator CAST_SBYTE = new Operator("((signed byte))", "_sbyte_", Type.UNARY, 2);
   public static final Operator CAST_WORD = new Operator("((word))", "_word_", Type.UNARY, 2);
   public static final Operator CAST_SWORD = new Operator("((signed word))", "_sword_", Type.UNARY, 2);
   public static final Operator CAST_DWORD = new Operator("((dword))", "_dword_", Type.UNARY, 2);
   public static final Operator CAST_SDWORD = new Operator("((signed dword))", "_sdword_", Type.UNARY, 2);
   public static final Operator CAST_PTRBY = new Operator("((byte*))", "_ptrby_", Type.UNARY, 2);
   public static final Operator MULTIPLY = new Operator("*", "_mul_", Type.BINARY, 3);
   public static final Operator DIVIDE = new Operator("/", "_div_", Type.BINARY, 3);
   public static final Operator PLUS = new Operator("+", "_plus_", Type.BINARY, 4);
   public static final Operator MINUS = new Operator("-", "_minus_", Type.BINARY, 4);
   public static final Operator SHIFT_LEFT = new Operator("<<", "_rol_", Type.BINARY, 5);
   public static final Operator SHIFT_RIGHT = new Operator(">>", "_ror_", Type.BINARY, 5);
   public static final Operator LOWBYTE = new Operator("<", "_lo_", Type.UNARY, 6);
   public static final Operator HIBYTE = new Operator(">", "_hi_", Type.UNARY, 6);
   public static final Operator LT = new Operator("<", "_lt_", Type.BINARY, 7);
   public static final Operator LE = new Operator("<=", "_le_", Type.BINARY, 7);
   public static final Operator GT = new Operator(">", "_gt_", Type.BINARY, 7);
   public static final Operator GE = new Operator(">=", "_ge_", Type.BINARY, 7);
   public static final Operator EQ = new Operator("==", "_eq_", Type.BINARY, 8);
   public static final Operator NEQ = new Operator("!=", "_neq_", Type.BINARY, 8);
   public static final Operator BOOL_AND = new Operator("&", "_band_", Type.BINARY, 9);
   public static final Operator BOOL_XOR = new Operator("^", "_bxor_", Type.BINARY, 10);
   public static final Operator BOOL_OR = new Operator("|", "_bor_", Type.BINARY, 11);
   public static final Operator LOGIC_AND = new Operator("&&", "_and_", Type.BINARY, 12);
   public static final Operator LOGIC_OR = new Operator("||", "_or_", Type.BINARY, 13);
   private String operator;
   private int precedence;
   private Type type;
   private String asmOperator;
   public Operator(String operator, String asmOperator, Type type, int precedence) {
      this.operator = operator;
      this.precedence = precedence;
      this.type = type;
      this.asmOperator = asmOperator;
   }

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

   public String getOperator() {
      return operator;
   }

   public int getPrecedence() {
      return precedence;
   }

   public Type getType() {
      return type;
   }

   public String getAsmOperator() {
      return asmOperator;
   }

   @Override
   public String toString() {
      return operator;
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      Operator operator1 = (Operator) o;
      if(precedence != operator1.precedence) return false;
      if(!operator.equals(operator1.operator)) return false;
      return type == operator1.type;
   }

   @Override
   public int hashCode() {
      int result = operator.hashCode();
      result = 31 * result + precedence;
      result = 31 * result + type.hashCode();
      return result;
   }

   public enum Type {
      UNARY, BINARY
   }

}
