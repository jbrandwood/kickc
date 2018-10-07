package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.AsmClobber;
import dk.camelot64.kickc.asm.AsmLine;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.asm.AsmSegment;
import dk.camelot64.kickc.model.CallGraph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ProcedureRef;

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
            AsmClobber procClobber = getProcedureClobber(procedure);
            getLog().append("Interrupt procedure "+procedure.getFullName()+" clobbers "+procClobber.toString());

            // Find the entry/exit blocks for the interrupt
            AsmSegment interruptEntry = null;
            AsmSegment interruptExit = null;
            for(AsmSegment asmSegment : getProgram().getAsm().getSegments()) {
               if(procedure.getFullName().equals(asmSegment.getScopeLabel())) {
                  if(asmSegment.getSource().contains(Procedure.InterruptType.HARDWARE_CLOBBER.name())) {
                     if(asmSegment.getSource().contains("entry interrupt")) {
                        interruptEntry = asmSegment;
                     } else if(asmSegment.getSource().contains("exit interrupt")) {
                        interruptExit = asmSegment;
                     } else {
                        throw new RuntimeException("Unknown interrupt ASM segment "+asmSegment.getSource());
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

   private AsmClobber getProcedureClobber(Procedure procedure) {
      AsmProgram asm = getProgram().getAsm();
      AsmClobber procClobber =new AsmClobber();
      for(AsmSegment asmSegment : asm.getSegments()) {
         if(procedure.getFullName().equals(asmSegment.getScopeLabel())) {
            if(asmSegment.getSource().contains(Procedure.InterruptType.HARDWARE_CLOBBER.name())) {
               // Do not count clobber in the entry/exit
               continue;
            }
            AsmClobber asmSegmentClobber = asmSegment.getClobber();
            procClobber.add(asmSegmentClobber);
         }
      }

      CallGraph callGraph = getProgram().getCallGraph();
      CallGraph.CallBlock callBlock = callGraph.getCallBlock(procedure.getRef());
      List<CallGraph.CallBlock.Call> calls = callBlock.getCalls();
      for(CallGraph.CallBlock.Call call : calls) {
         ProcedureRef calledProcRef = call.getProcedure();
         Procedure calledProc = getProgram().getScope().getProcedure(calledProcRef);
         AsmClobber calledClobber = getProcedureClobber(calledProc);
         procClobber.add(calledClobber);
      }

      return procClobber;
   }

   private List<String> getNonClobberedRegisterNames(AsmClobber procClobber) {
      List<String> notClobberedRegisters = new ArrayList<>();
      if(!procClobber.isClobberA()) {
         notClobberedRegisters.add("a");
      }
      if(!procClobber.isClobberX()) {
         notClobberedRegisters.add("x");
      }
      if(!procClobber.isClobberY()) {
         notClobberedRegisters.add("y");
      }
      return notClobberedRegisters;
   }

   private void pruneNonClobberedInterruptLines(AsmSegment interruptEntryExit, List<String> notClobberedRegisters) {
      ListIterator<AsmLine> entryLines = interruptEntryExit.getLines().listIterator();
      while(entryLines.hasNext()) {
         AsmLine line = entryLines.next();
         for(String notClobberedReg : notClobberedRegisters) {
            if(line.getAsm().contains(notClobberedReg)) {
               // Found an A/X/Y in the asm where A/X/Y is not clobbered - remove the line
               getLog().append("Removing interrupt register storage "+line.toString()+" in SEG"+interruptEntryExit.getIndex()+" "+interruptEntryExit.getSource());
               entryLines.remove();
            }
         }
      }
   }

}
