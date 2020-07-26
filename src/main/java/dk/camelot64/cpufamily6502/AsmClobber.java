package dk.camelot64.cpufamily6502;

import java.io.Serializable;

/** Information about what registers/flags of the CPU an ASM instruction clobbers */
public class AsmClobber implements Serializable {

   public static final AsmClobber CLOBBER_ALL = new AsmClobber(true, true, true, true, true, true, true, true, true, true, true);

   final boolean registerA;
   final boolean registerX;
   final boolean registerY;
   final boolean flagC;
   final boolean flagN;
   final boolean flagZ;
   final boolean flagV;
   final boolean flagI;
   final boolean flagD;
   /** true if the program counter is modified (not just incremented to the next instruction). */
   final boolean registerPC;
   /** true if the stack pointer is modified.*/
   final boolean registerSP;

   public AsmClobber(boolean registerA, boolean registerX, boolean registerY, boolean flagC, boolean flagN, boolean flagZ, boolean flagV, boolean flagI, boolean flagD, boolean registerPC, boolean registerSP) {
      this.registerA = registerA;
      this.registerX = registerX;
      this.registerY = registerY;
      this.flagC = flagC;
      this.flagN = flagN;
      this.flagZ = flagZ;
      this.flagV = flagV;
      this.flagI = flagI;
      this.flagD = flagD;
      this.registerPC = registerPC;
      this.registerSP = registerSP;
   }

   public AsmClobber() {
      this(false, false, false, false, false, false, false, false, false, false, false);
   }

   /**
    * Create clobber from a string containing the names of the clobbered registers/flags.
    * Registers are upper-case and flags are lower-case. (This is because the 65C02 has both a "Z" register and a "Z" flag. )
    * EG. "AXcz" means that the A and X registers a and the carry and zero flags are clobbered.
    *
    * @param clobberString The clobber string.
    */
   public AsmClobber(String clobberString) {
      this(
            clobberString.contains("A"),
            clobberString.contains("X"),
            clobberString.contains("Y"),
            clobberString.contains("c"),
            clobberString.contains("n"),
            clobberString.contains("z"),
            clobberString.contains("v"),
            clobberString.contains("i"),
            clobberString.contains("d"),
            clobberString.contains("P"),
            clobberString.contains("S")
      );
   }

   /**
    * Create a clobber that adds two clobbers together. The result clobbers anything clobbered by any of the two.
    *
    * @param clobber1 One clobber
    * @param clobber2 Another clobber
    */
   public AsmClobber(AsmClobber clobber1, AsmClobber clobber2) {
      this(
            clobber1.registerA | clobber2.registerA,
            clobber1.registerX | clobber2.registerX,
            clobber1.registerY | clobber2.registerY,
            clobber1.flagC | clobber2.flagC,
            clobber1.flagN | clobber2.flagN,
            clobber1.flagZ | clobber2.flagZ,
            clobber1.flagV | clobber2.flagV,
            clobber1.flagI | clobber2.flagI,
            clobber1.flagD | clobber2.flagD,
            clobber1.registerPC | clobber2.registerPC,
            clobber1.registerSP | clobber2.registerSP
      );
   }


   public boolean isRegisterA() {
      return registerA;
   }

   public boolean isRegisterX() {
      return registerX;
   }

   public boolean isRegisterY() {
      return registerY;
   }

   public boolean isFlagC() {
      return flagC;
   }

   public boolean isFlagN() {
      return flagN;
   }

   public boolean isFlagZ() {
      return flagZ;
   }

   public boolean isFlagV() {
      return flagV;
   }

   public boolean isFlagI() {
      return flagI;
   }

   public boolean isFlagD() {
      return flagD;
   }

   public boolean isRegisterPC() {
      return registerPC;
   }

   public boolean isRegisterSP() {
      return registerSP;
   }

   @Override
   public String toString() {
      return
            (registerA ? "A" : "") +
                  (registerX ? "X" : "") +
                  (registerY ? "Y" : "") +
                  (flagC ? "c" : "") +
                  (flagN ? "n" : "") +
                  (flagZ ? "z" : "") +
                  (flagV ? "v" : "") +
                  (flagI ? "i" : "") +
                  (flagD ? "d" : "") +
                  (registerPC ? "P" : "") +
                  (registerSP ? "S" : "") ;

   }

}
