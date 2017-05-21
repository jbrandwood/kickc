package dk.camelot64.kickc.asm;

/** A label / jump target  */
public class AsmLabel implements AsmLine {

   private String label;

   public AsmLabel(String label) {
      this.label = label;
   }

   @Override
   public int getLineBytes() {
      return 0;
   }

   @Override
   public double getLineCycles() {
      return 0;
   }

   @Override
   public int getInvocationCountEstimate() {
      return 0;
   }

   @Override
   public double getEstimatedTotalCycles() {
      return 0;
   }

   @Override
   public String getAsm() {
      return label+":";
   }
}
