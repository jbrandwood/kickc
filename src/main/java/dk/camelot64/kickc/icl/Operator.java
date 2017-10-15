package dk.camelot64.kickc.icl;

/** An Operator. The operation performed on the rvalues in a Statement. */
public class Operator {

   private String operator;

   private int precedence;

   private Type type;

   public Operator(String operator, Type type, int precedence) {
      this.operator = operator;
      this.precedence = precedence;
      this.type = type;
   }

   public static Operator getBinary(String op) {
      switch (op) {
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
            return STAR_IDX;
         default:
            throw new RuntimeException("Unknown operator " + op);
      }
   }

   public static Operator getUnary(String op) {
      switch (op) {
         case "+":
            return UNARY_PLUS;
         case "-":
            return UNARY_MINUS;
         case "++":
            return INCREMENT;
         case "--":
            return DECREMENT;
         case "!":
            return NOT;
         case "*":
            return STAR;
         default:
            throw new RuntimeException("Unknown operator " + op);
      }
   }

   public static enum Type {
      UNARY, BINARY
   }

   public static Operator INCREMENT = new Operator("++", Type.UNARY, 1);
   public static Operator DECREMENT = new Operator("--", Type.UNARY, 1);
   public static Operator UNARY_PLUS = new Operator("+", Type.UNARY, 2);
   public static Operator UNARY_MINUS = new Operator("-", Type.UNARY, 2);
   public static Operator NOT = new Operator("!", Type.UNARY, 2);
   public static Operator STAR = new Operator("*", Type.UNARY, 2);
   public static Operator STAR_IDX = new Operator("*idx", Type.BINARY, 2);
   public static Operator MULTIPLY = new Operator("*", Type.BINARY, 3);
   public static Operator DIVIDE = new Operator("/", Type.BINARY, 3);
   public static Operator PLUS = new Operator("+", Type.BINARY, 4);
   public static Operator MINUS = new Operator("-", Type.BINARY, 4);
   public static Operator LT = new Operator("<", Type.BINARY, 6);
   public static Operator LE = new Operator("<=", Type.BINARY, 6);
   public static Operator GT = new Operator(">", Type.BINARY, 6);
   public static Operator GE = new Operator(">=", Type.BINARY, 6);
   public static Operator EQ = new Operator("==", Type.BINARY, 7);
   public static Operator NEQ = new Operator("!=", Type.BINARY, 7);

   public String getOperator() {
      return operator;
   }

   public int getPrecedence() {
      return precedence;
   }

   @Override
   public String toString() {
      return operator;
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;
      Operator operator1 = (Operator) o;
      if (precedence != operator1.precedence) return false;
      if (!operator.equals(operator1.operator)) return false;
      return type == operator1.type;
   }

   @Override
   public int hashCode() {
      int result = operator.hashCode();
      result = 31 * result + precedence;
      result = 31 * result + type.hashCode();
      return result;
   }

}
