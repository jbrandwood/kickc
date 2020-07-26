package dk.camelot64.cpufamily6502;

import java.io.Serializable;

/** Information about what registers/flags of the CPU an ASM instruction clobbers */
public class AsmClobber implements Serializable {

   public static final AsmClobber CLOBBER_ALL = new AsmClobber(true, true, true, true, true, true, true);

   final boolean registerA;
   final boolean registerX;
   final boolean registerY;
   final boolean flagC;
   final boolean flagN;
   final boolean flagZ;
   final boolean flagV;

   public AsmClobber(boolean registerA, boolean registerX, boolean registerY, boolean flagC, boolean flagN, boolean flagZ, boolean flagV) {
      this.registerA = registerA;
      this.registerX = registerX;
      this.registerY = registerY;
      this.flagC = flagC;
      this.flagN = flagN;
      this.flagZ = flagZ;
      this.flagV = flagV;
   }

   public AsmClobber() {
      this(false, false, false, false, false, false, false);
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
            clobberString.contains("v")
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
            clobber1.flagV | clobber2.flagV
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

   public AsmClobber addRegisterA() {
      return new AsmClobber(true, this.registerX, this.registerY, this.flagC, this.flagN, this.flagZ, this.flagV);
   }

   public AsmClobber addRegisterX() {
      return new AsmClobber(this.registerA, true, this.registerY, this.flagC, this.flagN, this.flagZ, this.flagV);
   }

   public AsmClobber addRegisterY() {
      return new AsmClobber(this.registerA, this.registerX, true, this.flagC, this.flagN, this.flagZ, this.flagV);
   }

   public AsmClobber addFlagC() {
      return new AsmClobber(this.registerA, this.registerX, this.registerY, true, this.flagN, this.flagZ, this.flagV);
   }

   public AsmClobber addFlagN() {
      return new AsmClobber(this.registerA, this.registerX, this.registerY, this.flagC, true, this.flagZ, this.flagV);
   }

   public AsmClobber addFlagZ() {
      return new AsmClobber(this.registerA, this.registerX, this.registerY, this.flagC, this.flagN, true, this.flagV);
   }

   public AsmClobber addFlagV() {
      return new AsmClobber(this.registerA, this.registerX, this.registerY, this.flagC, this.flagN, this.flagZ, true);
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
                  (flagV ? "v" : "");

   }

}
