package dk.camelot64.cpufamily6502;

import java.util.*;

/**
 * The set of all 6502 assembler instructions
 */
public class AsmInstructionSet {

   private static AsmInstructionSet set = new AsmInstructionSet();

   /** All instructions in the instruction set. */
   private List<AsmOpcode> instructions;

   /** Maps mnemonic_addressingMode to the instruction opcode information */
   private Map<String, AsmOpcode> instructionsMap;

   public AsmInstructionSet() {
      this.instructions = new ArrayList<>();
      this.instructionsMap = new HashMap<>();
      add(0x00, "brk", AsmAddressingMode.NON, 7.0, "");
      add(0x01, "ora", AsmAddressingMode.IZX, 6.0, "Azn");
      add(0x01, "ora", AsmAddressingMode.IZX, 6.0, "Azn");
      add(0x02, "kil", AsmAddressingMode.NON, 0.0, "");
      add(0x03, "slo", AsmAddressingMode.IZX, 8.0, "Aczn");
      add(0x04, "nop", AsmAddressingMode.ZP, 3.0, "");
      add(0x05, "ora", AsmAddressingMode.ZP, 3.0, "Azn");
      add(0x06, "asl", AsmAddressingMode.ZP, 5.0, "czn");
      add(0x07, "slo", AsmAddressingMode.ZP, 5.0, "Aczn");
      add(0x08, "php", AsmAddressingMode.NON, 3.0, "S");
      add(0x09, "ora", AsmAddressingMode.IMM, 2.0, "Azn");
      add(0x0a, "asl", AsmAddressingMode.NON, 2.0, "Aczn");
      add(0x0b, "anc", AsmAddressingMode.IMM, 2.0, "Aczn");
      add(0x0c, "nop", AsmAddressingMode.ABS, 4.0, "");
      add(0x0d, "ora", AsmAddressingMode.ABS, 4.0, "Azn");
      add(0x0e, "asl", AsmAddressingMode.ABS, 6.0, "czn");
      add(0x0f, "slo", AsmAddressingMode.ABS, 6.0, "Aczn");
      add(0x10, "bpl", AsmAddressingMode.REL, 2.5, "P");
      add(0x11, "ora", AsmAddressingMode.IZY, 5.5, "Azn");
      add(0x12, "kil", AsmAddressingMode.NON, 0.0, "");
      add(0x13, "slo", AsmAddressingMode.IZY, 8.0, "Aczn");
      add(0x14, "nop", AsmAddressingMode.ZPX, 4.0, "");
      add(0x15, "ora", AsmAddressingMode.ZPX, 4.0, "Azn");
      add(0x16, "asl", AsmAddressingMode.ZPX, 6.0, "czn");
      add(0x17, "slo", AsmAddressingMode.ZPX, 6.0, "Aczn");
      add(0x18, "clc", AsmAddressingMode.NON, 2.0, "c");
      add(0x19, "ora", AsmAddressingMode.ABY, 4.5, "Azn");
      add(0x1a, "nop", AsmAddressingMode.NON, 2.0, "");
      add(0x1b, "slo", AsmAddressingMode.ABY, 7.0, "Aczn");
      add(0x1c, "nop", AsmAddressingMode.ABX, 4.5, "");
      add(0x1d, "ora", AsmAddressingMode.ABX, 4.5, "Azn");
      add(0x1e, "asl", AsmAddressingMode.ABX, 7.0, "czn");
      add(0x1f, "slo", AsmAddressingMode.ABX, 7.0, "Aczn");
      add(0x20, "jsr", AsmAddressingMode.ABS, 6.0, "PS");
      add(0x21, "and", AsmAddressingMode.IZX, 6.0, "Azn");
      add(0x22, "kil", AsmAddressingMode.NON, 0.0, "");
      add(0x23, "rla", AsmAddressingMode.IZX, 8.0, "Aczn");
      add(0x24, "bit", AsmAddressingMode.ZP, 3.0, "vzn");
      add(0x25, "and", AsmAddressingMode.ZP, 3.0, "Azn");
      add(0x26, "rol", AsmAddressingMode.ZP, 5.0, "czn");
      add(0x27, "rla", AsmAddressingMode.ZP, 5.0, "Aczn");
      add(0x28, "plp", AsmAddressingMode.NON, 4.0, "cvznS");
      add(0x29, "and", AsmAddressingMode.IMM, 2.0, "Azn");
      add(0x2a, "rol", AsmAddressingMode.NON, 2.0, "Aczn");
      add(0x2b, "anc", AsmAddressingMode.IMM, 2.0, "Aczn");
      add(0x2c, "bit", AsmAddressingMode.ABS, 4.0, "vzn");
      add(0x2d, "and", AsmAddressingMode.ABS, 4.0, "Azn");
      add(0x2e, "rol", AsmAddressingMode.ABS, 6.0, "czn");
      add(0x2f, "rla", AsmAddressingMode.ABS, 6.0, "Aczn");
      add(0x30, "bmi", AsmAddressingMode.REL, 2.5, "P");
      add(0x31, "and", AsmAddressingMode.IZY, 5.5, "Azn");
      add(0x32, "kil", AsmAddressingMode.NON, 0.0, "");
      add(0x33, "rla", AsmAddressingMode.IZY, 8.0, "Aczn");
      add(0x34, "nop", AsmAddressingMode.ZPX, 4.0, "");
      add(0x35, "and", AsmAddressingMode.ZPX, 4.0, "Azn");
      add(0x36, "rol", AsmAddressingMode.ZPX, 6.0, "czn");
      add(0x37, "rla", AsmAddressingMode.ZPX, 6.0, "Aczn");
      add(0x38, "sec", AsmAddressingMode.NON, 2.0, "c");
      add(0x39, "and", AsmAddressingMode.ABY, 4.5, "Azn");
      add(0x3a, "nop", AsmAddressingMode.NON, 2.0, "");
      add(0x3b, "rla", AsmAddressingMode.ABY, 7.0, "Aczn");
      add(0x3c, "nop", AsmAddressingMode.ABX, 4.5, "");
      add(0x3d, "and", AsmAddressingMode.ABX, 4.5, "Azn");
      add(0x3e, "rol", AsmAddressingMode.ABX, 7.0, "czn");
      add(0x3f, "rla", AsmAddressingMode.ABX, 7.0, "Aczn");
      add(0x40, "rti", AsmAddressingMode.NON, 6.0, "cvznPS");
      add(0x41, "eor", AsmAddressingMode.IZX, 6.0, "Azn");
      add(0x42, "kil", AsmAddressingMode.NON, 0.0, "");
      add(0x43, "sre", AsmAddressingMode.IZX, 8.0, "Aczn");
      add(0x44, "nop", AsmAddressingMode.ZP, 3.0, "");
      add(0x45, "eor", AsmAddressingMode.ZP, 3.0, "Azn");
      add(0x46, "lsr", AsmAddressingMode.ZP, 5.0, "czn");
      add(0x47, "sre", AsmAddressingMode.ZP, 5.0, "Aczn");
      add(0x48, "pha", AsmAddressingMode.NON, 3.0, "S");
      add(0x49, "eor", AsmAddressingMode.IMM, 2.0, "Azn");
      add(0x4a, "lsr", AsmAddressingMode.NON, 2.0, "Aczn");
      add(0x4b, "alr", AsmAddressingMode.IMM, 2.0, "Aczn");
      add(0x4c, "jmp", AsmAddressingMode.ABS, 3.0, "P");
      add(0x4d, "eor", AsmAddressingMode.ABS, 4.0, "Azn");
      add(0x4e, "lsr", AsmAddressingMode.ABS, 6.0, "czn");
      add(0x4f, "sre", AsmAddressingMode.ABS, 6.0, "Aczn");
      add(0x50, "bvc", AsmAddressingMode.REL, 2.5, "P");
      add(0x51, "eor", AsmAddressingMode.IZY, 5.5, "Azn");
      add(0x52, "kil", AsmAddressingMode.NON, 0.0, "");
      add(0x53, "sre", AsmAddressingMode.IZY, 8.0, "Aczn");
      add(0x54, "nop", AsmAddressingMode.ZPX, 4.0, "");
      add(0x55, "eor", AsmAddressingMode.ZPX, 4.0, "Azn");
      add(0x56, "lsr", AsmAddressingMode.ZPX, 6.0, "czn");
      add(0x57, "sre", AsmAddressingMode.ZPX, 6.0, "Aczn");
      add(0x58, "cli", AsmAddressingMode.NON, 2.0, "i");
      add(0x59, "eor", AsmAddressingMode.ABY, 4.5, "Azn");
      add(0x5a, "nop", AsmAddressingMode.NON, 2.0, "");
      add(0x5b, "sre", AsmAddressingMode.ABY, 7.0, "Aczn");
      add(0x5c, "nop", AsmAddressingMode.ABX, 4.5, "");
      add(0x5d, "eor", AsmAddressingMode.ABX, 4.5, "Azn");
      add(0x5e, "lsr", AsmAddressingMode.ABX, 7.0, "czn");
      add(0x5f, "sre", AsmAddressingMode.ABX, 7.0, "Aczn");
      add(0x60, "rts", AsmAddressingMode.NON, 6.0, "PS");
      add(0x61, "adc", AsmAddressingMode.IZX, 6.0, "Acvzn");
      add(0x62, "kil", AsmAddressingMode.NON, 0.0, "");
      add(0x63, "rra", AsmAddressingMode.IZX, 8.0, "Acvzn");
      add(0x64, "nop", AsmAddressingMode.ZP, 3.0, "");
      add(0x65, "adc", AsmAddressingMode.ZP, 3.0, "Acvzn");
      add(0x66, "ror", AsmAddressingMode.ZP, 5.0, "czn");
      add(0x67, "rra", AsmAddressingMode.ZP, 5.0, "Acvzn");
      add(0x68, "pla", AsmAddressingMode.NON, 4.0, "AznS");
      add(0x69, "adc", AsmAddressingMode.IMM, 2.0, "Acvzn");
      add(0x6a, "ror", AsmAddressingMode.NON, 2.0, "Aczn");
      add(0x6b, "arr", AsmAddressingMode.IMM, 2.0, "Acvzn");
      add(0x6c, "jmp", AsmAddressingMode.IND, 5.0, "P");
      add(0x6d, "adc", AsmAddressingMode.ABS, 4.0, "Acvzn");
      add(0x6e, "ror", AsmAddressingMode.ABS, 6.0, "czn");
      add(0x6f, "rra", AsmAddressingMode.ABS, 6.0, "Acvzn");
      add(0x70, "bvs", AsmAddressingMode.REL, 2.5, "P");
      add(0x71, "adc", AsmAddressingMode.IZY, 5.5, "Acvzn");
      add(0x72, "kil", AsmAddressingMode.NON, 0.0, "");
      add(0x73, "rra", AsmAddressingMode.IZY, 8.0, "Acvzn");
      add(0x74, "nop", AsmAddressingMode.ZPX, 4.0, "");
      add(0x75, "adc", AsmAddressingMode.ZPX, 4.0, "Acvzn");
      add(0x76, "ror", AsmAddressingMode.ZPX, 6.0, "czn");
      add(0x77, "rra", AsmAddressingMode.ZPX, 6.0, "Acvzn");
      add(0x78, "sei", AsmAddressingMode.NON, 2.0, "i");
      add(0x79, "adc", AsmAddressingMode.ABY, 4.5, "Acvzn");
      add(0x7a, "nop", AsmAddressingMode.NON, 2.0, "");
      add(0x7b, "rra", AsmAddressingMode.ABY, 7.0, "Acvzn");
      add(0x7c, "nop", AsmAddressingMode.ABX, 4.5, "");
      add(0x7d, "adc", AsmAddressingMode.ABX, 4.5, "Acvzn");
      add(0x7e, "ror", AsmAddressingMode.ABX, 7.0, "czn");
      add(0x7f, "rra", AsmAddressingMode.ABX, 7.0, "Acvzn");
      add(0x80, "nop", AsmAddressingMode.IMM, 2.0, "");
      add(0x81, "sta", AsmAddressingMode.IZX, 6.0, "");
      add(0x82, "nop", AsmAddressingMode.IMM, 2.0, "");
      add(0x83, "sax", AsmAddressingMode.IZX, 6.0, "");
      add(0x84, "sty", AsmAddressingMode.ZP, 3.0, "");
      add(0x85, "sta", AsmAddressingMode.ZP, 3.0, "");
      add(0x86, "stx", AsmAddressingMode.ZP, 3.0, "");
      add(0x87, "sax", AsmAddressingMode.ZP, 3.0, "");
      add(0x88, "dey", AsmAddressingMode.NON, 2.0, "Yzn");
      add(0x89, "nop", AsmAddressingMode.IMM, 2.0, "");
      add(0x8a, "txa", AsmAddressingMode.NON, 2.0, "Azn");
      add(0x8b, "xaa", AsmAddressingMode.IMM, 2.0, "Azn");
      add(0x8c, "sty", AsmAddressingMode.ABS, 4.0, "");
      add(0x8d, "sta", AsmAddressingMode.ABS, 4.0, "");
      add(0x8e, "stx", AsmAddressingMode.ABS, 4.0, "");
      add(0x8f, "sax", AsmAddressingMode.ABS, 4.0, "");
      add(0x90, "bcc", AsmAddressingMode.REL, 2.5, "P");
      add(0x91, "sta", AsmAddressingMode.IZY, 6.0, "");
      add(0x92, "kil", AsmAddressingMode.NON, 0.0, "");
      add(0x93, "ahx", AsmAddressingMode.IZY, 6.0, "");
      add(0x94, "sty", AsmAddressingMode.ZPX, 4.0, "");
      add(0x95, "sta", AsmAddressingMode.ZPX, 4.0, "");
      add(0x96, "stx", AsmAddressingMode.ZPY, 4.0, "");
      add(0x97, "sax", AsmAddressingMode.ZPY, 4.0, "");
      add(0x98, "tya", AsmAddressingMode.NON, 2.0, "Azn");
      add(0x99, "sta", AsmAddressingMode.ABY, 5.0, "");
      add(0x9a, "txs", AsmAddressingMode.NON, 2.0, "S");
      add(0x9b, "tas", AsmAddressingMode.ABY, 5.0, "");
      add(0x9c, "shy", AsmAddressingMode.ABX, 5.0, "");
      add(0x9d, "sta", AsmAddressingMode.ABX, 5.0, "");
      add(0x9e, "shx", AsmAddressingMode.ABY, 5.0, "");
      add(0x9f, "ahx", AsmAddressingMode.ABY, 5.0, "");
      add(0xa0, "ldy", AsmAddressingMode.IMM, 2.0, "Yzn");
      add(0xa1, "lda", AsmAddressingMode.IZX, 6.0, "Azn");
      add(0xa2, "ldx", AsmAddressingMode.IMM, 2.0, "Xzn");
      add(0xa3, "lax", AsmAddressingMode.IZX, 6.0, "AXzn");
      add(0xa4, "ldy", AsmAddressingMode.ZP, 3.0, "Yzn");
      add(0xa5, "lda", AsmAddressingMode.ZP, 3.0, "Azn");
      add(0xa6, "ldx", AsmAddressingMode.ZP, 3.0, "Xzn");
      add(0xa7, "lax", AsmAddressingMode.ZP, 3.0, "AXzn");
      add(0xa8, "tay", AsmAddressingMode.NON, 2.0, "Yzn");
      add(0xa9, "lda", AsmAddressingMode.IMM, 2.0, "Azn");
      add(0xaa, "tax", AsmAddressingMode.NON, 2.0, "Xzn");
      add(0xab, "lax", AsmAddressingMode.IMM, 2.0, "AXzn");
      add(0xac, "ldy", AsmAddressingMode.ABS, 4.0, "Yzn");
      add(0xad, "lda", AsmAddressingMode.ABS, 4.0, "Azn");
      add(0xae, "ldx", AsmAddressingMode.ABS, 4.0, "Xzn");
      add(0xaf, "lax", AsmAddressingMode.ABS, 4.0, "AXzn");
      add(0xb0, "bcs", AsmAddressingMode.REL, 2.5, "P");
      add(0xb1, "lda", AsmAddressingMode.IZY, 5.5, "Azn");
      add(0xb2, "kil", AsmAddressingMode.NON, 0.0, "");
      add(0xb3, "lax", AsmAddressingMode.IZY, 5.5, "AXzn");
      add(0xb4, "ldy", AsmAddressingMode.ZPX, 4.0, "Yzn");
      add(0xb5, "lda", AsmAddressingMode.ZPX, 4.0, "Azn");
      add(0xb6, "ldx", AsmAddressingMode.ZPY, 4.0, "Xzn");
      add(0xb7, "lax", AsmAddressingMode.ZPY, 4.0, "AXzn");
      add(0xb8, "clv", AsmAddressingMode.NON, 2.0, "v");
      add(0xb9, "lda", AsmAddressingMode.ABY, 4.5, "Azn");
      add(0xba, "tsx", AsmAddressingMode.NON, 2.0, "Xzn");
      add(0xbb, "las", AsmAddressingMode.ABY, 4.5, "AXzn");
      add(0xbc, "ldy", AsmAddressingMode.ABX, 4.5, "Yzn");
      add(0xbd, "lda", AsmAddressingMode.ABX, 4.5, "Azn");
      add(0xbe, "ldx", AsmAddressingMode.ABY, 4.5, "Xzn");
      add(0xbf, "lax", AsmAddressingMode.ABY, 4.5, "AXzn");
      add(0xc0, "cpy", AsmAddressingMode.IMM, 2.0, "czn");
      add(0xc1, "cmp", AsmAddressingMode.IZX, 6.0, "czn");
      add(0xc2, "nop", AsmAddressingMode.IMM, 2.0, "");
      add(0xc3, "dcp", AsmAddressingMode.IZX, 8.0, "czn");
      add(0xc4, "cpy", AsmAddressingMode.ZP, 3.0, "czn");
      add(0xc5, "cmp", AsmAddressingMode.ZP, 3.0, "czn");
      add(0xc6, "dec", AsmAddressingMode.ZP, 5.0, "zn");
      add(0xc7, "dcp", AsmAddressingMode.ZP, 5.0, "czn");
      add(0xc8, "iny", AsmAddressingMode.NON, 2.0, "Yzn");
      add(0xc9, "cmp", AsmAddressingMode.IMM, 2.0, "czn");
      add(0xca, "dex", AsmAddressingMode.NON, 2.0, "Xzn");
      add(0xcb, "axs", AsmAddressingMode.IMM, 2.0, "Xczn");
      add(0xcc, "cpy", AsmAddressingMode.ABS, 4.0, "czn");
      add(0xcd, "cmp", AsmAddressingMode.ABS, 4.0, "czn");
      add(0xce, "dec", AsmAddressingMode.ABS, 6.0, "zn");
      add(0xcf, "dcp", AsmAddressingMode.ABS, 6.0, "czn");
      add(0xd0, "bne", AsmAddressingMode.REL, 2.5, "P");
      add(0xd1, "cmp", AsmAddressingMode.IZY, 5.5, "czn");
      add(0xd2, "kil", AsmAddressingMode.NON, 0.0, "");
      add(0xd3, "dcp", AsmAddressingMode.IZY, 8.0, "czn");
      add(0xd4, "nop", AsmAddressingMode.ZPX, 4.0, "");
      add(0xd5, "cmp", AsmAddressingMode.ZPX, 4.0, "czn");
      add(0xd6, "dec", AsmAddressingMode.ZPX, 6.0, "zn");
      add(0xd7, "dcp", AsmAddressingMode.ZPX, 6.0, "czn");
      add(0xd8, "cld", AsmAddressingMode.NON, 2.0, "d");
      add(0xd9, "cmp", AsmAddressingMode.ABY, 4.5, "czn");
      add(0xda, "nop", AsmAddressingMode.NON, 2.0, "");
      add(0xdb, "dcp", AsmAddressingMode.ABY, 7.0, "czn");
      add(0xdc, "nop", AsmAddressingMode.ABX, 4.5, "");
      add(0xdd, "cmp", AsmAddressingMode.ABX, 4.5, "czn");
      add(0xde, "dec", AsmAddressingMode.ABX, 7.0, "zn");
      add(0xef, "cpx", AsmAddressingMode.IMM, 2.0, "czn");
      add(0xe0, "sbc", AsmAddressingMode.IZX, 6.0, "Acvzn");
      add(0xe1, "nop", AsmAddressingMode.IMM, 2.0, "");
      add(0xe2, "isc", AsmAddressingMode.IZX, 8.0, "Acvzn");
      add(0xe3, "cpx", AsmAddressingMode.ZP, 3.0, "czn");
      add(0xe4, "sbc", AsmAddressingMode.ZP, 3.0, "Acvzn");
      add(0xe5, "inc", AsmAddressingMode.ZP, 5.0, "zn");
      add(0xe6, "isc", AsmAddressingMode.ZP, 5.0, "Acvzn");
      add(0xe7, "inx", AsmAddressingMode.NON, 2.0, "Xzn");
      add(0xe8, "sbc", AsmAddressingMode.IMM, 2.0, "Acvzn");
      add(0xe9, "nop", AsmAddressingMode.NON, 2.0, "");
      add(0xea, "sbc", AsmAddressingMode.IMM, 2.0, "Acvzn");
      add(0xeb, "cpx", AsmAddressingMode.ABS, 4.0, "czn");
      add(0xec, "sbc", AsmAddressingMode.ABS, 4.0, "Acvzn");
      add(0xed, "inc", AsmAddressingMode.ABS, 6.0, "zn");
      add(0xee, "isc", AsmAddressingMode.ABS, 6.0, "Acvzn");
      add(0xef, "dcp", AsmAddressingMode.ABX, 7.0, "czn");
      add(0xf0, "beq", AsmAddressingMode.REL, 2.5, "P");
      add(0xf1, "sbc", AsmAddressingMode.IZY, 5.5, "Acvzn");
      add(0xf2, "kil", AsmAddressingMode.NON, 0.0, "");
      add(0xf3, "isc", AsmAddressingMode.IZY, 8.0, "Acvzn");
      add(0xf4, "nop", AsmAddressingMode.ZPX, 4.0, "");
      add(0xf5, "sbc", AsmAddressingMode.ZPX, 4.0, "Acvzn");
      add(0xf6, "inc", AsmAddressingMode.ZPX, 6.0, "zn");
      add(0xf7, "isc", AsmAddressingMode.ZPX, 6.0, "Acvzn");
      add(0xf8, "sed", AsmAddressingMode.NON, 2.0, "d");
      add(0xf9, "sbc", AsmAddressingMode.ABY, 4.5, "Acvzn");
      add(0xfa, "nop", AsmAddressingMode.NON, 2.0, "");
      add(0xfb, "isc", AsmAddressingMode.ABY, 7.0, "Acvzn");
      add(0xfc, "nop", AsmAddressingMode.ABX, 4.5, "");
      add(0xfd, "sbc", AsmAddressingMode.ABX, 4.5, "Acvzn");
      add(0xfe, "inc", AsmAddressingMode.ABX, 7.0, "zn");
      add(0xff, "isc", AsmAddressingMode.ABX, 7.0, "Acvzn");

      // 65c02 instructions
      // TODO: create instruction set model that knows the different CPU's
      add(0x1a, "inc", AsmAddressingMode.NON, 2.0, "Azn");

   }


