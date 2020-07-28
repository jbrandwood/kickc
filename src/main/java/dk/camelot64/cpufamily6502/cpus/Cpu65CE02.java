package dk.camelot64.cpufamily6502.cpus;

import dk.camelot64.cpufamily6502.Cpu65xx;

/**
 * The 65CE02 instruction set.
 * http://archive.6502.org/datasheets/mos_65ce02_mpu.pdf
 */
public class Cpu65CE02 extends Cpu65xx {

   /** The 65CE02 CPU name. */
   public final static String NAME = "65ce02";

   /** The 65CE02 with illegal CPU. */
   public final static Cpu65CE02 INSTANCE = new Cpu65CE02();

   public Cpu65CE02() {
      super(NAME, Cpu65C02.INSTANCE);
      // TODO: Add 65CE02 instructions
   }

}
