package dk.camelot64.cpufamily6502;

import java.io.Serializable;

/** Information about what registers/flags of the CPU an ASM instruction clobbers */
public class CpuClobber implements Serializable {

   public static final CpuClobber CLOBBER_ALL = new CpuClobber(true, true, true, true, true, true, true, true, true, true, true, true, true, true);

   public static final CpuClobber CLOBBER_NONE = new CpuClobber(false, false, false, false, false, false, false, false, false, false, false, false, false, false);

   /** True if the A register is modified. */
   final boolean registerA;
   /** True if the X register is modified. */
   final boolean registerX;
   /** True if the Y register is modified. */
   final boolean registerY;
   /** True if the Z register is modified. (65ce02+). */
   final boolean registerZ;
   /** True if the carry flag is modified. */
   final boolean flagC;
   /** True if the negative flag is modified. */
   final boolean flagN;
   /** true if the zero (equals) flag is modified. */
   final boolean flagZ;
   /** True if the overflow flag is modified. */
   final boolean flagV;
   /** True if the interrupt flag is modified. */
   final boolean flagI;
   /** True if the decimal flag is modified. */
   final boolean flagD;
   /** True if the disable extended stack flag is modified. */
   final boolean flagE;
   /** true if the program counter is modified (not just incremented to the next instruction). */
   final boolean registerPC;
   /** true if the stack pointer is modified. */
   final boolean registerSP;
   /** true if the base page register is modified. (65ce02+)*/
   final boolean registerBP;

   public CpuClobber(boolean registerA, boolean registerX, boolean registerY, boolean registerZ, boolean flagC, boolean flagN, boolean flagZ, boolean flagV, boolean flagI, boolean flagD, boolean flagE, boolean registerPC, boolean registerSP, boolean registerBP) {
      this.registerA = registerA;
      this.registerX = registerX;
      this.registerY = registerY;
      this.registerZ = registerZ;
      this.flagC = flagC;
      this.flagN = flagN;
      this.flagZ = flagZ;
      this.flagV = flagV;
      this.flagI = flagI;
      this.flagD = flagD;
      this.flagE = flagE;
      this.registerPC = registerPC;
      this.registerSP = registerSP;
      this.registerBP = registerBP;
   }

   /**
    * Create clobber from a string containing the names of the clobbered registers/flags.
    * Registers are upper-case and flags are lower-case. (This is because the 65C02 has both a "Z" register and a "Z" flag. )
    * EG. "AXcz" means that the A and X registers a and the carry and zero flags are clobbered.
    * Here is the meaning of each name usable in the string
    * <ul>
    *    <li> <b>A</b> A register </li>
    *    <li> <b>X</b> X register </li>
    *    <li> <b>Y</b> Y register </li>
    *    <li> <b>Z</b> Z register </li>
    *    <li> <b>c</b> carry flag </li>
    *    <li> <b>v</b> overflow flag </li>
    *    <li> <b>z</b> zero flag </li>
    *    <li> <b>n</b> negative flag </li>
    *    <li> <b>i</b> interrupt flag </li>
    *    <li> <b>d</b> decimal flag </li>
    *    <li> <b>e</b> extended stack disable flag </li>
    *    <li> <b>S</b> stack pointer </li>
    *    <li> <b>B</b> base page register is modified. </li>
    *    <li> <b>P</b> program counter is modified (not just incremented to the next instruction). </li>
    * </ul>
    *
    * @param clobberString The clobber string.
    */
   public CpuClobber(String clobberString) {
      this(
            clobberString.contains("A"),
            clobberString.contains("X"),
            clobberString.contains("Y"),
            clobberString.contains("Z"),
            clobberString.contains("c"),
            clobberString.contains("n"),
            clobberString.contains("z"),
            clobberString.contains("v"),
            clobberString.contains("i"),
            clobberString.contains("d"),
            clobberString.contains("e"),
            clobberString.contains("P"),
            clobberString.contains("S"),
            clobberString.contains("B")
      );
   }

   /**
    * Create a clobber that adds two clobbers together. The result clobbers anything clobbered by any of the two.
    *
    * @param clobber1 One clobber
    * @param clobber2 Another clobber
    */
   public CpuClobber(CpuClobber clobber1, CpuClobber clobber2) {
      this(
            clobber1.registerA | clobber2.registerA,
            clobber1.registerX | clobber2.registerX,
            clobber1.registerY | clobber2.registerY,
            clobber1.registerZ | clobber2.registerZ,
            clobber1.flagC | clobber2.flagC,
            clobber1.flagN | clobber2.flagN,
            clobber1.flagZ | clobber2.flagZ,
            clobber1.flagV | clobber2.flagV,
            clobber1.flagI | clobber2.flagI,
            clobber1.flagD | clobber2.flagD,
            clobber1.flagE | clobber2.flagE,
            clobber1.registerPC | clobber2.registerPC,
            clobber1.registerSP | clobber2.registerSP,
            clobber1.registerBP | clobber2.registerBP
      );
   }

   private String toClobberString() {
      return
            (registerA ? "A" : "") +
                  (registerX ? "X" : "") +
                  (registerY ? "Y" : "") +
                  (registerZ ? "Z" : "") +
                  (flagC ? "c" : "") +
                  (flagN ? "n" : "") +
                  (flagZ ? "z" : "") +
                  (flagV ? "v" : "") +
                  (flagI ? "i" : "") +
                  (flagD ? "d" : "") +
                  (flagE ? "e" : "") +
                  (registerPC ? "P" : "") +
                  (registerSP ? "S" : "") +
                  (registerBP ? "B" : "") ;
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

   public boolean isRegisterZ() {
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

   public boolean isFlagE() {
      return flagE;
   }

   public boolean isRegisterPC() {
      return registerPC;
   }

   public boolean isRegisterSP() {
      return registerSP;
   }

   public boolean isRegisterBP() {
      return registerBP;
   }

   @Override
   public String toString() {
      return toClobberString();
   }

}
