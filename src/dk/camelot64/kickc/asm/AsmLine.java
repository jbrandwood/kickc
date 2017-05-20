package dk.camelot64.kickc.asm;

/** A line of 6502 assembler code */
public interface AsmLine {

   public int getLineBytes();

   public double getLineCycles();

   public int getInvocationCountEstimate();

   public double getEstimatedTotalCycles();

   public String getAsm();

}