   /**
    * Add an instruction to the instruction set.
    *
    * @param opcode The numeric opcode
    * @param mnemonic The lower case mnemonic
    * @param addressingMode The addressing mode
    * @param cycles The number of cycles
    */
   private void add(int opcode, String mnemonic, AsmAddressingMode addressingMode, double cycles, String clobberString) {
      AsmOpcode asmOpcode = new AsmOpcode(opcode, mnemonic, addressingMode, cycles, clobberString);
      instructions.add(asmOpcode);
      instructionsMap.put(mnemonic + "_" + addressingMode.getName(), asmOpcode);
   }

   /**
    * Get a specific instruction opcode form the instruction set
    *
    * @param mnemonic The mnemonic
    * @param addressingMode The addressing mode
    * @return The opcode, if is exists. Null if the instruction set does not have the opcode.
    */
   public AsmOpcode getOpcode(String mnemonic, AsmAddressingMode addressingMode) {
      String key = mnemonic.toLowerCase() + "_" + addressingMode.getName();
      return instructionsMap.get(key);
   }

   /**
    * Get an opcode from the instruction set in either absolute or zeropage form.
    * This will try to find a zeropage-based addressing mode if you indicate that you are interested in that.
    *
    * @param mnemonic The mnemonic
    * @param mode The addressing mode you want.
    * @param isZp Indicates whether you are interested in a zeropage-based opcode.
    * @return The opcode, if it exists. If you have requested an absolute addressing mode passed isZp as true the resulting opcode will have zeropage-based addressing the instruction set offers that.
    */
   public static AsmOpcode getOpcode(String mnemonic, AsmAddressingMode mode, boolean isZp) {
      AsmOpcode asmOpcode = null;
      if(AsmAddressingMode.ABS.equals(mode) && isZp) {
         asmOpcode = set.getOpcode(mnemonic, AsmAddressingMode.ZP);
      }
      if(AsmAddressingMode.ABX.equals(mode) && isZp) {
         asmOpcode = set.getOpcode(mnemonic, AsmAddressingMode.ZPX);
      }
      if(AsmAddressingMode.ABY.equals(mode) && isZp) {
         asmOpcode = set.getOpcode(mnemonic, AsmAddressingMode.ZPY);
      }
      if(asmOpcode == null) {
         asmOpcode = set.getOpcode(mnemonic, mode);
      }
      if(asmOpcode == null && AsmAddressingMode.ABS.equals(mode)) {
         asmOpcode = set.getOpcode(mnemonic, AsmAddressingMode.REL);
      }
      return asmOpcode;
   }


}
