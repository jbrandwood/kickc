package dk.camelot64.cpufamily6502.cpus;

import dk.camelot64.cpufamily6502.CpuAddressingMode;
import dk.camelot64.cpufamily6502.Cpu65xx;

/**
 * The official 6502 instruction set (no illegal instructions).
 * This is the basis for all other 6502 family CPU's and all opcodes are available in all other CPU's.
 * http://archive.6502.org/datasheets/mos_6500_mpu_nov_1985.pdf
 */
public class Cpu6502Official extends Cpu65xx {

   /** The 6502 official CPU name. */
   public final static String NAME = "6502";

   /** The 6502 official CPU. */
   public final static Cpu6502Official INSTANCE = new Cpu6502Official();

   public Cpu6502Official() {
      super(NAME);
      addOpcode(0x00, "brk", CpuAddressingMode.NON, 7.0, "");
      addOpcode(0x01, "ora", CpuAddressingMode.IZX, 6.0, "Anz");
      addOpcode(0x05, "ora", CpuAddressingMode.ZP, 3.0, "Anz");
      addOpcode(0x06, "asl", CpuAddressingMode.ZP, 5.0, "cnz");
      addOpcode(0x08, "php", CpuAddressingMode.NON, 3.0, "S");
      addOpcode(0x09, "ora", CpuAddressingMode.IMM, 2.0, "Anz");
      addOpcode(0x0a, "asl", CpuAddressingMode.NON, 2.0, "Acnz");
      addOpcode(0x0d, "ora", CpuAddressingMode.ABS, 4.0, "Anz");
      addOpcode(0x0e, "asl", CpuAddressingMode.ABS, 6.0, "cnz");
      addOpcode(0x10, "bpl", CpuAddressingMode.REL, 2.5, "P");
      addOpcode(0x11, "ora", CpuAddressingMode.IZY, 5.5, "Anz");
      addOpcode(0x15, "ora", CpuAddressingMode.ZPX, 4.0, "Anz");
      addOpcode(0x16, "asl", CpuAddressingMode.ZPX, 6.0, "cnz");
      addOpcode(0x18, "clc", CpuAddressingMode.NON, 2.0, "c");
      addOpcode(0x19, "ora", CpuAddressingMode.ABY, 4.5, "Anz");
      addOpcode(0x1d, "ora", CpuAddressingMode.ABX, 4.5, "Anz");
      addOpcode(0x1e, "asl", CpuAddressingMode.ABX, 7.0, "cnz");
      addOpcode(0x20, "jsr", CpuAddressingMode.ABS, 6.0, "PS");
      addOpcode(0x21, "and", CpuAddressingMode.IZX, 6.0, "Anz");
      addOpcode(0x24, "bit", CpuAddressingMode.ZP, 3.0, "vnz");
      addOpcode(0x25, "and", CpuAddressingMode.ZP, 3.0, "Anz");
      addOpcode(0x26, "rol", CpuAddressingMode.ZP, 5.0, "cnz");
      addOpcode(0x28, "plp", CpuAddressingMode.NON, 4.0, "cvnzS");
      addOpcode(0x29, "and", CpuAddressingMode.IMM, 2.0, "Anz");
      addOpcode(0x2a, "rol", CpuAddressingMode.NON, 2.0, "Acnz");
      addOpcode(0x2c, "bit", CpuAddressingMode.ABS, 4.0, "vnz");
      addOpcode(0x2d, "and", CpuAddressingMode.ABS, 4.0, "Anz");
      addOpcode(0x2e, "rol", CpuAddressingMode.ABS, 6.0, "cnz");
      addOpcode(0x30, "bmi", CpuAddressingMode.REL, 2.5, "P");
      addOpcode(0x31, "and", CpuAddressingMode.IZY, 5.5, "Anz");
      addOpcode(0x35, "and", CpuAddressingMode.ZPX, 4.0, "Anz");
      addOpcode(0x36, "rol", CpuAddressingMode.ZPX, 6.0, "cnz");
      addOpcode(0x38, "sec", CpuAddressingMode.NON, 2.0, "c");
      addOpcode(0x39, "and", CpuAddressingMode.ABY, 4.5, "Anz");
      addOpcode(0x3d, "and", CpuAddressingMode.ABX, 4.5, "Anz");
      addOpcode(0x3e, "rol", CpuAddressingMode.ABX, 7.0, "cnz");
      addOpcode(0x40, "rti", CpuAddressingMode.NON, 6.0, "cvnzPS");
      addOpcode(0x41, "eor", CpuAddressingMode.IZX, 6.0, "Anz");
      addOpcode(0x45, "eor", CpuAddressingMode.ZP, 3.0, "Anz");
      addOpcode(0x46, "lsr", CpuAddressingMode.ZP, 5.0, "cnz");
      addOpcode(0x48, "pha", CpuAddressingMode.NON, 3.0, "S");
      addOpcode(0x49, "eor", CpuAddressingMode.IMM, 2.0, "Anz");
      addOpcode(0x4a, "lsr", CpuAddressingMode.NON, 2.0, "Acnz");
      addOpcode(0x4c, "jmp", CpuAddressingMode.ABS, 3.0, "P");
      addOpcode(0x4d, "eor", CpuAddressingMode.ABS, 4.0, "Anz");
      addOpcode(0x4e, "lsr", CpuAddressingMode.ABS, 6.0, "cnz");
      addOpcode(0x50, "bvc", CpuAddressingMode.REL, 2.5, "P");
      addOpcode(0x51, "eor", CpuAddressingMode.IZY, 5.5, "Anz");
      addOpcode(0x55, "eor", CpuAddressingMode.ZPX, 4.0, "Anz");
      addOpcode(0x56, "lsr", CpuAddressingMode.ZPX, 6.0, "cnz");
      addOpcode(0x58, "cli", CpuAddressingMode.NON, 2.0, "i");
      addOpcode(0x59, "eor", CpuAddressingMode.ABY, 4.5, "Anz");
      addOpcode(0x5d, "eor", CpuAddressingMode.ABX, 4.5, "Anz");
      addOpcode(0x5e, "lsr", CpuAddressingMode.ABX, 7.0, "cnz");
      addOpcode(0x60, "rts", CpuAddressingMode.NON, 6.0, "PS");
      addOpcode(0x61, "adc", CpuAddressingMode.IZX, 6.0, "Acvnz");
      addOpcode(0x65, "adc", CpuAddressingMode.ZP, 3.0, "Acvnz");
      addOpcode(0x66, "ror", CpuAddressingMode.ZP, 5.0, "cnz");
      addOpcode(0x68, "pla", CpuAddressingMode.NON, 4.0, "AnzS");
      addOpcode(0x69, "adc", CpuAddressingMode.IMM, 2.0, "Acvnz");
      addOpcode(0x6a, "ror", CpuAddressingMode.NON, 2.0, "Acnz");
      addOpcode(0x6c, "jmp", CpuAddressingMode.IND, 5.0, "P");
      addOpcode(0x6d, "adc", CpuAddressingMode.ABS, 4.0, "Acvnz");
      addOpcode(0x6e, "ror", CpuAddressingMode.ABS, 6.0, "cnz");
      addOpcode(0x70, "bvs", CpuAddressingMode.REL, 2.5, "P");
      addOpcode(0x71, "adc", CpuAddressingMode.IZY, 5.5, "Acvnz");
      addOpcode(0x75, "adc", CpuAddressingMode.ZPX, 4.0, "Acvnz");
      addOpcode(0x76, "ror", CpuAddressingMode.ZPX, 6.0, "cnz");
      addOpcode(0x78, "sei", CpuAddressingMode.NON, 2.0, "i");
      addOpcode(0x79, "adc", CpuAddressingMode.ABY, 4.5, "Acvnz");
      addOpcode(0x7d, "adc", CpuAddressingMode.ABX, 4.5, "Acvnz");
      addOpcode(0x7e, "ror", CpuAddressingMode.ABX, 7.0, "cnz");
      addOpcode(0x81, "sta", CpuAddressingMode.IZX, 6.0, "");
      addOpcode(0x84, "sty", CpuAddressingMode.ZP, 3.0, "");
      addOpcode(0x85, "sta", CpuAddressingMode.ZP, 3.0, "");
      addOpcode(0x86, "stx", CpuAddressingMode.ZP, 3.0, "");
      addOpcode(0x88, "dey", CpuAddressingMode.NON, 2.0, "Ynz");
      addOpcode(0x8a, "txa", CpuAddressingMode.NON, 2.0, "Anz");
      addOpcode(0x8c, "sty", CpuAddressingMode.ABS, 4.0, "");
      addOpcode(0x8d, "sta", CpuAddressingMode.ABS, 4.0, "");
      addOpcode(0x8e, "stx", CpuAddressingMode.ABS, 4.0, "");
      addOpcode(0x90, "bcc", CpuAddressingMode.REL, 2.5, "P");
      addOpcode(0x91, "sta", CpuAddressingMode.IZY, 6.0, "");
      addOpcode(0x94, "sty", CpuAddressingMode.ZPX, 4.0, "");
      addOpcode(0x95, "sta", CpuAddressingMode.ZPX, 4.0, "");
      addOpcode(0x96, "stx", CpuAddressingMode.ZPY, 4.0, "");
      addOpcode(0x98, "tya", CpuAddressingMode.NON, 2.0, "Anz");
      addOpcode(0x99, "sta", CpuAddressingMode.ABY, 5.0, "");
      addOpcode(0x9a, "txs", CpuAddressingMode.NON, 2.0, "S");
      addOpcode(0x9d, "sta", CpuAddressingMode.ABX, 5.0, "");
      addOpcode(0xa0, "ldy", CpuAddressingMode.IMM, 2.0, "Ynz");
      addOpcode(0xa1, "lda", CpuAddressingMode.IZX, 6.0, "Anz");
      addOpcode(0xa2, "ldx", CpuAddressingMode.IMM, 2.0, "Xnz");
      addOpcode(0xa4, "ldy", CpuAddressingMode.ZP, 3.0, "Ynz");
      addOpcode(0xa5, "lda", CpuAddressingMode.ZP, 3.0, "Anz");
      addOpcode(0xa6, "ldx", CpuAddressingMode.ZP, 3.0, "Xnz");
      addOpcode(0xa8, "tay", CpuAddressingMode.NON, 2.0, "Ynz");
      addOpcode(0xa9, "lda", CpuAddressingMode.IMM, 2.0, "Anz");
      addOpcode(0xaa, "tax", CpuAddressingMode.NON, 2.0, "Xnz");
      addOpcode(0xac, "ldy", CpuAddressingMode.ABS, 4.0, "Ynz");
      addOpcode(0xad, "lda", CpuAddressingMode.ABS, 4.0, "Anz");
      addOpcode(0xae, "ldx", CpuAddressingMode.ABS, 4.0, "Xnz");
      addOpcode(0xb0, "bcs", CpuAddressingMode.REL, 2.5, "P");
      addOpcode(0xb1, "lda", CpuAddressingMode.IZY, 5.5, "Anz");
      addOpcode(0xb4, "ldy", CpuAddressingMode.ZPX, 4.0, "Ynz");
      addOpcode(0xb5, "lda", CpuAddressingMode.ZPX, 4.0, "Anz");
      addOpcode(0xb6, "ldx", CpuAddressingMode.ZPY, 4.0, "Xnz");
      addOpcode(0xb8, "clv", CpuAddressingMode.NON, 2.0, "v");
      addOpcode(0xb9, "lda", CpuAddressingMode.ABY, 4.5, "Anz");
      addOpcode(0xba, "tsx", CpuAddressingMode.NON, 2.0, "Xnz");
      addOpcode(0xbc, "ldy", CpuAddressingMode.ABX, 4.5, "Ynz");
      addOpcode(0xbd, "lda", CpuAddressingMode.ABX, 4.5, "Anz");
      addOpcode(0xbe, "ldx", CpuAddressingMode.ABY, 4.5, "Xnz");
      addOpcode(0xc0, "cpy", CpuAddressingMode.IMM, 2.0, "cnz");
      addOpcode(0xc1, "cmp", CpuAddressingMode.IZX, 6.0, "cnz");
      addOpcode(0xc4, "cpy", CpuAddressingMode.ZP, 3.0, "cnz");
      addOpcode(0xc5, "cmp", CpuAddressingMode.ZP, 3.0, "cnz");
      addOpcode(0xc6, "dec", CpuAddressingMode.ZP, 5.0, "nz");
      addOpcode(0xc8, "iny", CpuAddressingMode.NON, 2.0, "Ynz");
      addOpcode(0xc9, "cmp", CpuAddressingMode.IMM, 2.0, "cnz");
      addOpcode(0xca, "dex", CpuAddressingMode.NON, 2.0, "Xnz");
      addOpcode(0xcc, "cpy", CpuAddressingMode.ABS, 4.0, "cnz");
      addOpcode(0xcd, "cmp", CpuAddressingMode.ABS, 4.0, "cnz");
      addOpcode(0xce, "dec", CpuAddressingMode.ABS, 6.0, "nz");
      addOpcode(0xd0, "bne", CpuAddressingMode.REL, 2.5, "P");
      addOpcode(0xd1, "cmp", CpuAddressingMode.IZY, 5.5, "cnz");
      addOpcode(0xd5, "cmp", CpuAddressingMode.ZPX, 4.0, "cnz");
      addOpcode(0xd6, "dec", CpuAddressingMode.ZPX, 6.0, "nz");
      addOpcode(0xd8, "cld", CpuAddressingMode.NON, 2.0, "d");
      addOpcode(0xd9, "cmp", CpuAddressingMode.ABY, 4.5, "cnz");
      addOpcode(0xdd, "cmp", CpuAddressingMode.ABX, 4.5, "cnz");
      addOpcode(0xde, "dec", CpuAddressingMode.ABX, 7.0, "nz");
      addOpcode(0xe0, "cpx", CpuAddressingMode.IMM, 2.0, "cnz");
      addOpcode(0xe1, "sbc", CpuAddressingMode.IZX, 6.0, "Acvnz");
      addOpcode(0xe4, "cpx", CpuAddressingMode.ZP, 3.0, "cnz");
      addOpcode(0xe5, "sbc", CpuAddressingMode.ZP, 3.0, "Acvnz");
      addOpcode(0xe6, "inc", CpuAddressingMode.ZP, 5.0, "nz");
      addOpcode(0xe8, "inx", CpuAddressingMode.NON, 2.0, "Xnz");
      addOpcode(0xe9, "sbc", CpuAddressingMode.IMM, 2.0, "Acvnz");
      addOpcode(0xea, "nop", CpuAddressingMode.NON, 2.0, "");
      addOpcode(0xec, "cpx", CpuAddressingMode.ABS, 4.0, "cnz");
      addOpcode(0xed, "sbc", CpuAddressingMode.ABS, 4.0, "Acvnz");
      addOpcode(0xee, "inc", CpuAddressingMode.ABS, 6.0, "nz");
      addOpcode(0xf0, "beq", CpuAddressingMode.REL, 2.5, "P");
      addOpcode(0xf1, "sbc", CpuAddressingMode.IZY, 5.5, "Acvnz");
      addOpcode(0xf5, "sbc", CpuAddressingMode.ZPX, 4.0, "Acvnz");
      addOpcode(0xf6, "inc", CpuAddressingMode.ZPX, 6.0, "nz");
      addOpcode(0xf8, "sed", CpuAddressingMode.NON, 2.0, "d");
      addOpcode(0xf9, "sbc", CpuAddressingMode.ABY, 4.5, "Acvnz");
      addOpcode(0xfd, "sbc", CpuAddressingMode.ABX, 4.5, "Acvnz");
      addOpcode(0xfe, "inc", CpuAddressingMode.ABX, 7.0, "nz");
   }

}
