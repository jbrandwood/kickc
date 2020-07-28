package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.AsmChunk;
import dk.camelot64.cpufamily6502.CpuClobber;
import dk.camelot64.kickc.asm.AsmLine;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.model.CallGraph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.ListIterator;

/*** Ensure that all interrupt procedures with type {@link Procedure.InterruptType#HARDWARE_CLOBBER } only saves the necessary registers. */
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
         if(Procedure.InterruptType.HARDWARE_CLOBBER.equals(procedure.getInterruptType())) {

            // Find the interrupt routine clobber
            CpuClobber procClobber = getProcedureClobber(procedure);
            getLog().append("Interrupt procedure "+procedure.getFullName()+" clobbers "+procClobber.toString());

            // Find the entry/exit blocks for the interrupt
            AsmChunk interruptEntry = null;
            AsmChunk interruptExit = null;
            for(AsmChunk asmChunk : getProgram().getAsm().getChunks()) {
               if(procedure.getFullName().equals(asmChunk.getScopeLabel())) {
                  if(asmChunk.getSource().contains(Procedure.InterruptType.HARDWARE_CLOBBER.name())) {
                     if(asmChunk.getSource().contains("entry interrupt")) {
                        interruptEntry = asmChunk;
                     } else if(asmChunk.getSource().contains("exit interrupt")) {
                        interruptExit = asmChunk;
                     } else {
                        throw new RuntimeException("Unknown interrupt ASM chunk "+ asmChunk.getSource());
                     }
                     continue;
                  }
               }
            }
            if(interruptEntry==null || interruptExit==null) {
               throw new RuntimeException("Cannot find interrupt entry/exit for interrupt "+procedure.getFullName());
            }
            List<String> notClobberedRegisters = getNonClobberedRegisterNames(procClobber);
            if(notClobberedRegisters.isEmpty()) {
               // All registers clobbered - no need to fix anything
               continue;
            }
            // Remove all lines saving/restoring non-clobbered registers in entry
            pruneNonClobberedInterruptLines(interruptEntry, notClobberedRegisters);
            // Remove all lines saving/restoring non-clobbered registers in entry
            pruneNonClobberedInterruptLines(interruptExit, notClobberedRegisters);

         }
      }
   }

   private CpuClobber getProcedureClobber(Procedure procedure) {
      AsmProgram asm = getProgram().getAsm();
      CpuClobber procClobber = new CpuClobber();
      for(AsmChunk asmChunk : asm.getChunks()) {
         if(procedure.getFullName().equals(asmChunk.getScopeLabel())) {
            if(asmChunk.getSource().contains(Procedure.InterruptType.HARDWARE_CLOBBER.name())) {
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

   private List<String> getNonClobberedRegisterNames(CpuClobber procClobber) {
      List<String> notClobberedRegisters = new ArrayList<>();
      if(!procClobber.isRegisterA()) {
         notClobberedRegisters.add("a");
      }
      if(!procClobber.isRegisterX()) {
         notClobberedRegisters.add("x");
      }
      if(!procClobber.isRegisterY()) {
         notClobberedRegisters.add("y");
      }
      return notClobberedRegisters;
   }

   private void pruneNonClobberedInterruptLines(AsmChunk interruptEntryExit, List<String> notClobberedRegisters) {
      ListIterator<AsmLine> entryLines = interruptEntryExit.getLines().listIterator();
      while(entryLines.hasNext()) {
         AsmLine line = entryLines.next();
         for(String notClobberedReg : notClobberedRegisters) {
            final String lineAsm = line.getAsm();
            if(lineAsm.contains("ld"+notClobberedReg) || lineAsm.contains("st"+notClobberedReg) || lineAsm.contains("reg"+notClobberedReg)) {
               // Found an A/X/Y in the asm where A/X/Y is not clobbered - remove the line
               getLog().append("Removing interrupt register storage "+line.toString()+" in "+interruptEntryExit.getIndex()+" "+interruptEntryExit.getSource());
               entryLines.remove();
            }
         }
      }
   }

}
