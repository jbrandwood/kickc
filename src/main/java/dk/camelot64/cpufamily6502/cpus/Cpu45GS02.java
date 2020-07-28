package dk.camelot64.cpufamily6502.cpus;

import dk.camelot64.cpufamily6502.Cpu65xx;

/**
 * The 45GS02 instruction set.
 * https://github.com/MEGA65/mega65-user-guide/blob/master/MEGA65-Book_draft.pdf
 */
public class Cpu45GS02 extends Cpu65xx {

   /** The 45GS02 CPU name. */
   public final static String NAME = "45gs02";

   /** The 45GS02 with illegal CPU. */
   public final static Cpu45GS02 INSTANCE = new Cpu45GS02();

   public Cpu45GS02() {
      super(NAME, Cpu65CE02.INSTANCE);
      // TODO: Add 45GS02 instructions
   }

}
