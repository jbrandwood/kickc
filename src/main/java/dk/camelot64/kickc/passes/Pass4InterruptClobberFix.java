package dk.camelot64.kickc.passes;

import dk.camelot64.cpufamily6502.CpuClobber;
import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.fragment.AsmFragmentInstance;
import dk.camelot64.kickc.fragment.AsmFragmentInstanceSpecBuilder;
import dk.camelot64.kickc.fragment.AsmFragmentTemplateSynthesizer;
import dk.camelot64.kickc.model.CallGraph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.Collection;
import java.util.List;

/*** Ensure that all interrupt procedures with CLOBBER type only saves the necessary registers. */
public class Pass4InterruptClobberFix extends Pass2Base {

   public Pass4InterruptClobberFix(Program program) {
      super(program);
   }

   /**
    * Check that no statement clobbers a CPU register used by an alive variable
    */
   public void fix() {
      Collection<Procedure> procedures = getProgram().getScope().getAllProcedures(true);
      for(Procedure procedure : procedures) {
         if(procedure.getInterruptType() != null && procedure.getInterruptType().toLowerCase().contains("clobber")) {
            // Find the interrupt routine clobber
            CpuClobber procClobber = getProcedureClobber(procedure);
            getLog().append("Interrupt procedure " + procedure.getFullName() + " clobbers " + procClobber.toString());
            // Find the entry/exit blocks for the interrupt
            AsmChunk interruptEntry = null;
            AsmChunk interruptExit = null;
            for(AsmChunk asmChunk : getProgram().getAsm().getChunks()) {
               if(procedure.getFullName().equals(asmChunk.getScopeLabel())) {
                  if(asmChunk.getSource().contains("clobber")) {
                     if(asmChunk.getSource().endsWith("_entry)")) {
                        interruptEntry = asmChunk;
                     } else if(asmChunk.getSource().endsWith("_exit)")) {
                        interruptExit = asmChunk;
                     } else {
                        throw new RuntimeException("Unknown interrupt ASM chunk " + asmChunk.getSource());
                     }
                     continue;
                  }
               }
            }
            if(interruptEntry == null || interruptExit == null) {
               throw new RuntimeException("Cannot find interrupt entry/exit for interrupt " + procedure.getFullName());
            }
            String clobberedRegisters = getClobberedRegisterNames(procClobber);
            // Update the interrupt entry ASM with the proper clobber fragment
            updateClobberFragment(interruptEntry, clobberedRegisters);
            // Update the interrupt exit ASM with the proper clobber fragment
            updateClobberFragment(interruptExit, clobberedRegisters);
         }
      }

   }

   private CpuClobber getProcedureClobber(Procedure procedure) {
      AsmProgram asm = getProgram().getAsm();
      CpuClobber procClobber = CpuClobber.CLOBBER_NONE;
      for(AsmChunk asmChunk : asm.getChunks()) {
         if(procedure.getFullName().equals(asmChunk.getScopeLabel())) {
            if(asmChunk.getSource().contains("clobber")) {
               // Do not count clobber in the entry/exit
               continue;
            }
            CpuClobber chunkClobber = asmChunk.getClobber();
            procClobber = new CpuClobber(procClobber, chunkClobber);
         }
      }

      CallGraph callGraph = getProgram().getCallGraph();
      CallGraph.CallBlock callBlock = callGraph.getCallBlock(procedure.getRef());
      List<CallGraph.CallBlock.Call> calls = callBlock.getCalls();
      for(CallGraph.CallBlock.Call call : calls) {
         ScopeRef calledProcLabel = call.getProcedure();
         ProcedureRef calledProcRef = new ProcedureRef(calledProcLabel.getFullName());
         Procedure calledProc = getProgram().getScope().getProcedure(calledProcRef);
         CpuClobber calledClobber = getProcedureClobber(calledProc);
         procClobber = new CpuClobber(procClobber, calledClobber);
      }

      return procClobber;
   }

   /**
    * Get the clobbered registers
    *
    * @param procClobber CPU clobber from running the interrupt routine
    * @return The clobbered registers as a string. "axyz" is all registers, "" is none.
    */
   private String getClobberedRegisterNames(CpuClobber procClobber) {
      String clobberedRegisters = "";
      if(procClobber.isRegisterA()) {
         clobberedRegisters += "a";
      }
      if(procClobber.isRegisterX()) {
         clobberedRegisters += "x";
      }
      if(procClobber.isRegisterY()) {
         clobberedRegisters += "y";
      }
      if(procClobber.isRegisterZ()) {
         clobberedRegisters += "z";
      }
      return clobberedRegisters;
   }

   /**
    * Replace the current code with the proper version handling only the clobbered registers
    *
    * @param interruptAsmChunk The AsmFragment representing an interrupt entry/exit
    * @param clobberedRegisters The clobbered registers
    */
   private void updateClobberFragment(AsmChunk interruptAsmChunk, String clobberedRegisters) {
      // find the clobber fragment sub-name
      String clobberName = "clob" + clobberedRegisters;
      if(clobberedRegisters.equals(""))
         clobberName = "none";
      String allRegisters = "axy" + (getProgram().getTargetCpu().getCpu65xx().hasRegisterZ() ? "z" : "");
      if(clobberedRegisters.equals(allRegisters))
         clobberName = "all";

      // Find the interrupt type name (including "isr_" and "_entry"/"_exit"
      String interruptType = interruptAsmChunk.getSource();
      interruptType = interruptType.substring(("interrupt(".length()), interruptType.length() - 1);

      // Find the correct clobber name based on the clobbered registers
      final String interruptSignatureFinal = interruptType.replace("clobber", clobberName);
      AsmFragmentInstanceSpecBuilder interruptFragment = AsmFragmentInstanceSpecBuilder.interrupt(interruptSignatureFinal, getProgram());
      String interruptFragmentName = interruptFragment.getAsmFragmentInstanceSpec().getSignature();

      // Generate the fragment
      final AsmFragmentTemplateSynthesizer cpuSynthesizer = getProgram().getAsmFragmentMasterSynthesizer().getSynthesizer(getProgram().getTargetCpu());
      final AsmFragmentInstance fragmentInstance = cpuSynthesizer.getFragmentInstance(interruptFragment.getAsmFragmentInstanceSpec(), getProgram().getLog());
      interruptAsmChunk.setFragment(fragmentInstance.getFragmentName());
      final AsmProgram asmLines = new AsmProgram(getProgram().getTargetCpu());
      asmLines.startChunk(getProgram().getScope().getRef(), interruptAsmChunk.getStatementIdx(), interruptAsmChunk.getSource());
      fragmentInstance.generate(asmLines);

      // Replace the chunk lines with the generated lines
      final List<AsmLine> interruptAsmChunkLines = interruptAsmChunk.getLines();
      int line_idx = interruptAsmChunkLines.get(0).getIndex();
      boolean hasScopeEnd = interruptAsmChunkLines.get(interruptAsmChunkLines.size() - 1) instanceof AsmScopeEnd;
      interruptAsmChunkLines.clear();
      interruptAsmChunk.setSource("interrupt(" + interruptFragmentName+ ")");
      for(AsmChunk chunk : asmLines.getChunks()) {
         for(AsmLine line : chunk.getLines()) {
            interruptAsmChunk.addLine(line);
            line.setIndex(line_idx++);
            if(line instanceof AsmLabel) ((AsmLabel) line).setDontOptimize(true);
         }
      }
      if(hasScopeEnd)
         interruptAsmChunkLines.add(new AsmScopeEnd());
   }

}
