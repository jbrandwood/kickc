package dk.camelot64.cpufamily6502.cpus;

import dk.camelot64.cpufamily6502.AsmAddressingMode;
import dk.camelot64.cpufamily6502.AsmCpu;

/**
 * The official 6502 instruction set (no illegal instructions).
 * This is the basis for all other 6502 family CPU's and all opcodes are available in all other CPU's.
 * http://archive.6502.org/datasheets/mos_6500_mpu_nov_1985.pdf
 */
public class Cpu6502Official extends AsmCpu {

   /** The 6502 official CPU name. */
   public final static String NAME = "6502";

   /** The 6502 official CPU. */
   public final static Cpu6502Official INSTANCE = new Cpu6502Official();

   public Cpu6502Official() {
      super(NAME);
      addOpcode(0x00, "brk", AsmAddressingMode.NON, 7.0, "");
      addOpcode(0x01, "ora", AsmAddressingMode.IZX, 6.0, "Azn");
      addOpcode(0x05, "ora", AsmAddressingMode.ZP, 3.0, "Azn");
      addOpcode(0x06, "asl", AsmAddressingMode.ZP, 5.0, "czn");
      addOpcode(0x08, "php", AsmAddressingMode.NON, 3.0, "S");
      addOpcode(0x09, "ora", AsmAddressingMode.IMM, 2.0, "Azn");
      addOpcode(0x0a, "asl", AsmAddressingMode.NON, 2.0, "Aczn");
      addOpcode(0x0d, "ora", AsmAddressingMode.ABS, 4.0, "Azn");
      addOpcode(0x0e, "asl", AsmAddressingMode.ABS, 6.0, "czn");
      addOpcode(0x10, "bpl", AsmAddressingMode.REL, 2.5, "P");
      addOpcode(0x11, "ora", AsmAddressingMode.IZY, 5.5, "Azn");
      addOpcode(0x15, "ora", AsmAddressingMode.ZPX, 4.0, "Azn");
      addOpcode(0x16, "asl", AsmAddressingMode.ZPX, 6.0, "czn");
      addOpcode(0x18, "clc", AsmAddressingMode.NON, 2.0, "c");
      addOpcode(0x19, "ora", AsmAddressingMode.ABY, 4.5, "Azn");
      addOpcode(0x1d, "ora", AsmAddressingMode.ABX, 4.5, "Azn");
      addOpcode(0x1e, "asl", AsmAddressingMode.ABX, 7.0, "czn");
      addOpcode(0x20, "jsr", AsmAddressingMode.ABS, 6.0, "PS");
      addOpcode(0x21, "and", AsmAddressingMode.IZX, 6.0, "Azn");
      addOpcode(0x24, "bit", AsmAddressingMode.ZP, 3.0, "vzn");
      addOpcode(0x25, "and", AsmAddressingMode.ZP, 3.0, "Azn");
      addOpcode(0x26, "rol", AsmAddressingMode.ZP, 5.0, "czn");
      addOpcode(0x28, "plp", AsmAddressingMode.NON, 4.0, "cvznS");
      addOpcode(0x29, "and", AsmAddressingMode.IMM, 2.0, "Azn");
      addOpcode(0x2a, "rol", AsmAddressingMode.NON, 2.0, "Aczn");
      addOpcode(0x2c, "bit", AsmAddressingMode.ABS, 4.0, "vzn");
      addOpcode(0x2d, "and", AsmAddressingMode.ABS, 4.0, "Azn");
      addOpcode(0x2e, "rol", AsmAddressingMode.ABS, 6.0, "czn");
      addOpcode(0x30, "bmi", AsmAddressingMode.REL, 2.5, "P");
      addOpcode(0x31, "and", AsmAddressingMode.IZY, 5.5, "Azn");
      addOpcode(0x35, "and", AsmAddressingMode.ZPX, 4.0, "Azn");
      addOpcode(0x36, "rol", AsmAddressingMode.ZPX, 6.0, "czn");
      addOpcode(0x38, "sec", AsmAddressingMode.NON, 2.0, "c");
      addOpcode(0x39, "and", AsmAddressingMode.ABY, 4.5, "Azn");
      addOpcode(0x3d, "and", AsmAddressingMode.ABX, 4.5, "Azn");
      addOpcode(0x3e, "rol", AsmAddressingMode.ABX, 7.0, "czn");
      addOpcode(0x40, "rti", AsmAddressingMode.NON, 6.0, "cvznPS");
      addOpcode(0x41, "eor", AsmAddressingMode.IZX, 6.0, "Azn");
      addOpcode(0x45, "eor", AsmAddressingMode.ZP, 3.0, "Azn");
      addOpcode(0x46, "lsr", AsmAddressingMode.ZP, 5.0, "czn");
      addOpcode(0x48, "pha", AsmAddressingMode.NON, 3.0, "S");
      addOpcode(0x49, "eor", AsmAddressingMode.IMM, 2.0, "Azn");
      addOpcode(0x4a, "lsr", AsmAddressingMode.NON, 2.0, "Aczn");
      addOpcode(0x4c, "jmp", AsmAddressingMode.ABS, 3.0, "P");
      addOpcode(0x4d, "eor", AsmAddressingMode.ABS, 4.0, "Azn");
      addOpcode(0x4e, "lsr", AsmAddressingMode.ABS, 6.0, "czn");
      addOpcode(0x50, "bvc", AsmAddressingMode.REL, 2.5, "P");
      addOpcode(0x51, "eor", AsmAddressingMode.IZY, 5.5, "Azn");
      addOpcode(0x55, "eor", AsmAddressingMode.ZPX, 4.0, "Azn");
      addOpcode(0x56, "lsr", AsmAddressingMode.ZPX, 6.0, "czn");
      addOpcode(0x58, "cli", AsmAddressingMode.NON, 2.0, "i");
      addOpcode(0x59, "eor", AsmAddressingMode.ABY, 4.5, "Azn");
      addOpcode(0x5d, "eor", AsmAddressingMode.ABX, 4.5, "Azn");
      addOpcode(0x5e, "lsr", AsmAddressingMode.ABX, 7.0, "czn");
      addOpcode(0x60, "rts", AsmAddressingMode.NON, 6.0, "PS");
      addOpcode(0x61, "adc", AsmAddressingMode.IZX, 6.0, "Acvzn");
      addOpcode(0x65, "adc", AsmAddressingMode.ZP, 3.0, "Acvzn");
      addOpcode(0x66, "ror", AsmAddressingMode.ZP, 5.0, "czn");
      addOpcode(0x68, "pla", AsmAddressingMode.NON, 4.0, "AznS");
      addOpcode(0x69, "adc", AsmAddressingMode.IMM, 2.0, "Acvzn");
      addOpcode(0x6a, "ror", AsmAddressingMode.NON, 2.0, "Aczn");
      addOpcode(0x6c, "jmp", AsmAddressingMode.IND, 5.0, "P");
      addOpcode(0x6d, "adc", AsmAddressingMode.ABS, 4.0, "Acvzn");
      addOpcode(0x6e, "ror", AsmAddressingMode.ABS, 6.0, "czn");
      addOpcode(0x70, "bvs", AsmAddressingMode.REL, 2.5, "P");
      addOpcode(0x71, "adc", AsmAddressingMode.IZY, 5.5, "Acvzn");
      addOpcode(0x75, "adc", AsmAddressingMode.ZPX, 4.0, "Acvzn");
      addOpcode(0x76, "ror", AsmAddressingMode.ZPX, 6.0, "czn");
      addOpcode(0x78, "sei", AsmAddressingMode.NON, 2.0, "i");
      addOpcode(0x79, "adc", AsmAddressingMode.ABY, 4.5, "Acvzn");
      addOpcode(0x7d, "adc", AsmAddressingMode.ABX, 4.5, "Acvzn");
      addOpcode(0x7e, "ror", AsmAddressingMode.ABX, 7.0, "czn");
      addOpcode(0x81, "sta", AsmAddressingMode.IZX, 6.0, "");
      addOpcode(0x84, "sty", AsmAddressingMode.ZP, 3.0, "");
      addOpcode(0x85, "sta", AsmAddressingMode.ZP, 3.0, "");
      addOpcode(0x86, "stx", AsmAddressingMode.ZP, 3.0, "");
      addOpcode(0x88, "dey", AsmAddressingMode.NON, 2.0, "Yzn");
      addOpcode(0x8a, "txa", AsmAddressingMode.NON, 2.0, "Azn");
      addOpcode(0x8c, "sty", AsmAddressingMode.ABS, 4.0, "");
      addOpcode(0x8d, "sta", AsmAddressingMode.ABS, 4.0, "");
      addOpcode(0x8e, "stx", AsmAddressingMode.ABS, 4.0, "");
      addOpcode(0x90, "bcc", AsmAddressingMode.REL, 2.5, "P");
      addOpcode(0x91, "sta", AsmAddressingMode.IZY, 6.0, "");
      addOpcode(0x94, "sty", AsmAddressingMode.ZPX, 4.0, "");
      addOpcode(0x95, "sta", AsmAddressingMode.ZPX, 4.0, "");
      addOpcode(0x96, "stx", AsmAddressingMode.ZPY, 4.0, "");
      addOpcode(0x98, "tya", AsmAddressingMode.NON, 2.0, "Azn");
      addOpcode(0x99, "sta", AsmAddressingMode.ABY, 5.0, "");
      addOpcode(0x9a, "txs", AsmAddressingMode.NON, 2.0, "S");
      addOpcode(0x9d, "sta", AsmAddressingMode.ABX, 5.0, "");
      addOpcode(0xa0, "ldy", AsmAddressingMode.IMM, 2.0, "Yzn");
      addOpcode(0xa1, "lda", AsmAddressingMode.IZX, 6.0, "Azn");
      addOpcode(0xa2, "ldx", AsmAddressingMode.IMM, 2.0, "Xzn");
      addOpcode(0xa4, "ldy", AsmAddressingMode.ZP, 3.0, "Yzn");
      addOpcode(0xa5, "lda", AsmAddressingMode.ZP, 3.0, "Azn");
      addOpcode(0xa6, "ldx", AsmAddressingMode.ZP, 3.0, "Xzn");
      addOpcode(0xa8, "tay", AsmAddressingMode.NON, 2.0, "Yzn");
      addOpcode(0xa9, "lda", AsmAddressingMode.IMM, 2.0, "Azn");
      addOpcode(0xaa, "tax", AsmAddressingMode.NON, 2.0, "Xzn");
      addOpcode(0xac, "ldy", AsmAddressingMode.ABS, 4.0, "Yzn");
      addOpcode(0xad, "lda", AsmAddressingMode.ABS, 4.0, "Azn");
      addOpcode(0xae, "ldx", AsmAddressingMode.ABS, 4.0, "Xzn");
      addOpcode(0xb0, "bcs", AsmAddressingMode.REL, 2.5, "P");
      addOpcode(0xb1, "lda", AsmAddressingMode.IZY, 5.5, "Azn");
      addOpcode(0xb4, "ldy", AsmAddressingMode.ZPX, 4.0, "Yzn");
      addOpcode(0xb5, "lda", AsmAddressingMode.ZPX, 4.0, "Azn");
      addOpcode(0xb6, "ldx", AsmAddressingMode.ZPY, 4.0, "Xzn");
      addOpcode(0xb8, "clv", AsmAddressingMode.NON, 2.0, "v");
      addOpcode(0xb9, "lda", AsmAddressingMode.ABY, 4.5, "Azn");
      addOpcode(0xba, "tsx", AsmAddressingMode.NON, 2.0, "Xzn");
      addOpcode(0xbc, "ldy", AsmAddressingMode.ABX, 4.5, "Yzn");
      addOpcode(0xbd, "lda", AsmAddressingMode.ABX, 4.5, "Azn");
      addOpcode(0xbe, "ldx", AsmAddressingMode.ABY, 4.5, "Xzn");
      addOpcode(0xc0, "cpy", AsmAddressingMode.IMM, 2.0, "czn");
      addOpcode(0xc1, "cmp", AsmAddressingMode.IZX, 6.0, "czn");
      addOpcode(0xc4, "cpy", AsmAddressingMode.ZP, 3.0, "czn");
      addOpcode(0xc5, "cmp", AsmAddressingMode.ZP, 3.0, "czn");
      addOpcode(0xc6, "dec", AsmAddressingMode.ZP, 5.0, "zn");
      addOpcode(0xc8, "iny", AsmAddressingMode.NON, 2.0, "Yzn");
      addOpcode(0xc9, "cmp", AsmAddressingMode.IMM, 2.0, "czn");
      addOpcode(0xca, "dex", AsmAddressingMode.NON, 2.0, "Xzn");
      addOpcode(0xcc, "cpy", AsmAddressingMode.ABS, 4.0, "czn");
      addOpcode(0xcd, "cmp", AsmAddressingMode.ABS, 4.0, "czn");
      addOpcode(0xce, "dec", AsmAddressingMode.ABS, 6.0, "zn");
      addOpcode(0xd0, "bne", AsmAddressingMode.REL, 2.5, "P");
      addOpcode(0xd1, "cmp", AsmAddressingMode.IZY, 5.5, "czn");
      addOpcode(0xd5, "cmp", AsmAddressingMode.ZPX, 4.0, "czn");
      addOpcode(0xd6, "dec", AsmAddressingMode.ZPX, 6.0, "zn");
      addOpcode(0xd8, "cld", AsmAddressingMode.NON, 2.0, "d");
      addOpcode(0xd9, "cmp", AsmAddressingMode.ABY, 4.5, "czn");
      addOpcode(0xdd, "cmp", AsmAddressingMode.ABX, 4.5, "czn");
      addOpcode(0xde, "dec", AsmAddressingMode.ABX, 7.0, "zn");
      addOpcode(0xe0, "cpx", AsmAddressingMode.IMM, 2.0, "czn");
      addOpcode(0xe1, "sbc", AsmAddressingMode.IZX, 6.0, "Acvzn");
      addOpcode(0xe4, "cpx", AsmAddressingMode.ZP, 3.0, "czn");
      addOpcode(0xe5, "sbc", AsmAddressingMode.ZP, 3.0, "Acvzn");
      addOpcode(0xe6, "inc", AsmAddressingMode.ZP, 5.0, "zn");
      addOpcode(0xe8, "inx", AsmAddressingMode.NON, 2.0, "Xzn");
      addOpcode(0xe9, "sbc", AsmAddressingMode.IMM, 2.0, "Acvzn");
      addOpcode(0xea, "nop", AsmAddressingMode.NON, 2.0, "");
      addOpcode(0xec, "cpx", AsmAddressingMode.ABS, 4.0, "czn");
      addOpcode(0xed, "sbc", AsmAddressingMode.ABS, 4.0, "Acvzn");
      addOpcode(0xee, "inc", AsmAddressingMode.ABS, 6.0, "zn");
      addOpcode(0xf0, "beq", AsmAddressingMode.REL, 2.5, "P");
      addOpcode(0xf1, "sbc", AsmAddressingMode.IZY, 5.5, "Acvzn");
      addOpcode(0xf5, "sbc", AsmAddressingMode.ZPX, 4.0, "Acvzn");
      addOpcode(0xf6, "inc", AsmAddressingMode.ZPX, 6.0, "zn");
      addOpcode(0xf8, "sed", AsmAddressingMode.NON, 2.0, "d");
      addOpcode(0xf9, "sbc", AsmAddressingMode.ABY, 4.5, "Acvzn");
      addOpcode(0xfd, "sbc", AsmAddressingMode.ABX, 4.5, "Acvzn");
      addOpcode(0xfe, "inc", AsmAddressingMode.ABX, 7.0, "zn");
   }

}
