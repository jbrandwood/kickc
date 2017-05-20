package dk.camelot64.kickc.asm;

import java.util.ArrayList;
import java.util.List;

/** A 6502 assembler program */
public class AsmProgram {

   private List<AsmLine> lines;

   public AsmProgram() {
      this.lines = new ArrayList<>();
   }

   public List<AsmLine> getLines() {
      return lines;
   }

   public void addLine(AsmLine line) {
      lines.add(line);
   }
}
