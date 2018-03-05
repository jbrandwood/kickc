package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorBinary;

/** Binary logic and Operator ( x && y ) */
public class OperatorLogicAnd extends OperatorBinary {

   public OperatorLogicAnd(int precedence) {
      super("&&", "_and_", precedence);
   }

}
