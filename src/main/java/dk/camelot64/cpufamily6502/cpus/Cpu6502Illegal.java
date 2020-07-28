package dk.camelot64.cpufamily6502.cpus;

import dk.camelot64.cpufamily6502.CpuAddressingMode;
import dk.camelot64.cpufamily6502.Cpu65xx;

/**
 * The 6502 instruction set including illegal instructions.
 * http://www.oxyron.de/html/opcodes02.html
 */
public class Cpu6502Illegal extends Cpu65xx {

   /** The 6502 with illegal instructions CPU name. */
   public final static String NAME = "6502x";

   /** The 6502 with illegal instructions CPU. */
   public final static Cpu6502Illegal INSTANCE = new Cpu6502Illegal();

   public Cpu6502Illegal() {
      super(NAME, Cpu6502Official.INSTANCE);
      addOpcode(0x03, "slo", CpuAddressingMode.IZX, 8.0, "Aczn");
      addOpcode(0x07, "slo", CpuAddressingMode.ZP, 5.0, "Aczn");
      addOpcode(0x0b, "anc", CpuAddressingMode.IMM, 2.0, "Aczn");
      addOpcode(0x0f, "slo", CpuAddressingMode.ABS, 6.0, "Aczn");
      addOpcode(0x13, "slo", CpuAddressingMode.IZY, 8.0, "Aczn");
      addOpcode(0x17, "slo", CpuAddressingMode.ZPX, 6.0, "Aczn");
      addOpcode(0x1b, "slo", CpuAddressingMode.ABY, 7.0, "Aczn");
      addOpcode(0x1f, "slo", CpuAddressingMode.ABX, 7.0, "Aczn");
      addOpcode(0x23, "rla", CpuAddressingMode.IZX, 8.0, "Aczn");
      addOpcode(0x27, "rla", CpuAddressingMode.ZP, 5.0, "Aczn");
      addOpcode(0x2b, "anc", CpuAddressingMode.IMM, 2.0, "Aczn");
      addOpcode(0x2f, "rla", CpuAddressingMode.ABS, 6.0, "Aczn");
      addOpcode(0x33, "rla", CpuAddressingMode.IZY, 8.0, "Aczn");
      addOpcode(0x37, "rla", CpuAddressingMode.ZPX, 6.0, "Aczn");
      addOpcode(0x3b, "rla", CpuAddressingMode.ABY, 7.0, "Aczn");
      addOpcode(0x3f, "rla", CpuAddressingMode.ABX, 7.0, "Aczn");
      addOpcode(0x43, "sre", CpuAddressingMode.IZX, 8.0, "Aczn");
      addOpcode(0x47, "sre", CpuAddressingMode.ZP, 5.0, "Aczn");
      addOpcode(0x4b, "alr", CpuAddressingMode.IMM, 2.0, "Aczn");
      addOpcode(0x4f, "sre", CpuAddressingMode.ABS, 6.0, "Aczn");
      addOpcode(0x53, "sre", CpuAddressingMode.IZY, 8.0, "Aczn");
      addOpcode(0x57, "sre", CpuAddressingMode.ZPX, 6.0, "Aczn");
      addOpcode(0x5b, "sre", CpuAddressingMode.ABY, 7.0, "Aczn");
      addOpcode(0x5f, "sre", CpuAddressingMode.ABX, 7.0, "Aczn");
      addOpcode(0x63, "rra", CpuAddressingMode.IZX, 8.0, "Acvzn");
      addOpcode(0x67, "rra", CpuAddressingMode.ZP, 5.0, "Acvzn");
      addOpcode(0x6b, "arr", CpuAddressingMode.IMM, 2.0, "Acvzn");
      addOpcode(0x6f, "rra", CpuAddressingMode.ABS, 6.0, "Acvzn");
      addOpcode(0x73, "rra", CpuAddressingMode.IZY, 8.0, "Acvzn");
      addOpcode(0x77, "rra", CpuAddressingMode.ZPX, 6.0, "Acvzn");
      addOpcode(0x7b, "rra", CpuAddressingMode.ABY, 7.0, "Acvzn");
      addOpcode(0x7f, "rra", CpuAddressingMode.ABX, 7.0, "Acvzn");
      addOpcode(0x83, "sax", CpuAddressingMode.IZX, 6.0, "");
      addOpcode(0x87, "sax", CpuAddressingMode.ZP, 3.0, "");
      addOpcode(0x8b, "xaa", CpuAddressingMode.IMM, 2.0, "Azn");
      addOpcode(0x8f, "sax", CpuAddressingMode.ABS, 4.0, "");
      addOpcode(0x93, "ahx", CpuAddressingMode.IZY, 6.0, "");
      addOpcode(0x97, "sax", CpuAddressingMode.ZPY, 4.0, "");
      addOpcode(0x9b, "tas", CpuAddressingMode.ABY, 5.0, "");
      addOpcode(0x9c, "shy", CpuAddressingMode.ABX, 5.0, "");
      addOpcode(0x9e, "shx", CpuAddressingMode.ABY, 5.0, "");
      addOpcode(0x9f, "ahx", CpuAddressingMode.ABY, 5.0, "");
      addOpcode(0xa3, "lax", CpuAddressingMode.IZX, 6.0, "AXzn");
      addOpcode(0xa7, "lax", CpuAddressingMode.ZP, 3.0, "AXzn");
      addOpcode(0xab, "lax", CpuAddressingMode.IMM, 2.0, "AXzn");
      addOpcode(0xaf, "lax", CpuAddressingMode.ABS, 4.0, "AXzn");
      addOpcode(0xb3, "lax", CpuAddressingMode.IZY, 5.5, "AXzn");
      addOpcode(0xb7, "lax", CpuAddressingMode.ZPY, 4.0, "AXzn");
      addOpcode(0xbb, "las", CpuAddressingMode.ABY, 4.5, "AXzn");
      addOpcode(0xbf, "lax", CpuAddressingMode.ABY, 4.5, "AXzn");
      addOpcode(0xc3, "dcp", CpuAddressingMode.IZX, 8.0, "czn");
      addOpcode(0xc7, "dcp", CpuAddressingMode.ZP, 5.0, "czn");
      addOpcode(0xcb, "axs", CpuAddressingMode.IMM, 2.0, "Xczn");
      addOpcode(0xcf, "dcp", CpuAddressingMode.ABS, 6.0, "czn");
      addOpcode(0xd3, "dcp", CpuAddressingMode.IZY, 8.0, "czn");
      addOpcode(0xd7, "dcp", CpuAddressingMode.ZPX, 6.0, "czn");
      addOpcode(0xdb, "dcp", CpuAddressingMode.ABY, 7.0, "czn");
      addOpcode(0xe2, "isc", CpuAddressingMode.IZX, 8.0, "Acvzn");
      addOpcode(0xe6, "isc", CpuAddressingMode.ZP, 5.0, "Acvzn");
      addOpcode(0xea, "sbc", CpuAddressingMode.IMM, 2.0, "Acvzn");
      addOpcode(0xee, "isc", CpuAddressingMode.ABS, 6.0, "Acvzn");
      addOpcode(0xef, "dcp", CpuAddressingMode.ABX, 7.0, "czn");
      addOpcode(0xf3, "isc", CpuAddressingMode.IZY, 8.0, "Acvzn");
      addOpcode(0xf7, "isc", CpuAddressingMode.ZPX, 6.0, "Acvzn");
      addOpcode(0xfb, "isc", CpuAddressingMode.ABY, 7.0, "Acvzn");
      addOpcode(0xff, "isc", CpuAddressingMode.ABX, 7.0, "Acvzn");
   }

}
