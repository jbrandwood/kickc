package dk.camelot64.kickc.model.operators;

/** Binary Pointer Dereference with an index Operator ( p[i] / *(p+i) ) */
public class OperatorDerefIdx extends OperatorBinary {

   public OperatorDerefIdx(int precedence) {
      super("*idx=", "_derefidx_", precedence);
   }

}
