package dk.camelot64.cpufamily6502.cpus;

import dk.camelot64.cpufamily6502.AsmAddressingMode;
import dk.camelot64.cpufamily6502.AsmCpu;

/**
 * The 6502 instruction set including illegal instructions.
 * http://www.oxyron.de/html/opcodes02.html
 */
public class Cpu6502Illegal extends AsmCpu {

   /** The 6502 with illegal instructions CPU name. */
   public final static String NAME = "6502x";

   /** The 6502 with illegal instructions CPU. */
   public final static Cpu6502Illegal INSTANCE = new Cpu6502Illegal();

   public Cpu6502Illegal() {
      super(NAME, Cpu6502Official.INSTANCE);
      addOpcode(0x03, "slo", AsmAddressingMode.IZX, 8.0, "Aczn");
      addOpcode(0x07, "slo", AsmAddressingMode.ZP, 5.0, "Aczn");
      addOpcode(0x0b, "anc", AsmAddressingMode.IMM, 2.0, "Aczn");
      addOpcode(0x0f, "slo", AsmAddressingMode.ABS, 6.0, "Aczn");
      addOpcode(0x13, "slo", AsmAddressingMode.IZY, 8.0, "Aczn");
      addOpcode(0x17, "slo", AsmAddressingMode.ZPX, 6.0, "Aczn");
      addOpcode(0x1b, "slo", AsmAddressingMode.ABY, 7.0, "Aczn");
      addOpcode(0x1f, "slo", AsmAddressingMode.ABX, 7.0, "Aczn");
      addOpcode(0x23, "rla", AsmAddressingMode.IZX, 8.0, "Aczn");
      addOpcode(0x27, "rla", AsmAddressingMode.ZP, 5.0, "Aczn");
      addOpcode(0x2b, "anc", AsmAddressingMode.IMM, 2.0, "Aczn");
      addOpcode(0x2f, "rla", AsmAddressingMode.ABS, 6.0, "Aczn");
      addOpcode(0x33, "rla", AsmAddressingMode.IZY, 8.0, "Aczn");
      addOpcode(0x37, "rla", AsmAddressingMode.ZPX, 6.0, "Aczn");
      addOpcode(0x3b, "rla", AsmAddressingMode.ABY, 7.0, "Aczn");
      addOpcode(0x3f, "rla", AsmAddressingMode.ABX, 7.0, "Aczn");
      addOpcode(0x43, "sre", AsmAddressingMode.IZX, 8.0, "Aczn");
      addOpcode(0x47, "sre", AsmAddressingMode.ZP, 5.0, "Aczn");
      addOpcode(0x4b, "alr", AsmAddressingMode.IMM, 2.0, "Aczn");
      addOpcode(0x4f, "sre", AsmAddressingMode.ABS, 6.0, "Aczn");
      addOpcode(0x53, "sre", AsmAddressingMode.IZY, 8.0, "Aczn");
      addOpcode(0x57, "sre", AsmAddressingMode.ZPX, 6.0, "Aczn");
      addOpcode(0x5b, "sre", AsmAddressingMode.ABY, 7.0, "Aczn");
      addOpcode(0x5f, "sre", AsmAddressingMode.ABX, 7.0, "Aczn");
      addOpcode(0x63, "rra", AsmAddressingMode.IZX, 8.0, "Acvzn");
      addOpcode(0x67, "rra", AsmAddressingMode.ZP, 5.0, "Acvzn");
      addOpcode(0x6b, "arr", AsmAddressingMode.IMM, 2.0, "Acvzn");
      addOpcode(0x6f, "rra", AsmAddressingMode.ABS, 6.0, "Acvzn");
      addOpcode(0x73, "rra", AsmAddressingMode.IZY, 8.0, "Acvzn");
      addOpcode(0x77, "rra", AsmAddressingMode.ZPX, 6.0, "Acvzn");
      addOpcode(0x7b, "rra", AsmAddressingMode.ABY, 7.0, "Acvzn");
      addOpcode(0x7f, "rra", AsmAddressingMode.ABX, 7.0, "Acvzn");
      addOpcode(0x83, "sax", AsmAddressingMode.IZX, 6.0, "");
      addOpcode(0x87, "sax", AsmAddressingMode.ZP, 3.0, "");
      addOpcode(0x8b, "xaa", AsmAddressingMode.IMM, 2.0, "Azn");
      addOpcode(0x8f, "sax", AsmAddressingMode.ABS, 4.0, "");
      addOpcode(0x93, "ahx", AsmAddressingMode.IZY, 6.0, "");
      addOpcode(0x97, "sax", AsmAddressingMode.ZPY, 4.0, "");
      addOpcode(0x9b, "tas", AsmAddressingMode.ABY, 5.0, "");
      addOpcode(0x9c, "shy", AsmAddressingMode.ABX, 5.0, "");
      addOpcode(0x9e, "shx", AsmAddressingMode.ABY, 5.0, "");
      addOpcode(0x9f, "ahx", AsmAddressingMode.ABY, 5.0, "");
      addOpcode(0xa3, "lax", AsmAddressingMode.IZX, 6.0, "AXzn");
      addOpcode(0xa7, "lax", AsmAddressingMode.ZP, 3.0, "AXzn");
      addOpcode(0xab, "lax", AsmAddressingMode.IMM, 2.0, "AXzn");
      addOpcode(0xaf, "lax", AsmAddressingMode.ABS, 4.0, "AXzn");
      addOpcode(0xb3, "lax", AsmAddressingMode.IZY, 5.5, "AXzn");
      addOpcode(0xb7, "lax", AsmAddressingMode.ZPY, 4.0, "AXzn");
      addOpcode(0xbb, "las", AsmAddressingMode.ABY, 4.5, "AXzn");
      addOpcode(0xbf, "lax", AsmAddressingMode.ABY, 4.5, "AXzn");
      addOpcode(0xc3, "dcp", AsmAddressingMode.IZX, 8.0, "czn");
      addOpcode(0xc7, "dcp", AsmAddressingMode.ZP, 5.0, "czn");
      addOpcode(0xcb, "axs", AsmAddressingMode.IMM, 2.0, "Xczn");
      addOpcode(0xcf, "dcp", AsmAddressingMode.ABS, 6.0, "czn");
      addOpcode(0xd3, "dcp", AsmAddressingMode.IZY, 8.0, "czn");
      addOpcode(0xd7, "dcp", AsmAddressingMode.ZPX, 6.0, "czn");
      addOpcode(0xdb, "dcp", AsmAddressingMode.ABY, 7.0, "czn");
      addOpcode(0xe2, "isc", AsmAddressingMode.IZX, 8.0, "Acvzn");
      addOpcode(0xe6, "isc", AsmAddressingMode.ZP, 5.0, "Acvzn");
      addOpcode(0xea, "sbc", AsmAddressingMode.IMM, 2.0, "Acvzn");
      addOpcode(0xee, "isc", AsmAddressingMode.ABS, 6.0, "Acvzn");
      addOpcode(0xef, "dcp", AsmAddressingMode.ABX, 7.0, "czn");
      addOpcode(0xf3, "isc", AsmAddressingMode.IZY, 8.0, "Acvzn");
      addOpcode(0xf7, "isc", AsmAddressingMode.ZPX, 6.0, "Acvzn");
      addOpcode(0xfb, "isc", AsmAddressingMode.ABY, 7.0, "Acvzn");
      addOpcode(0xff, "isc", AsmAddressingMode.ABX, 7.0, "Acvzn");
   }

}
