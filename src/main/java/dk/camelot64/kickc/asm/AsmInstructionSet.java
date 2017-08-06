package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.NumberParser;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * The set of all 6502 assembler instructions
 */
public class AsmInstructionSet {

   private static AsmInstructionSet set = new AsmInstructionSet();

   public static AsmInstructionType getInstructionType(String mnemonic, AsmAddressingMode mode, String parameter) {
      AsmInstructionType type = null;
      if (AsmAddressingMode.ABS.equals(mode) && isZp(parameter)) {
         type = set.getType(mnemonic, AsmAddressingMode.ZP);
      }
      if (AsmAddressingMode.ABX.equals(mode) && isZp(parameter)) {
         type = set.getType(mnemonic, AsmAddressingMode.ZPX);
      }
      if (AsmAddressingMode.ABY.equals(mode) && isZp(parameter)) {
         type = set.getType(mnemonic, AsmAddressingMode.ZPY);
      }
      if (type == null) {
         type = set.getType(mnemonic, mode);
      }
      if (type == null && AsmAddressingMode.ABS.equals(mode)) {
         type = set.getType(mnemonic, AsmAddressingMode.REL);
      }
      return type;
   }

   private static boolean isZp(String parameter) {
      Number number = null;
      if(parameter!=null) {
         try {
            number = NumberParser.parseLiteral(parameter);
         } catch (NumberFormatException e) {
            // ignore
         }
      }
      return (number != null && number.intValue()<256 && number.intValue()>=0);
   }


   private List<AsmInstructionType> instructions;

   private void add(int opcode, String mnemonic, AsmAddressingMode addressingmMode, double cycles) {
      instructions.add(new AsmInstructionType(opcode, mnemonic, addressingmMode, cycles));
   }

