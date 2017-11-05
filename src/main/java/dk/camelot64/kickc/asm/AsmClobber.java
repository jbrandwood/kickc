package dk.camelot64.kickc.asm;

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

   /**
    * Adds clobber.
    * Effective updates so this clobber also clobbers anything added
    * @param clobber The clobber to add
    */
   public void add(AsmClobber clobber) {
      clobberA |= clobber.clobberA;
      clobberX |= clobber.clobberX;
      clobberY |= clobber.clobberY;
      clobberC |= clobber.clobberC;
      clobberN |= clobber.clobberN;
      clobberZ |= clobber.clobberZ;
      clobberV |= clobber.clobberV;
   }

   @Override
   public String toString() {
      return
            (clobberA?"A":"") +
            (clobberX?"X":"") +
            (clobberY?"Y":"") +
            (clobberC?"C":"") +
            (clobberN?"N":"") +
            (clobberZ?"Z":"") +
            (clobberV?"V":"") ;

   }
}
