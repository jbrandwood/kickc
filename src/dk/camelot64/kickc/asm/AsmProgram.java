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

   public void addComment(String comment) {
      addLine(new AsmComment(comment));
   }

   public void addLabel(String label) {
      addLine(new AsmLabel(label));
   }

   public void addInstruction(String mnemonic, AsmAddressingMode addressingMode, String parameter) {
      AsmInstructionType instructionType = AsmInstuctionSet.getInstructionType(mnemonic, addressingMode, parameter);
      addLine(new AsmInstruction(instructionType, parameter, 1));
   }

   public String toString(boolean comments) {
      StringBuffer out = new StringBuffer();
      for (AsmLine line : lines) {
         if(line instanceof AsmComment && !comments) {
            if(!((AsmComment) line).getComment().contains("Fragment")) {
               continue;
            }
         }
         if(line instanceof AsmComment || line instanceof AsmInstruction) {
            out.append("  ");
         }
         out.append(line.getAsm()+"\n");
      }
      return out.toString();
   }

   @Override
   public String toString() {
      return toString(true);
   }

}
