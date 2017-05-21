package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.icl.NumberParser;

import java.util.ArrayList;
import java.util.List;

/**
 * The set of all 6502 assembler instructions
 */
public class AsmInstuctionSet {

   private static AsmInstuctionSet set = new AsmInstuctionSet();

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
      instructions.add(new AsmInstructionType(opcode, mnemonic.toLowerCase(), addressingmMode, cycles));
   }

   public AsmInstuctionSet() {
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
      add(0x00, "BRK", non, 7.0);
      add(0x01, "ORA", izx, 6.0);
      add(0x01, "ORA", izx, 6.0);
      add(0x02, "KIL", non, 0.0);
      add(0x03, "SLO", izx, 8.0);
      add(0x04, "NOP", zp, 3.0);
      add(0x05, "ORA", zp, 3.0);
      add(0x06, "ASL", zp, 5.0);
      add(0x07, "SLO", zp, 5.0);
      add(0x08, "PHP", non, 3.0);
      add(0x09, "ORA", imm, 2.0);
      add(0x0a, "ASL", non, 2.0);
      add(0x0b, "ANC", imm, 2.0);
      add(0x0c, "NOP", abs, 4.0);
      add(0x0d, "ORA", abs, 4.0);
      add(0x0e, "ASL", abs, 6.0);
      add(0x0f, "SLO", abs, 6.0);
      add(0x10, "BPL", rel, 2.5);
      add(0x11, "ORA", izy, 5.5);
      add(0x12, "KIL", non, 0.0);
      add(0x13, "SLO", izy, 8.0);
      add(0x14, "NOP", zpx, 4.0);
      add(0x15, "ORA", zpx, 4.0);
      add(0x16, "ASL", zpx, 6.0);
      add(0x17, "SLO", zpx, 6.0);
      add(0x18, "CLC", non, 2.0);
      add(0x19, "ORA", aby, 4.5);
      add(0x1a, "NOP", non, 2.0);
      add(0x1b, "SLO", aby, 7.0);
      add(0x1c, "NOP", abx, 4.5);
      add(0x1d, "ORA", abx, 4.5);
      add(0x1e, "ASL", abx, 7.0);
      add(0x1f, "SLO", abx, 7.0);
      add(0x20, "JSR", abs, 6.0);
      add(0x21, "AND", izx, 6.0);
      add(0x22, "KIL", non, 0.0);
      add(0x23, "RLA", izx, 8.0);
      add(0x24, "BIT", zp, 3.0);
      add(0x25, "AND", zp, 3.0);
      add(0x26, "ROL", zp, 5.0);
      add(0x27, "RLA", zp, 5.0);
      add(0x28, "PLP", non, 4.0);
      add(0x29, "AND", imm, 2.0);
      add(0x2a, "ROL", non, 2.0);
      add(0x2b, "ANC", imm, 2.0);
      add(0x2c, "BIT", abs, 4.0);
      add(0x2d, "AND", abs, 4.0);
      add(0x2e, "ROL", abs, 6.0);
      add(0x2f, "RLA", abs, 6.0);
      add(0x30, "BMI", rel, 2.5);
      add(0x31, "AND", izy, 5.5);
      add(0x32, "KIL", non, 0.0);
      add(0x33, "RLA", izy, 8.0);
      add(0x34, "NOP", zpx, 4.0);
      add(0x35, "AND", zpx, 4.0);
      add(0x36, "ROL", zpx, 6.0);
      add(0x37, "RLA", zpx, 6.0);
      add(0x38, "SEC", non, 2.0);
      add(0x39, "AND", aby, 4.5);
      add(0x3a, "NOP", non, 2.0);
      add(0x3b, "RLA", aby, 7.0);
      add(0x3c, "NOP", abx, 4.5);
      add(0x3d, "AND", abx, 4.5);
      add(0x3e, "ROL", abx, 7.0);
      add(0x3f, "RLA", abx, 7.0);
      add(0x40, "RTI", non, 6.0);
      add(0x41, "EOR", izx, 6.0);
      add(0x42, "KIL", non, 0.0);
      add(0x43, "SRE", izx, 8.0);
      add(0x44, "NOP", zp, 3.0);
      add(0x45, "EOR", zp, 3.0);
      add(0x46, "LSR", zp, 5.0);
      add(0x47, "SRE", zp, 5.0);
      add(0x48, "PHA", non, 3.0);
      add(0x49, "EOR", imm, 2.0);
      add(0x4a, "LSR", non, 2.0);
      add(0x4b, "ALR", imm, 2.0);
      add(0x4c, "JMP", abs, 3.0);
      add(0x4d, "EOR", abs, 4.0);
      add(0x4e, "LSR", abs, 6.0);
      add(0x4f, "SRE", abs, 6.0);
      add(0x50, "BVC", rel, 2.5);
      add(0x51, "EOR", izy, 5.5);
      add(0x52, "KIL", non, 0.0);
      add(0x53, "SRE", izy, 8.0);
      add(0x54, "NOP", zpx, 4.0);
      add(0x55, "EOR", zpx, 4.0);
      add(0x56, "LSR", zpx, 6.0);
      add(0x57, "SRE", zpx, 6.0);
      add(0x58, "CLI", non, 2.0);
      add(0x59, "EOR", aby, 4.5);
      add(0x5a, "NOP", non, 2.0);
      add(0x5b, "SRE", aby, 7.0);
      add(0x5c, "NOP", abx, 4.5);
      add(0x5d, "EOR", abx, 4.5);
      add(0x5e, "LSR", abx, 7.0);
      add(0x5f, "SRE", abx, 7.0);
      add(0x60, "RTS", non, 6.0);
      add(0x61, "ADC", izx, 6.0);
      add(0x62, "KIL", non, 0.0);
      add(0x63, "RRA", izx, 8.0);
      add(0x64, "NOP", zp, 3.0);
      add(0x65, "ADC", zp, 3.0);
      add(0x66, "ROR", zp, 5.0);
      add(0x67, "RRA", zp, 5.0);
      add(0x68, "PLA", non, 4.0);
      add(0x69, "ADC", imm, 2.0);
      add(0x6a, "ROR", non, 2.0);
      add(0x6b, "ARR", imm, 2.0);
      add(0x6c, "JMP", ind, 5.0);
      add(0x6d, "ADC", abs, 4.0);
      add(0x6e, "ROR", abs, 6.0);
      add(0x6f, "RRA", abs, 6.0);
      add(0x70, "BVS", rel, 2.5);
      add(0x71, "ADC", izy, 5.5);
      add(0x72, "KIL", non, 0.0);
      add(0x73, "RRA", izy, 8.0);
      add(0x74, "NOP", zpx, 4.0);
      add(0x75, "ADC", zpx, 4.0);
      add(0x76, "ROR", zpx, 6.0);
      add(0x77, "RRA", zpx, 6.0);
      add(0x78, "SEI", non, 2.0);
      add(0x79, "ADC", aby, 4.5);
      add(0x7a, "NOP", non, 2.0);
      add(0x7b, "RRA", aby, 7.0);
      add(0x7c, "NOP", abx, 4.5);
      add(0x7d, "ADC", abx, 4.5);
      add(0x7e, "ROR", abx, 7.0);
      add(0x7f, "RRA", abx, 7.0);
      add(0x80, "NOP", imm, 2.0);
      add(0x81, "STA", izx, 6.0);
      add(0x82, "NOP", imm, 2.0);
      add(0x83, "SAX", izx, 6.0);
      add(0x84, "STY", zp, 3.0);
      add(0x85, "STA", zp, 3.0);
      add(0x86, "STX", zp, 3.0);
      add(0x87, "SAX", zp, 3.0);
      add(0x88, "DEY", non, 2.0);
      add(0x89, "NOP", imm, 2.0);
      add(0x8a, "TXA", non, 2.0);
      add(0x8b, "XAA", imm, 2.0);
      add(0x8c, "STY", abs, 4.0);
      add(0x8d, "STA", abs, 4.0);
      add(0x8e, "STX", abs, 4.0);
      add(0x8f, "SAX", abs, 4.0);
      add(0x90, "BCC", rel, 2.5);
      add(0x91, "STA", izy, 6.0);
      add(0x92, "KIL", non, 0.0);
      add(0x93, "AHX", izy, 6.0);
      add(0x94, "STY", zpx, 4.0);
      add(0x95, "STA", zpx, 4.0);
      add(0x96, "STX", zpy, 4.0);
      add(0x97, "SAX", zpy, 4.0);
      add(0x98, "TYA", non, 2.0);
      add(0x99, "STA", aby, 5.0);
      add(0x9a, "TXS", non, 2.0);
      add(0x9b, "TAS", aby, 5.0);
      add(0x9c, "SHY", abx, 5.0);
      add(0x9d, "STA", abx, 5.0);
      add(0x9e, "SHX", aby, 5.0);
      add(0x9f, "AHX", aby, 5.0);
      add(0xa0, "LDY", imm, 2.0);
      add(0xa1, "LDA", izx, 6.0);
      add(0xa2, "LDX", imm, 2.0);
      add(0xa3, "LAX", izx, 6.0);
      add(0xa4, "LDY", zp, 3.0);
      add(0xa5, "LDA", zp, 3.0);
      add(0xa6, "LDX", zp, 3.0);
      add(0xa7, "LAX", zp, 3.0);
      add(0xa8, "TAY", non, 2.0);
      add(0xa9, "LDA", imm, 2.0);
      add(0xaa, "TAX", non, 2.0);
      add(0xab, "LAX", imm, 2.0);
      add(0xac, "LDY", abs, 4.0);
      add(0xad, "LDA", abs, 4.0);
      add(0xae, "LDX", abs, 4.0);
      add(0xaf, "LAX", abs, 4.0);
      add(0xb0, "BCS", rel, 2.5);
      add(0xb1, "LDA", izy, 5.5);
      add(0xb2, "KIL", non, 0.0);
      add(0xb3, "LAX", izy, 5.5);
      add(0xb4, "LDY", zpx, 4.0);
      add(0xb5, "LDA", zpx, 4.0);
      add(0xb6, "LDX", zpy, 4.0);
      add(0xb7, "LAX", zpy, 4.0);
      add(0xb8, "CLV", non, 2.0);
      add(0xb9, "LDA", aby, 4.5);
      add(0xba, "TSX", non, 2.0);
      add(0xbb, "LAS", aby, 4.5);
      add(0xbc, "LDY", abx, 4.5);
      add(0xbd, "LDA", abx, 4.5);
      add(0xbe, "LDX", aby, 4.5);
      add(0xbf, "LAX", aby, 4.5);
      add(0xc0, "CPY", imm, 2.0);
      add(0xc1, "CMP", izx, 6.0);
      add(0xc2, "NOP", imm, 2.0);
      add(0xc3, "DCP", izx, 8.0);
      add(0xc4, "CPY", zp, 3.0);
      add(0xc5, "CMP", zp, 3.0);
      add(0xc6, "DEC", zp, 5.0);
      add(0xc7, "DCP", zp, 5.0);
      add(0xc8, "INY", non, 2.0);
      add(0xc9, "CMP", imm, 2.0);
      add(0xca, "DEX", non, 2.0);
      add(0xcb, "AXS", imm, 2.0);
      add(0xcc, "CPY", abs, 4.0);
      add(0xcd, "CMP", abs, 4.0);
      add(0xce, "DEC", abs, 6.0);
      add(0xcf, "DCP", abs, 6.0);
      add(0xd0, "BNE", rel, 2.5);
      add(0xd1, "CMP", izy, 5.5);
      add(0xd2, "KIL", non, 0.0);
      add(0xd3, "DCP", izy, 8.0);
      add(0xd4, "NOP", zpx, 4.0);
      add(0xd5, "CMP", zpx, 4.0);
      add(0xd6, "DEC", zpx, 6.0);
      add(0xd7, "DCP", zpx, 6.0);
      add(0xd8, "CLD", non, 2.0);
      add(0xd9, "CMP", aby, 4.5);
      add(0xda, "NOP", non, 2.0);
      add(0xdb, "DCP", aby, 7.0);
      add(0xdc, "NOP", abx, 4.5);
      add(0xdd, "CMP", abx, 4.5);
      add(0xde, "DEC", abx, 7.0);
      add(0xef, "CPX", imm, 2.0);
      add(0xe0, "SBC", izx, 6.0);
      add(0xe1, "NOP", imm, 2.0);
      add(0xe2, "ISC", izx, 8.0);
      add(0xe3, "CPX", zp, 3.0);
      add(0xe4, "SBC", zp, 3.0);
      add(0xe5, "INC", zp, 5.0);
      add(0xe6, "ISC", zp, 5.0);
      add(0xe7, "INX", non, 2.0);
      add(0xe8, "SBC", imm, 2.0);
      add(0xe9, "NOP", non, 2.0);
      add(0xea, "SBC", imm, 2.0);
      add(0xeb, "CPX", abs, 4.0);
      add(0xec, "SBC", abs, 4.0);
      add(0xed, "INC", abs, 6.0);
      add(0xee, "ISC", abs, 6.0);
      add(0xef, "DCP", abx, 7.0);
      add(0xf0, "BEQ", rel, 2.5);
      add(0xf1, "SBC", izy, 5.5);
      add(0xf2, "KIL", non, 0.0);
      add(0xf3, "ISC", izy, 8.0);
      add(0xf4, "NOP", zpx, 4.0);
      add(0xf5, "SBC", zpx, 4.0);
      add(0xf6, "INC", zpx, 6.0);
      add(0xf7, "ISC", zpx, 6.0);
      add(0xf8, "SED", non, 2.0);
      add(0xf9, "SBC", aby, 4.5);
      add(0xfa, "NOP", non, 2.0);
      add(0xfb, "ISC", aby, 7.0);
      add(0xfc, "NOP", abx, 4.5);
      add(0xfd, "SBC", abx, 4.5);
      add(0xfe, "INC", abx, 7.0);
      add(0xff, "ISC", abx, 7.0);
      for (AsmInstructionType instruction : instructions) {
         switch(instruction.getMnemnonic()) {
            case "jmp":
            case "beq":
            case "bne":
            case "bcc":
            case "bcs":
            case "bvc":
            case "bvs":
            case "bmi":
            case "bpl":
               instruction.setJump(true);
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
