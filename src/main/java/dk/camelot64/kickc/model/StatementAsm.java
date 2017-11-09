package dk.camelot64.kickc.model;

import dk.camelot64.kickc.parser.KickCParser;

/** Inline ASM code */
public class StatementAsm extends StatementBase {

   /** ASM Fragment code. */
   private KickCParser.AsmLinesContext asmLines;

   public StatementAsm(KickCParser.AsmLinesContext asmLines) {
      super(null);
      this.asmLines = asmLines;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      return "asm { "+asmLines.getText()+" }";
   }

   public KickCParser.AsmLinesContext getAsmLines() {
      return asmLines;
   }

}
