package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.*;
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
      for(AsmSegment segment : getAsmProgram().getSegments()) {
         String scopeLabel = segment.getScopeLabel();
         if(scopeLabel.equals(ScopeRef.ROOT.getFullName())) {
            ListIterator<AsmLine> lineIterator = segment.getLines().listIterator();
            while(lineIterator.hasNext()) {
               AsmLine line = lineIterator.next();
               if(line instanceof AsmInstruction) {
                  AsmInstruction instruction = (AsmInstruction) line;
                  if(instruction.getType().getMnemnonic().equals("jsr")) {
                     if(instruction.getParameter().equals(SymbolRef.MAIN_PROC_NAME)) {
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
                        if(!nextInstruction.getType().getMnemnonic().equals("rts")) {
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
      lineIterator.add(new AsmInstruction(AsmInstructionSet.getInstructionType("rts", AsmAddressingMode.NON, false), null));
      getLog().append("Adding RTS to root block ");
   }

}
