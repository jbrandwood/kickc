package dk.camelot64.cpufamily6502.cpus;

import dk.camelot64.cpufamily6502.Cpu65xx;
import dk.camelot64.cpufamily6502.CpuAddressingMode;

/**
 * The 45GS02 instruction set.
 * https://github.com/MEGA65/mega65-user-guide/blob/master/MEGA65-Book_draft.pdf
 */
public class Cpu45GS02 extends Cpu65xx {

   /** The 45GS02 CPU name. */
   public final static String NAME = "45gs02";

   /** The 45GS02 CPU. */
   public final static Cpu45GS02 INSTANCE = new Cpu45GS02();

   public Cpu45GS02() {
      super(NAME, Cpu65CE02.INSTANCE, true);

      addOpcode( new int[] {0x42, 0x42, 0x5},"orq",CpuAddressingMode.ZP,8,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0x6},"aslq",CpuAddressingMode.ZP,12,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0xA},"aslq",CpuAddressingMode.NON,3,"AXYZcnz");
      addOpcode( new int[] {0x42, 0x42, 0xD},"orq",CpuAddressingMode.ABS,9,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0xE},"aslq",CpuAddressingMode.ABS,13,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x12},"orq",CpuAddressingMode.INZ,10,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0x16},"aslq",CpuAddressingMode.ZPX,13,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x1A},"inq",CpuAddressingMode.NON,3,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0x1E},"aslq",CpuAddressingMode.ABX,13,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x24},"bitq",CpuAddressingMode.ZP,8,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x25},"andq",CpuAddressingMode.ZP,8,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0x26},"rolq",CpuAddressingMode.ZP,12,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x2A},"rolq",CpuAddressingMode.NON,3,"AXYZcnz");
      addOpcode( new int[] {0x42, 0x42, 0x2C},"bitq",CpuAddressingMode.ABS,8,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x2D},"andq",CpuAddressingMode.ABS,9,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0x2E},"rolq",CpuAddressingMode.ABS,13,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x32},"andq",CpuAddressingMode.INZ,10,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0x36},"rolq",CpuAddressingMode.ZPX,12,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x3A},"deq",CpuAddressingMode.NON,3,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0x3E},"rolq",CpuAddressingMode.ABX,13,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x43},"asrq",CpuAddressingMode.NON,3,"AXYZcnz");
      addOpcode( new int[] {0x42, 0x42, 0x44},"asrq",CpuAddressingMode.ZP,12,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x45},"eorq",CpuAddressingMode.ZP,8,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0x46},"lsrq",CpuAddressingMode.ZP,12,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x4A},"lsrq",CpuAddressingMode.NON,3,"AXYZcnz");
      addOpcode( new int[] {0x42, 0x42, 0x4D},"eorq",CpuAddressingMode.ABS,9,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0x4E},"lsrq",CpuAddressingMode.ABS,13,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x52},"eorq",CpuAddressingMode.INZ,10,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0x54},"asrq",CpuAddressingMode.ZPX,12,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x56},"lsrq",CpuAddressingMode.ZPX,12,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x5E},"lsrq",CpuAddressingMode.ABX,13,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x65},"adcq",CpuAddressingMode.ZP,8,"AXYZcvnz");
      addOpcode( new int[] {0x42, 0x42, 0x66},"rorq",CpuAddressingMode.ZP,12,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x6A},"rorq",CpuAddressingMode.NON,3,"AXYZcnz");
      addOpcode( new int[] {0x42, 0x42, 0x6D},"adcq",CpuAddressingMode.ABS,9,"AXYZcvnz");
      addOpcode( new int[] {0x42, 0x42, 0x6E},"rorq",CpuAddressingMode.ABS,13,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x72},"adcq",CpuAddressingMode.INZ,10,"AXYZcvnz");
      addOpcode( new int[] {0x42, 0x42, 0x76},"rorq",CpuAddressingMode.ZPX,12,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x7E},"rorq",CpuAddressingMode.ABX,13,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0x82},"stq",CpuAddressingMode.ISY,10,"");
      addOpcode( new int[] {0x42, 0x42, 0x85},"stq",CpuAddressingMode.ZP,8,"");
      addOpcode( new int[] {0x42, 0x42, 0x8D},"stq",CpuAddressingMode.ABS,9,"");
      addOpcode( new int[] {0x42, 0x42, 0x92},"stq",CpuAddressingMode.INZ,10,"");
      addOpcode( new int[] {0x42, 0x42, 0xA1},"ldq",CpuAddressingMode.IZX,10,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0xA5},"ldq",CpuAddressingMode.ZP,8,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0xAD},"ldq",CpuAddressingMode.ABS,9,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0xB1},"ldq",CpuAddressingMode.IZY,10,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0xB2},"ldq",CpuAddressingMode.IZZ,10,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0xB5},"ldq",CpuAddressingMode.ZPX,9,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0xB9},"ldq",CpuAddressingMode.ABY,10,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0xBD},"ldq",CpuAddressingMode.ABX,10,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0xC5},"cpq",CpuAddressingMode.ZP,8,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0xC6},"deq",CpuAddressingMode.ZP,12,"nz");
      addOpcode( new int[] {0x42, 0x42, 0xCD},"cpq",CpuAddressingMode.ABS,9,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0xCE},"deq",CpuAddressingMode.ABS,13,"nz");
      addOpcode( new int[] {0x42, 0x42, 0xD2},"cpq",CpuAddressingMode.INZ,10,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0xD6},"deq",CpuAddressingMode.ZPX,12,"nz");
      addOpcode( new int[] {0x42, 0x42, 0xDE},"deq",CpuAddressingMode.ABX,13,"nz");
      addOpcode( new int[] {0x42, 0x42, 0xE2},"ldq",CpuAddressingMode.ISY,10,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0xE5},"sbcq",CpuAddressingMode.ZP,8,"AXYZcvnz");
      addOpcode( new int[] {0x42, 0x42, 0xE6},"inq",CpuAddressingMode.ZP,13,"nz");
      addOpcode( new int[] {0x42, 0x42, 0xea, 0x12},"orq",CpuAddressingMode.LIN,13,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0xea, 0x32},"andq",CpuAddressingMode.LIN,13,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0xea, 0x52},"eorq",CpuAddressingMode.LIN,13,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0xea, 0x72},"adcq",CpuAddressingMode.LIN,13,"AXYZcvnz");
      addOpcode( new int[] {0x42, 0x42, 0xea, 0x92},"stq",CpuAddressingMode.LIN,13,"");
      addOpcode( new int[] {0x42, 0x42, 0xea, 0xB2},"ldq",CpuAddressingMode.LIZ,13,"AXYZnz");
      addOpcode( new int[] {0x42, 0x42, 0xea, 0xD2},"cpq",CpuAddressingMode.LIN,13,"cnz");
      addOpcode( new int[] {0x42, 0x42, 0xea, 0xF2},"sbcq",CpuAddressingMode.LIN,13,"AXYZcvnz");
      addOpcode( new int[] {0x42, 0x42, 0xED},"sbcq",CpuAddressingMode.ABS,9,"AXYZcvnz");
      addOpcode( new int[] {0x42, 0x42, 0xEE},"inq",CpuAddressingMode.ABS,14,"nz");
      addOpcode( new int[] {0x42, 0x42, 0xF2},"sbcq",CpuAddressingMode.INZ,10,"AXYZcvnz");
      addOpcode( new int[] {0x42, 0x42, 0xF6},"inq",CpuAddressingMode.ZPX,13,"nz");
      addOpcode( new int[] {0x42, 0x42, 0xFE},"inq",CpuAddressingMode.ABX,14,"nz");
      addOpcode( new int[] {0xea, 0x12},"ora",CpuAddressingMode.LIZ,7,"Anz");
      addOpcode( new int[] {0xea, 0x32},"and",CpuAddressingMode.LIZ,7,"Anz");
      addOpcode( new int[] {0xea, 0x52},"eor",CpuAddressingMode.LIZ,7,"Anz");
      addOpcode( new int[] {0xea, 0x72},"adc",CpuAddressingMode.LIZ,7,"Acvnz");
      addOpcode( new int[] {0xea, 0x92},"sta",CpuAddressingMode.LIZ,8,"");
      addOpcode( new int[] {0xea, 0xB2},"lda",CpuAddressingMode.LIZ,7,"Anz");
      addOpcode( new int[] {0xea, 0xD2},"cmp",CpuAddressingMode.LIZ,7,"cnz");
      addOpcode( new int[] {0xea, 0xF2},"sbc",CpuAddressingMode.LIZ,8,"Acvnz");

      // TODO: Disable NOP?
   }

}
