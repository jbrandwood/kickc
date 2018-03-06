package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Program;
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
      StringBuilder txt = new StringBuilder();
      txt.append("asm { ");
      for(KickCParser.AsmLineContext line : asmLines.asmLine()) {
         txt.append(line.getText()).append(" ");
      }
      txt.append(" }");
      return txt.toString();
   }

   public KickCParser.AsmLinesContext getAsmLines() {
      return asmLines;
   }

}
