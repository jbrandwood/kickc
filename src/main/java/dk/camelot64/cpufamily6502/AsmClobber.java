package dk.camelot64.cpufamily6502;

import java.io.Serializable;

/** Information about what registers/flags of the CPU an ASM instruction clobbers */
public class AsmClobber implements Serializable {

   public static final AsmClobber CLOBBER_ALL = new AsmClobber(true, true, true, true, true, true, true);

   final boolean clobberA;
   final boolean clobberX;
   final boolean clobberY;
   final boolean clobberC;
   final boolean clobberN;
   final boolean clobberZ;
   final boolean clobberV;

   public AsmClobber(boolean clobberA, boolean clobberX, boolean clobberY, boolean clobberC, boolean clobberN, boolean clobberZ, boolean clobberV) {
      this.clobberA = clobberA;
      this.clobberX = clobberX;
      this.clobberY = clobberY;
      this.clobberC = clobberC;
      this.clobberN = clobberN;
      this.clobberZ = clobberZ;
      this.clobberV = clobberV;
   }

   public AsmClobber() {
      this(false, false, false, false, false, false, false);
   }

   /**
    * Create clobber from a string containing the names of the clobbered registers/flags. EG. "AX" means that the A and X registers are clobbered.
    *
    * @param clobberString The clobber string.
    */
   public AsmClobber(String clobberString) {
      this(
            clobberString.contains("A"),
            clobberString.contains("X"),
            clobberString.contains("Y"),
            clobberString.contains("C"),
            clobberString.contains("N"),
            clobberString.contains("Z"),
            clobberString.contains("V")
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
            clobber1.clobberA | clobber2.clobberA,
            clobber1.clobberX | clobber2.clobberX,
            clobber1.clobberY | clobber2.clobberY,
            clobber1.clobberC | clobber2.clobberC,
            clobber1.clobberN | clobber2.clobberN,
            clobber1.clobberZ | clobber2.clobberZ,
            clobber1.clobberV | clobber2.clobberV
      );
   }


   public boolean isClobberA() {
      return clobberA;
   }

   public boolean isClobberX() {
      return clobberX;
   }

   public boolean isClobberY() {
      return clobberY;
   }

   public boolean isClobberC() {
      return clobberC;
   }

   public boolean isClobberN() {
      return clobberN;
   }

   public boolean isClobberZ() {
      return clobberZ;
   }

   public boolean isClobberV() {
      return clobberV;
   }

   public AsmClobber addClobberA(boolean clobberA) {
      return new AsmClobber(clobberA, this.clobberX, this.clobberY, this.clobberC, this.clobberN, this.clobberZ, this.clobberV);
   }

   public AsmClobber addClobberX(boolean clobberX) {
      return new AsmClobber(this.clobberA, clobberX, this.clobberY, this.clobberC, this.clobberN, this.clobberZ, this.clobberV);
   }

   public AsmClobber addClobberY(boolean clobberY) {
      return new AsmClobber(this.clobberA, this.clobberX, clobberY, this.clobberC, this.clobberN, this.clobberZ, this.clobberV);
   }

   public AsmClobber addClobberC(boolean clobberC) {
      return new AsmClobber(this.clobberA, this.clobberX, this.clobberY, clobberC, this.clobberN, this.clobberZ, this.clobberV);
   }

   public AsmClobber addClobberN(boolean clobberN) {
      return new AsmClobber(this.clobberA, this.clobberX, this.clobberY, this.clobberC, clobberN, this.clobberZ, this.clobberV);
   }

   public AsmClobber addClobberZ(boolean clobberZ) {
      return new AsmClobber(this.clobberA, this.clobberX, this.clobberY, this.clobberC, this.clobberN, clobberZ, this.clobberV);
   }

   public AsmClobber addClobberV(boolean clobberV) {
      return new AsmClobber(this.clobberA, this.clobberX, this.clobberY, this.clobberC, this.clobberN, this.clobberZ, clobberV);
   }


   @Override
   public String toString() {
      return
            (clobberA ? "A" : "") +
                  (clobberX ? "X" : "") +
                  (clobberY ? "Y" : "") +
                  (clobberC ? "C" : "") +
                  (clobberN ? "N" : "") +
                  (clobberZ ? "Z" : "") +
                  (clobberV ? "V" : "");

   }

}
