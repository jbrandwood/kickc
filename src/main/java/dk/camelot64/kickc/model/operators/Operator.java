package dk.camelot64.kickc.model.operators;

/**
 * An Operator. The operation performed on the rvalues in a Statement.
 */
public class Operator {

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

   // Constant ASM formatting (AsmFormat)

   public String getOperator() {
      return operator;
   }

   public int getPrecedence() {
      return precedence;
   }

   public enum Type {
      UNARY, BINARY
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

}
