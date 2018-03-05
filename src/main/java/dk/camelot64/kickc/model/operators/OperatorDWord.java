package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.OperatorBinary;

/** Binary DWord Constructor operator (w dw= w) */
public class OperatorDWord extends OperatorBinary {

   public OperatorDWord(int precedence) {
      super("dw=", "_dword_", precedence);
   }

}
