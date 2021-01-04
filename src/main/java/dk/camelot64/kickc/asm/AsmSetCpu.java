package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.model.TargetCpu;

/** Set the current CPU */
public class AsmSetCpu extends AsmLine {

   private final TargetCpu cpu;

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

   public TargetCpu getCpu() {
      return cpu;
   }
}
