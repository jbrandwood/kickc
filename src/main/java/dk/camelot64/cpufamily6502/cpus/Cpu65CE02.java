package dk.camelot64.cpufamily6502.cpus;

import dk.camelot64.cpufamily6502.Cpu65xx;
import dk.camelot64.cpufamily6502.CpuAddressingMode;

/**
 * The 65CE02 instruction set.
 * http://archive.6502.org/datasheets/mos_65ce02_mpu.pdf
 */
public class Cpu65CE02 extends Cpu65xx {

   /** The 65CE02 CPU name. */
   public final static String NAME = "65ce02";

   /** The 65CE02 CPU. */
   public final static Cpu65CE02 INSTANCE = new Cpu65CE02();

   public Cpu65CE02() {
      super(NAME, Cpu65C02.INSTANCE, true);

      // Remove all opcodes not present on 65CE02 - eg. (zp), which is changed to (zp),y
      removeOpcode("ora", CpuAddressingMode.INZ);
      removeOpcode("and", CpuAddressingMode.INZ);
      removeOpcode("eor", CpuAddressingMode.INZ);
      removeOpcode("adc", CpuAddressingMode.INZ);
      removeOpcode("sta", CpuAddressingMode.INZ);
      removeOpcode("lda", CpuAddressingMode.INZ);
      removeOpcode("cmp", CpuAddressingMode.INZ);
      removeOpcode("sbc", CpuAddressingMode.INZ);

      addOpcode(0x2,"cle",CpuAddressingMode.NON,2,"e");
      addOpcode(0x3,"see",CpuAddressingMode.NON,2,"e");
      addOpcode(0xB,"tsy",CpuAddressingMode.NON,1,"Ynz");
      addOpcode(0x12,"ora",CpuAddressingMode.IZZ,5,"Anz");
      addOpcode(0x13,"lbpl",CpuAddressingMode.REL,3,"P");
      addOpcode(0x1B,"inz",CpuAddressingMode.NON,1,"Znz");
      addOpcode(0x22,"jsr",CpuAddressingMode.IND,7,"PS");
      addOpcode(0x23,"jsr",CpuAddressingMode.IAX,7,"PS");
      addOpcode(0x2B,"tys",CpuAddressingMode.NON,1,"S");
      addOpcode(0x32,"and",CpuAddressingMode.IZZ,5,"Anz");
      addOpcode(0x33,"lbmi",CpuAddressingMode.REL,3,"P");
      addOpcode(0x3B,"dez",CpuAddressingMode.NON,1,"Znz");
      addOpcode(0x42,"neg",CpuAddressingMode.NON,2,"Anz");
      addOpcode(0x43,"asr",CpuAddressingMode.NON,2,"Acnz");
      addOpcode(0x44,"asr",CpuAddressingMode.ZP,4,"cnz");
      addOpcode(0x4B,"taz",CpuAddressingMode.NON,1,"Znz");
      addOpcode(0x52,"eor",CpuAddressingMode.IZZ,5,"Anz");
      addOpcode(0x53,"lbvc",CpuAddressingMode.REL,3,"P");
      addOpcode(0x54,"asr",CpuAddressingMode.ZPX,4,"cnz");
      addOpcode(0x5B,"tab",CpuAddressingMode.NON,1,"B");
      addOpcode(0x5C,"map",CpuAddressingMode.NON,2,"");
      addOpcode(0x62,"rtn",CpuAddressingMode.IMM,7,"P");
      addOpcode(0x63,"lbsr",CpuAddressingMode.REL,3,"P");
      addOpcode(0x6B,"tza",CpuAddressingMode.NON,1,"Anz");
      addOpcode(0x72,"adc",CpuAddressingMode.IZZ,5,"Acvnz");
      addOpcode(0x73,"lbvs",CpuAddressingMode.REL,3,"P");
      addOpcode(0x7B,"tba",CpuAddressingMode.NON,1,"Anz");
      addOpcode(0x82,"sta",CpuAddressingMode.ISY,6,"");
      addOpcode(0x83,"lbra",CpuAddressingMode.REL,3,"P");
      addOpcode(0x8B,"sty",CpuAddressingMode.ABX,4,"");
      addOpcode(0x92,"sta",CpuAddressingMode.IZZ,5,"");
      addOpcode(0x93,"lbcc",CpuAddressingMode.REL,3,"P");
      addOpcode(0x9B,"stx",CpuAddressingMode.ABY,4,"");
      addOpcode(0xA3,"ldz",CpuAddressingMode.IMM,2,"Znz");
      addOpcode(0xAB,"ldz",CpuAddressingMode.ABS,4,"Znz");
      addOpcode(0xB2,"lda",CpuAddressingMode.IZZ,5,"Anz");
      addOpcode(0xB3,"lbcs",CpuAddressingMode.REL,3,"P");
      addOpcode(0xBB,"ldz",CpuAddressingMode.ABX,4,"Znz");
      addOpcode(0xC2,"cpz",CpuAddressingMode.IMM,2,"cnz");
      addOpcode(0xC3,"dew",CpuAddressingMode.ABS,5,"nz");
      addOpcode(0xCB,"asw",CpuAddressingMode.ABS,7,"cnz");
      addOpcode(0xD2,"cmp",CpuAddressingMode.IZZ,5,"cnz");
      addOpcode(0xD3,"lbne",CpuAddressingMode.REL,3,"P");
      addOpcode(0xD4,"cpz",CpuAddressingMode.ZP,3,"cnz");
      addOpcode(0xDB,"phz",CpuAddressingMode.NON,3,"S");
      addOpcode(0xDC,"cpz",CpuAddressingMode.ABS,4,"cnz");
      addOpcode(0xE2,"lda",CpuAddressingMode.ISY,6,"Anz");
      addOpcode(0xE3,"inw",CpuAddressingMode.ABS,5,"nz");
      addOpcode(0xEB,"row",CpuAddressingMode.ABS,6,"cnz");
      addOpcode(0xF2,"sbc",CpuAddressingMode.IZZ,5,"Acvnz");
      addOpcode(0xF3,"lbeq",CpuAddressingMode.REL,3,"P");
      addOpcode(0xF4,"phw",CpuAddressingMode.IMM,5,"S");
      addOpcode(0xFB,"plz",CpuAddressingMode.NON,3,"ZnzS");
      addOpcode(0xFC,"phw",CpuAddressingMode.ABS,7,"S");
      addOpcode(0xEA,"eom",CpuAddressingMode.NON,1,"");

      // TODO: Instruction Cycle changes on 65CE02

   }


}
