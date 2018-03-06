package dk.camelot64.kickc.model.operators;

/** Binary greater-than Operator ( x > y ) */
public class OperatorGreaterThan extends OperatorBinary {

   public OperatorGreaterThan(int precedence) {
      super(">", "_gt_", precedence);
   }

}
