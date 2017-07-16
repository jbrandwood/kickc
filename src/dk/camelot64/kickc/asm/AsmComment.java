package dk.camelot64.kickc.asm;

/** An assember comment */
public class AsmComment implements AsmLine {
   private String comment;

   public AsmComment(String comment) {
      this.comment = comment;
   }

   public String getComment() {
      return comment;
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
      return "// "+comment;
   }

}
