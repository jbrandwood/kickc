package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.AsmClobber;
import dk.camelot64.kickc.asm.AsmLine;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.asm.AsmSegment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.Registers;
import dk.camelot64.kickc.model.symbols.Procedure;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.ListIterator;

import static dk.camelot64.kickc.passes.Pass4AssertNoCpuClobber.getClobberRegisters;

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

            AsmSegment interruptEntry = null;
            AsmSegment interruptExit = null;

            // Iterate all procedure segments to find the interrupt routine clobber
            AsmClobber procClobber = new AsmClobber();
            AsmProgram asm = getProgram().getAsm();
            for(AsmSegment asmSegment : asm.getSegments()) {
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
                  AsmClobber asmSegmentClobber = asmSegment.getClobber();
                  procClobber.add(asmSegmentClobber);
               }
            }
            getLog().append("Interrupt procedure "+procedure.getFullName()+" clobbers "+procClobber.toString());
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
