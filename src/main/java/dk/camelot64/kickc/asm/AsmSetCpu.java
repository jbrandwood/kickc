package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.model.TargetCpu;

/** Set the current CPU */
public class AsmSetCpu implements AsmLine {

   private final TargetCpu cpu;
   private int index;

   public AsmSetCpu(TargetCpu cpu) {
      this.cpu = cpu;
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
   public String getAsm() {
      final String cpuName = cpu.getAsmName();
      return ".cpu " + cpuName;
   }

   @Override
   public int getIndex() {
      return index;
   }

   @Override
   public void setIndex(int index) {
      this.index = index;
   }

   public TargetCpu getCpu() {
      return cpu;
   }
}
