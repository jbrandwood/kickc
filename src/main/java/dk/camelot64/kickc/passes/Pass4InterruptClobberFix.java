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
import java.util.ListIterator;

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
            String clobberedRegisterNames = getClobberedRegisterNames(procClobber);
            // Update the interrupt entry ASM with the proper clobber fragment
            pruneFragmentClobber(interruptEntry, clobberedRegisterNames);
            // Update the interrupt exit ASM with the proper clobber fragment
            pruneFragmentClobber(interruptExit, clobberedRegisterNames);
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
    * Prune the interrupt entry/exit fragment removing code handling non-clobbered registers
    *
    * @param interruptAsmChunk The AsmFragment representing an interrupt entry/exit
    * @param nonClobberedRegisters The non-clobbered registers
    */
   private void pruneFragmentClobber(AsmChunk interruptAsmChunk, String clobberedRegisters) {
      final ListIterator<AsmLine> asmLineListIterator = interruptAsmChunk.getLines().listIterator();
      while(asmLineListIterator.hasNext()) {
         AsmLine asmLine = asmLineListIterator.next();
         if(asmLine.getTags().has("clob_a") && !clobberedRegisters.contains("a"))
            asmLineListIterator.remove();
         if(asmLine.getTags().has("clob_x") && !clobberedRegisters.contains("x"))
            asmLineListIterator.remove();
         if(asmLine.getTags().has("clob_y") && !clobberedRegisters.contains("y"))
            asmLineListIterator.remove();
         if(asmLine.getTags().has("clob_z") && !clobberedRegisters.contains("z"))
            asmLineListIterator.remove();
         if(asmLine.getTags().has("clob_none") && clobberedRegisters.equals(""))
            asmLineListIterator.remove();
      }
   }

}
