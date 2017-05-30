package dk.camelot64.kickc.asm.parser;

/** Information about what parts of the CPU an ASM instruction clobbers  */
public class AsmClobber {

   boolean clobberA;
   boolean clobberX;
   boolean clobberY;
   boolean clobberC;
   boolean clobberN;
   boolean clobberZ;
   boolean clobberV;

   public AsmClobber() {
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

   public void setClobberA(boolean clobberA) {
      this.clobberA = clobberA;
   }

   public void setClobberX(boolean clobberX) {
      this.clobberX = clobberX;
   }

   public void setClobberY(boolean clobberY) {
      this.clobberY = clobberY;
   }

   public void setClobberC(boolean clobberC) {
      this.clobberC = clobberC;
   }

   public void setClobberN(boolean clobberN) {
      this.clobberN = clobberN;
   }

   public void setClobberZ(boolean clobberZ) {
      this.clobberZ = clobberZ;
   }

   public void setClobberV(boolean clobberV) {
      this.clobberV = clobberV;
   }
}
