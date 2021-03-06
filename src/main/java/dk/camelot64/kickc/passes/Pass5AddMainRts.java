package dk.camelot64.kickc.passes;

import dk.camelot64.cpufamily6502.CpuAddressingMode;
import dk.camelot64.kickc.asm.AsmChunk;
import dk.camelot64.kickc.asm.AsmInstruction;
import dk.camelot64.kickc.asm.AsmLine;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.SymbolRef;

import java.util.ListIterator;

/**
 * If the main method is called by JSR this adds an additional RTS
 */
public class Pass5AddMainRts extends Pass5AsmOptimization {

   public Pass5AddMainRts(Program program) {
      super(program);
   }

   public boolean optimize() {
      for(AsmChunk chunk : getAsmProgram().getChunks()) {
         String scopeLabel = chunk.getScopeLabel();
         if(scopeLabel.equals(ScopeRef.ROOT.getFullName())) {
            ListIterator<AsmLine> lineIterator = chunk.getLines().listIterator();
            while(lineIterator.hasNext()) {
               AsmLine line = lineIterator.next();
               if(line instanceof AsmInstruction) {
                  AsmInstruction instruction = (AsmInstruction) line;
                  if(instruction.getCpuOpcode().getMnemonic().equals("jsr")) {
                     if(instruction.getOperand1().equals(SymbolRef.MAIN_PROC_NAME)) {
                        // Add RTS if it is missing
                        if(!lineIterator.hasNext()) {
                           addRts(lineIterator);
                           return true;
                        }
                        AsmLine nextLine = lineIterator.next();
                        if(!(nextLine instanceof AsmInstruction)) {
                           addRts(lineIterator);
                           return true;
                        }
                        AsmInstruction nextInstruction = (AsmInstruction) nextLine;
                        if(!nextInstruction.getCpuOpcode().getMnemonic().equals("rts")) {
                           addRts(lineIterator);
                           return true;
                        }
                     }
                  }
               }
            }
         }
      }
      return false;
   }

   private void addRts(ListIterator<AsmLine> lineIterator) {
      lineIterator.add(new AsmInstruction(getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("rts", CpuAddressingMode.NON, false), null, null, null));
      getLog().append("Adding RTS to root block ");
   }

}
