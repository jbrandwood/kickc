package dk.camelot64.kickc.model;

/**
 * The low/high-byte component of a word variable or pointer variable
 */
public class LvalueLoHiByte implements LValue {

   private VariableRef variable;

   /**
    * The lo/hi operator ({@link Operator#LOWBYTE} or {@link Operator#HIBYTE}).
    */
   private Operator operator;

   public LvalueLoHiByte(Operator operator, VariableRef variable) {
      this.variable = variable;
      this.operator = operator;
   }

   public VariableRef getVariable() {
      return variable;
   }

   public Operator getOperator() {
      return operator;
   }

   @Override
   public String toString(Program program) {
      return operator.getOperator() + "(" + variable.toString(program) + ")";
   }

   public void setVariable(VariableRef variable) {
      this.variable = variable;
   }
}
