package dk.camelot64.cpufamily6502.cpus;

import dk.camelot64.cpufamily6502.CpuAddressingMode;
import dk.camelot64.cpufamily6502.Cpu65xx;

/**
 * The 65C02 instruction set.
 * https://eater.net/datasheets/w65c02s.pdf
 */
public class Cpu65C02 extends Cpu65xx {

   /** The 65C02 CPU name. */
   public final static String NAME = "65c02";

   /** The 65C02 CPU. */
   public final static Cpu65C02 INSTANCE = new Cpu65C02();

   public Cpu65C02() {
      super(NAME, Cpu6502Official.INSTANCE);
      addOpcode(0x4,"tsb", CpuAddressingMode.ZP,5,"z");
      addOpcode(0x7,"rmb0", CpuAddressingMode.ZP,5,"");
      addOpcode(0xC,"tsb", CpuAddressingMode.ABS,6,"z");
      addOpcode(0xF,"bbr0", CpuAddressingMode.REZ,5,"");
      addOpcode(0x12,"ora", CpuAddressingMode.INZ,5,"Anz");
      addOpcode(0x14,"trb", CpuAddressingMode.ZP,5,"z");
      addOpcode(0x17,"rmb1", CpuAddressingMode.ZP,5,"");
      addOpcode(0x1A,"inc", CpuAddressingMode.NON,2,"Anz");
      addOpcode(0x1C,"trb", CpuAddressingMode.ABS,6,"z");
      addOpcode(0x1F,"bbr1", CpuAddressingMode.REZ,5,"");
      addOpcode(0x27,"rmb2", CpuAddressingMode.ZP,5,"");
      addOpcode(0x2F,"bbr2", CpuAddressingMode.REZ,5,"");
      addOpcode(0x32,"and", CpuAddressingMode.INZ,5,"Anz");
      addOpcode(0x34,"bit", CpuAddressingMode.ZPX,4,"nvz");
      addOpcode(0x37,"rmb3", CpuAddressingMode.ZP,5,"");
      addOpcode(0x3A,"dec", CpuAddressingMode.NON,2,"Anz");
      addOpcode(0x3C,"bit", CpuAddressingMode.ZPX,4.5,"nvz");
      addOpcode(0x3F,"bbr3", CpuAddressingMode.REZ,5,"");
      addOpcode(0x47,"rmb4", CpuAddressingMode.ZP,5,"");
      addOpcode(0x4F,"bbr4", CpuAddressingMode.REZ,5,"");
      addOpcode(0x52,"eor", CpuAddressingMode.INZ,5,"Anz");
      addOpcode(0x57,"rmb5", CpuAddressingMode.ZP,5,"");
      addOpcode(0x5A,"phy", CpuAddressingMode.NON,3,"");
      addOpcode(0x5F,"bbr5", CpuAddressingMode.REZ,5,"");
      addOpcode(0x64,"stz", CpuAddressingMode.ZP,3,"");
      addOpcode(0x67,"rmb6", CpuAddressingMode.ZP,5,"");
      addOpcode(0x6F,"bbr6", CpuAddressingMode.REZ,5,"");
      addOpcode(0x72,"adc", CpuAddressingMode.INZ,5,"Acvnz");
      addOpcode(0x74,"stz", CpuAddressingMode.ZPX,4,"");
      addOpcode(0x77,"rmb7", CpuAddressingMode.ZP,5,"");
      addOpcode(0x7A,"ply", CpuAddressingMode.NON,4,"Ynz");
      addOpcode(0x7C,"jmp", CpuAddressingMode.IAX,6,"");
      addOpcode(0x7F,"bbr7", CpuAddressingMode.REZ,5,"");
      addOpcode(0x80,"bra", CpuAddressingMode.NON,3,"");
      addOpcode(0x87,"smb0", CpuAddressingMode.ZP,5,"");
      addOpcode(0x89,"bit", CpuAddressingMode.IAX,2,"z");
      addOpcode(0x8F,"bbs0", CpuAddressingMode.REZ,5,"");
      addOpcode(0x92,"sta", CpuAddressingMode.INZ,5,"");
      addOpcode(0x97,"smb1", CpuAddressingMode.ZP,5,"");
      addOpcode(0x9C,"stz", CpuAddressingMode.ABS,4,"");
      addOpcode(0x9E,"stz", CpuAddressingMode.ZPX,5,"");
      addOpcode(0x9F,"bbs1", CpuAddressingMode.REZ,5,"");
      addOpcode(0xA7,"smb2", CpuAddressingMode.ZP,5,"");
      addOpcode(0xAF,"bbs2", CpuAddressingMode.REZ,5,"");
      addOpcode(0xB2,"lda", CpuAddressingMode.INZ,5,"Anz");
      addOpcode(0xB7,"smb3", CpuAddressingMode.ZP,5,"");
      addOpcode(0xBF,"bbs3", CpuAddressingMode.REZ,5,"");
      addOpcode(0xC7,"smb4", CpuAddressingMode.ZP,5,"");
      addOpcode(0xCF,"bbs4", CpuAddressingMode.REZ,5,"");
      addOpcode(0xD2,"cmp", CpuAddressingMode.INZ,5,"cnz");
      addOpcode(0xD7,"smb5", CpuAddressingMode.ZP,5,"");
      addOpcode(0xDA,"phx", CpuAddressingMode.NON,3,"");
      addOpcode(0xDF,"bbs5", CpuAddressingMode.REZ,5,"");
      addOpcode(0xE7,"smb6", CpuAddressingMode.ZP,5,"");
      addOpcode(0xEF,"bbs6", CpuAddressingMode.REZ,5,"");
      addOpcode(0xF2,"sbc", CpuAddressingMode.INZ,5,"Acvnz");
      addOpcode(0xF7,"smb7", CpuAddressingMode.ZP,5,"");
      addOpcode(0xFA,"plx", CpuAddressingMode.NON,4,"Xnz");
      addOpcode(0xFF,"bbs7", CpuAddressingMode.REZ,5,"");

      // TODO: Cycle differences for ASL LSR ROL ROR abs,X - http://6502.org/tutorials/65c02opcodes.html

      // TODO: Maybe add the 65C02S CPU - which adds the following 2 instructions
      //addOpcode(0xCB,"wai", CpuAddressingMode.NON,3,"");
      //addOpcode(0xDB,"stp", CpuAddressingMode.NON,3,"");

   }

}