   public AsmInstructionSet() {
      this.instructions = new ArrayList<>();
      AsmAddressingMode non = AsmAddressingMode.NON;
      AsmAddressingMode zp = AsmAddressingMode.ZP;
      AsmAddressingMode zpx = AsmAddressingMode.ZPX;
      AsmAddressingMode zpy = AsmAddressingMode.ZPY;
      AsmAddressingMode imm = AsmAddressingMode.IMM;
      AsmAddressingMode abs = AsmAddressingMode.ABS;
      AsmAddressingMode abx = AsmAddressingMode.ABX;
      AsmAddressingMode aby = AsmAddressingMode.ABY;
      AsmAddressingMode izx = AsmAddressingMode.IZX;
      AsmAddressingMode izy = AsmAddressingMode.IZY;
      AsmAddressingMode rel = AsmAddressingMode.REL;
      AsmAddressingMode ind = AsmAddressingMode.IND;
      add(0x00, "brk", non, 7.0);
      add(0x01, "ora", izx, 6.0);
      add(0x01, "ora", izx, 6.0);
      add(0x02, "kil", non, 0.0);
      add(0x03, "slo", izx, 8.0);
      add(0x04, "nop", zp, 3.0);
      add(0x05, "ora", zp, 3.0);
      add(0x06, "asl", zp, 5.0);
      add(0x07, "slo", zp, 5.0);
      add(0x08, "php", non, 3.0);
      add(0x09, "ora", imm, 2.0);
      add(0x0a, "asl", non, 2.0);
      add(0x0b, "anc", imm, 2.0);
      add(0x0c, "nop", abs, 4.0);
      add(0x0d, "ora", abs, 4.0);
      add(0x0e, "asl", abs, 6.0);
      add(0x0f, "slo", abs, 6.0);
      add(0x10, "bpl", rel, 2.5);
      add(0x11, "ora", izy, 5.5);
      add(0x12, "kil", non, 0.0);
      add(0x13, "slo", izy, 8.0);
      add(0x14, "nop", zpx, 4.0);
      add(0x15, "ora", zpx, 4.0);
      add(0x16, "asl", zpx, 6.0);
      add(0x17, "slo", zpx, 6.0);
      add(0x18, "clc", non, 2.0);
      add(0x19, "ora", aby, 4.5);
      add(0x1a, "nop", non, 2.0);
      add(0x1b, "slo", aby, 7.0);
      add(0x1c, "nop", abx, 4.5);
      add(0x1d, "ora", abx, 4.5);
      add(0x1e, "asl", abx, 7.0);
      add(0x1f, "slo", abx, 7.0);
      add(0x20, "jsr", abs, 6.0);
      add(0x21, "and", izx, 6.0);
      add(0x22, "kil", non, 0.0);
      add(0x23, "rla", izx, 8.0);
      add(0x24, "bit", zp, 3.0);
      add(0x25, "and", zp, 3.0);
      add(0x26, "rol", zp, 5.0);
      add(0x27, "rla", zp, 5.0);
      add(0x28, "plp", non, 4.0);
      add(0x29, "and", imm, 2.0);
      add(0x2a, "rol", non, 2.0);
      add(0x2b, "anc", imm, 2.0);
      add(0x2c, "bit", abs, 4.0);
      add(0x2d, "and", abs, 4.0);
      add(0x2e, "rol", abs, 6.0);
      add(0x2f, "rla", abs, 6.0);
      add(0x30, "bmi", rel, 2.5);
      add(0x31, "and", izy, 5.5);
      add(0x32, "kil", non, 0.0);
      add(0x33, "rla", izy, 8.0);
      add(0x34, "nop", zpx, 4.0);
      add(0x35, "and", zpx, 4.0);
      add(0x36, "rol", zpx, 6.0);
      add(0x37, "rla", zpx, 6.0);
      add(0x38, "sec", non, 2.0);
      add(0x39, "and", aby, 4.5);
      add(0x3a, "nop", non, 2.0);
      add(0x3b, "rla", aby, 7.0);
      add(0x3c, "nop", abx, 4.5);
      add(0x3d, "and", abx, 4.5);
      add(0x3e, "rol", abx, 7.0);
      add(0x3f, "rla", abx, 7.0);
      add(0x40, "rti", non, 6.0);
      add(0x41, "eor", izx, 6.0);
      add(0x42, "kil", non, 0.0);
      add(0x43, "sre", izx, 8.0);
      add(0x44, "nop", zp, 3.0);
      add(0x45, "eor", zp, 3.0);
      add(0x46, "lsr", zp, 5.0);
      add(0x47, "sre", zp, 5.0);
      add(0x48, "pha", non, 3.0);
      add(0x49, "eor", imm, 2.0);
      add(0x4a, "lsr", non, 2.0);
      add(0x4b, "alr", imm, 2.0);
      add(0x4c, "jmp", abs, 3.0);
      add(0x4d, "eor", abs, 4.0);
      add(0x4e, "lsr", abs, 6.0);
      add(0x4f, "sre", abs, 6.0);
      add(0x50, "bvc", rel, 2.5);
      add(0x51, "eor", izy, 5.5);
      add(0x52, "kil", non, 0.0);
      add(0x53, "sre", izy, 8.0);
      add(0x54, "nop", zpx, 4.0);
      add(0x55, "eor", zpx, 4.0);
      add(0x56, "lsr", zpx, 6.0);
      add(0x57, "sre", zpx, 6.0);
      add(0x58, "cli", non, 2.0);
      add(0x59, "eor", aby, 4.5);
      add(0x5a, "nop", non, 2.0);
      add(0x5b, "sre", aby, 7.0);
      add(0x5c, "nop", abx, 4.5);
      add(0x5d, "eor", abx, 4.5);
      add(0x5e, "lsr", abx, 7.0);
      add(0x5f, "sre", abx, 7.0);
      add(0x60, "rts", non, 6.0);
      add(0x61, "adc", izx, 6.0);
      add(0x62, "kil", non, 0.0);
      add(0x63, "rra", izx, 8.0);
      add(0x64, "nop", zp, 3.0);
      add(0x65, "adc", zp, 3.0);
      add(0x66, "ror", zp, 5.0);
      add(0x67, "rra", zp, 5.0);
      add(0x68, "pla", non, 4.0);
      add(0x69, "adc", imm, 2.0);
      add(0x6a, "ror", non, 2.0);
      add(0x6b, "arr", imm, 2.0);
      add(0x6c, "jmp", ind, 5.0);
      add(0x6d, "adc", abs, 4.0);
      add(0x6e, "ror", abs, 6.0);
      add(0x6f, "rra", abs, 6.0);
      add(0x70, "bvs", rel, 2.5);
      add(0x71, "adc", izy, 5.5);
      add(0x72, "kil", non, 0.0);
      add(0x73, "rra", izy, 8.0);
      add(0x74, "nop", zpx, 4.0);
      add(0x75, "adc", zpx, 4.0);
      add(0x76, "ror", zpx, 6.0);
      add(0x77, "rra", zpx, 6.0);
      add(0x78, "sei", non, 2.0);
      add(0x79, "adc", aby, 4.5);
      add(0x7a, "nop", non, 2.0);
      add(0x7b, "rra", aby, 7.0);
      add(0x7c, "nop", abx, 4.5);
      add(0x7d, "adc", abx, 4.5);
      add(0x7e, "ror", abx, 7.0);
      add(0x7f, "rra", abx, 7.0);
      add(0x80, "nop", imm, 2.0);
      add(0x81, "sta", izx, 6.0);
      add(0x82, "nop", imm, 2.0);
      add(0x83, "sax", izx, 6.0);
      add(0x84, "sty", zp, 3.0);
      add(0x85, "sta", zp, 3.0);
      add(0x86, "stx", zp, 3.0);
      add(0x87, "sax", zp, 3.0);
      add(0x88, "dey", non, 2.0);
      add(0x89, "nop", imm, 2.0);
      add(0x8a, "txa", non, 2.0);
      add(0x8b, "xaa", imm, 2.0);
      add(0x8c, "sty", abs, 4.0);
      add(0x8d, "sta", abs, 4.0);
      add(0x8e, "stx", abs, 4.0);
      add(0x8f, "sax", abs, 4.0);
      add(0x90, "bcc", rel, 2.5);
      add(0x91, "sta", izy, 6.0);
      add(0x92, "kil", non, 0.0);
      add(0x93, "ahx", izy, 6.0);
      add(0x94, "sty", zpx, 4.0);
      add(0x95, "sta", zpx, 4.0);
      add(0x96, "stx", zpy, 4.0);
      add(0x97, "sax", zpy, 4.0);
      add(0x98, "tya", non, 2.0);
      add(0x99, "sta", aby, 5.0);
      add(0x9a, "txs", non, 2.0);
      add(0x9b, "tas", aby, 5.0);
      add(0x9c, "shy", abx, 5.0);
      add(0x9d, "sta", abx, 5.0);
      add(0x9e, "shx", aby, 5.0);
      add(0x9f, "ahx", aby, 5.0);
      add(0xa0, "ldy", imm, 2.0);
      add(0xa1, "lda", izx, 6.0);
      add(0xa2, "ldx", imm, 2.0);
      add(0xa3, "lax", izx, 6.0);
      add(0xa4, "ldy", zp, 3.0);
      add(0xa5, "lda", zp, 3.0);
      add(0xa6, "ldx", zp, 3.0);
      add(0xa7, "lax", zp, 3.0);
      add(0xa8, "tay", non, 2.0);
      add(0xa9, "lda", imm, 2.0);
      add(0xaa, "tax", non, 2.0);
      add(0xab, "lax", imm, 2.0);
      add(0xac, "ldy", abs, 4.0);
      add(0xad, "lda", abs, 4.0);
      add(0xae, "ldx", abs, 4.0);
      add(0xaf, "lax", abs, 4.0);
      add(0xb0, "bcs", rel, 2.5);
      add(0xb1, "lda", izy, 5.5);
      add(0xb2, "kil", non, 0.0);
      add(0xb3, "lax", izy, 5.5);
      add(0xb4, "ldy", zpx, 4.0);
      add(0xb5, "lda", zpx, 4.0);
      add(0xb6, "ldx", zpy, 4.0);
      add(0xb7, "lax", zpy, 4.0);
      add(0xb8, "clv", non, 2.0);
      add(0xb9, "lda", aby, 4.5);
      add(0xba, "tsx", non, 2.0);
      add(0xbb, "las", aby, 4.5);
      add(0xbc, "ldy", abx, 4.5);
      add(0xbd, "lda", abx, 4.5);
      add(0xbe, "ldx", aby, 4.5);
      add(0xbf, "lax", aby, 4.5);
      add(0xc0, "cpy", imm, 2.0);
      add(0xc1, "cmp", izx, 6.0);
      add(0xc2, "nop", imm, 2.0);
      add(0xc3, "dcp", izx, 8.0);
      add(0xc4, "cpy", zp, 3.0);
      add(0xc5, "cmp", zp, 3.0);
      add(0xc6, "dec", zp, 5.0);
      add(0xc7, "dcp", zp, 5.0);
      add(0xc8, "iny", non, 2.0);
      add(0xc9, "cmp", imm, 2.0);
      add(0xca, "dex", non, 2.0);
      add(0xcb, "axs", imm, 2.0);
      add(0xcc, "cpy", abs, 4.0);
      add(0xcd, "cmp", abs, 4.0);
      add(0xce, "dec", abs, 6.0);
      add(0xcf, "dcp", abs, 6.0);
      add(0xd0, "bne", rel, 2.5);
      add(0xd1, "cmp", izy, 5.5);
      add(0xd2, "kil", non, 0.0);
      add(0xd3, "dcp", izy, 8.0);
      add(0xd4, "nop", zpx, 4.0);
      add(0xd5, "cmp", zpx, 4.0);
      add(0xd6, "dec", zpx, 6.0);
      add(0xd7, "dcp", zpx, 6.0);
      add(0xd8, "cld", non, 2.0);
      add(0xd9, "cmp", aby, 4.5);
      add(0xda, "nop", non, 2.0);
      add(0xdb, "dcp", aby, 7.0);
      add(0xdc, "nop", abx, 4.5);
      add(0xdd, "cmp", abx, 4.5);
      add(0xde, "dec", abx, 7.0);
      add(0xef, "cpx", imm, 2.0);
      add(0xe0, "sbc", izx, 6.0);
      add(0xe1, "nop", imm, 2.0);
      add(0xe2, "isc", izx, 8.0);
      add(0xe3, "cpx", zp, 3.0);
      add(0xe4, "sbc", zp, 3.0);
      add(0xe5, "inc", zp, 5.0);
      add(0xe6, "isc", zp, 5.0);
      add(0xe7, "inx", non, 2.0);
      add(0xe8, "sbc", imm, 2.0);
      add(0xe9, "nop", non, 2.0);
      add(0xea, "sbc", imm, 2.0);
      add(0xeb, "cpx", abs, 4.0);
      add(0xec, "sbc", abs, 4.0);
      add(0xed, "inc", abs, 6.0);
      add(0xee, "isc", abs, 6.0);
      add(0xef, "dcp", abx, 7.0);
      add(0xf0, "beq", rel, 2.5);
      add(0xf1, "sbc", izy, 5.5);
      add(0xf2, "kil", non, 0.0);
      add(0xf3, "isc", izy, 8.0);
      add(0xf4, "nop", zpx, 4.0);
      add(0xf5, "sbc", zpx, 4.0);
      add(0xf6, "inc", zpx, 6.0);
      add(0xf7, "isc", zpx, 6.0);
      add(0xf8, "sed", non, 2.0);
      add(0xf9, "sbc", aby, 4.5);
      add(0xfa, "nop", non, 2.0);
      add(0xfb, "isc", aby, 7.0);
      add(0xfc, "nop", abx, 4.5);
      add(0xfd, "sbc", abx, 4.5);
      add(0xfe, "inc", abx, 7.0);
      add(0xff, "isc", abx, 7.0);
      List<String> jumps = Arrays.asList("jmp", "beq", "bne", "bcc", "bcs", "bvs", "bvc", "bmi", "bpl");
      for (AsmInstructionType instruction : instructions) {
         if(jumps.contains(instruction.getMnemnonic())) {
            instruction.setJump(true);
         }
      }
      List<String> cxs = Arrays.asList("dex", "inx",  "ldx", "tax", "tsx", "las", "lax", "axs");
      for (AsmInstructionType instruction : instructions) {
         if(cxs.contains(instruction.getMnemnonic())) {
            instruction.getClobber().setClobberX(true);
         }
      }
      List<String> cys = Arrays.asList("dey", "iny", "ldy", "tay" );
      for (AsmInstructionType instruction : instructions) {
         if(cys.contains(instruction.getMnemnonic())) {
            instruction.getClobber().setClobberY(true);
         }
      }
      List<String> cas = Arrays.asList("ora", "and", "eor", "adc", "sbc", "lda", "txa", "tya", "pla", "slo", "rla", "sre", "rra", "isc", "anc", "alr", "arr", "xaa", "lax", "las");
      for (AsmInstructionType instruction : instructions) {
         if(cas.contains(instruction.getMnemnonic())) {
            instruction.getClobber().setClobberA(true);
         }
      }
      List<String> ccs = Arrays.asList("adc", "sbc", "cmp", "cpx", "cpy", "asl", "rol", "lsr", "ror", "plp", "rti", "clc", "sec", "slo", "rla", "sre", "rra", "dcp", "isc", "anc", "alr", "arr", "axs");
      for (AsmInstructionType instruction : instructions) {
         if(ccs.contains(instruction.getMnemnonic())) {
            instruction.getClobber().setClobberC(true);
         }
      }
      List<String> cvs = Arrays.asList("adc", "sbc", "plp", "rti", "bit", "rra", "isc", "arr");
      for (AsmInstructionType instruction : instructions) {
         if(cvs.contains(instruction.getMnemnonic())) {
            instruction.getClobber().setClobberV(true);
         }
      }
      List<String> czs = Arrays.asList("ora", "and", "eor", "adc", "sbc", "cmp", "cpx", "cpy", "dec", "dex", "dey", "inc", "inx", "iny", "asl", "rol", "lsr", "ror", "lda", "ldx", "ldy", "tax", "txa", "tay", "tya", "tsx", "txs", "pla", "plp", "rti", "bit", "slo", "rla", "sre", "rra", "lax", "dcp", "isc", "anc", "alr", "arr", "xaa", "lax", "axs", "las");
      for (AsmInstructionType instruction : instructions) {
         if(czs.contains(instruction.getMnemnonic())) {
            instruction.getClobber().setClobberZ(true);
            instruction.getClobber().setClobberN(true);
         }
      }
   }

   public AsmInstructionType getType(String mnemonic, AsmAddressingMode addressingMode) {
      for (AsmInstructionType candidate : instructions) {
         if (candidate.getMnemnonic().equals(mnemonic.toLowerCase()) && candidate.getAddressingMode().equals(addressingMode)) {
            return candidate;
         }
      }
      return null;
   }

}
