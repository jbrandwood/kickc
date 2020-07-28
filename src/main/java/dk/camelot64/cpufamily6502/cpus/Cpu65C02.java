package dk.camelot64.cpufamily6502.cpus;

import dk.camelot64.cpufamily6502.AsmAddressingMode;
import dk.camelot64.cpufamily6502.AsmCpu;

/**
 * The 65C02 instruction set.
 * https://eater.net/datasheets/w65c02s.pdf
 */
public class Cpu65C02 extends AsmCpu {

   /** The 65C02 CPU name. */
   public final static String NAME = "65c02";

   /** The 65C02 with illegal CPU. */
   public final static Cpu65C02 INSTANCE = new Cpu65C02();

   public Cpu65C02() {
      super(NAME, Cpu6502Official.INSTANCE);
      addOpcode(0x4,"tsb",AsmAddressingMode.ZP,5,"z");
      addOpcode(0x7,"rmb0",AsmAddressingMode.ZP,5,"");
      addOpcode(0xC,"tsb",AsmAddressingMode.ABS,6,"z");
      addOpcode(0xF,"bbr0",AsmAddressingMode.REZ,5,"");
      addOpcode(0x12,"ora",AsmAddressingMode.INZ,5,"Anz");
      addOpcode(0x14,"trb",AsmAddressingMode.ZP,5,"z");
      addOpcode(0x17,"rmb1",AsmAddressingMode.ZP,5,"");
      addOpcode(0x1A,"inc",AsmAddressingMode.NON,2,"Anz");
      addOpcode(0x1C,"trb",AsmAddressingMode.ABS,6,"z");
      addOpcode(0x1F,"bbr1",AsmAddressingMode.REZ,5,"");
      addOpcode(0x27,"rmb2",AsmAddressingMode.ZP,5,"");
      addOpcode(0x2F,"bbr2",AsmAddressingMode.REZ,5,"");
      addOpcode(0x32,"and",AsmAddressingMode.INZ,5,"Anz");
      addOpcode(0x34,"bit",AsmAddressingMode.ZPX,4,"nvz");
      addOpcode(0x37,"rmb3",AsmAddressingMode.ZP,5,"");
      addOpcode(0x3A,"dec",AsmAddressingMode.NON,2,"Anz");
      addOpcode(0x3C,"bit",AsmAddressingMode.ZPX,4.5,"nvz");
      addOpcode(0x3F,"bbr3",AsmAddressingMode.REZ,5,"");
      addOpcode(0x47,"rmb4",AsmAddressingMode.ZP,5,"");
      addOpcode(0x4F,"bbr4",AsmAddressingMode.REZ,5,"");
      addOpcode(0x52,"eor",AsmAddressingMode.INZ,5,"Anz");
      addOpcode(0x57,"rmb5",AsmAddressingMode.ZP,5,"");
      addOpcode(0x5A,"phy",AsmAddressingMode.NON,3,"");
      addOpcode(0x5F,"bbr5",AsmAddressingMode.REZ,5,"");
      addOpcode(0x64,"stz",AsmAddressingMode.ZP,3,"");
      addOpcode(0x67,"rmb6",AsmAddressingMode.ZP,5,"");
      addOpcode(0x6F,"bbr6",AsmAddressingMode.REZ,5,"");
      addOpcode(0x72,"adc",AsmAddressingMode.INZ,5,"Acvnz");
      addOpcode(0x74,"stz",AsmAddressingMode.ZPX,4,"");
      addOpcode(0x77,"rmb7",AsmAddressingMode.ZP,5,"");
      addOpcode(0x7A,"ply",AsmAddressingMode.NON,4,"Ynz");
      addOpcode(0x7C,"jmp",AsmAddressingMode.IAX,6,"");
      addOpcode(0x7F,"bbr7",AsmAddressingMode.REZ,5,"");
      addOpcode(0x80,"bra",AsmAddressingMode.NON,3,"");
      addOpcode(0x87,"smb0",AsmAddressingMode.ZP,5,"");
      addOpcode(0x89,"bit",AsmAddressingMode.IAX,2,"z");
      addOpcode(0x8F,"bbs0",AsmAddressingMode.REZ,5,"");
      addOpcode(0x92,"sta",AsmAddressingMode.INZ,5,"");
      addOpcode(0x97,"smb1",AsmAddressingMode.ZP,5,"");
      addOpcode(0x9C,"stz",AsmAddressingMode.ABS,4,"");
      addOpcode(0x9E,"stz",AsmAddressingMode.ZPX,5,"");
      addOpcode(0x9F,"bbs1",AsmAddressingMode.REZ,5,"");
      addOpcode(0xA7,"smb2",AsmAddressingMode.ZP,5,"");
      addOpcode(0xAF,"bbs2",AsmAddressingMode.REZ,5,"");
      addOpcode(0xB2,"lda",AsmAddressingMode.INZ,5,"Anz");
      addOpcode(0xB7,"smb3",AsmAddressingMode.ZP,5,"");
      addOpcode(0xBF,"bbs3",AsmAddressingMode.REZ,5,"");
      addOpcode(0xC7,"smb4",AsmAddressingMode.ZP,5,"");
      addOpcode(0xCB,"wai",AsmAddressingMode.NON,3,"");
      addOpcode(0xCF,"bbs4",AsmAddressingMode.REZ,5,"");
      addOpcode(0xD2,"cmp",AsmAddressingMode.INZ,5,"cnz");
      addOpcode(0xD7,"smb5",AsmAddressingMode.ZP,5,"");
      addOpcode(0xDA,"phx",AsmAddressingMode.NON,3,"");
      addOpcode(0xDB,"stp",AsmAddressingMode.NON,3,"");
      addOpcode(0xDF,"bbs5",AsmAddressingMode.REZ,5,"");
      addOpcode(0xE7,"smb6",AsmAddressingMode.ZP,5,"");
      addOpcode(0xEF,"bbs6",AsmAddressingMode.REZ,5,"");
      addOpcode(0xF2,"sbc",AsmAddressingMode.INZ,5,"Acvnz");
      addOpcode(0xF7,"smb7",AsmAddressingMode.ZP,5,"");
      addOpcode(0xFA,"plx",AsmAddressingMode.NON,4,"Xnz");
      addOpcode(0xFF,"bbs7",AsmAddressingMode.REZ,5,"");

      // TODO: Cycle differences for   ASL LSR ROL ROR abs,X - http://6502.org/tutorials/65c02opcodes.html
   }

}
