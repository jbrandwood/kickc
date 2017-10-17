package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.model.Program;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/**
 * Optimize assembler code by removing all unused labels
 */
public class Pass5UnusedLabelElimination extends Pass5AsmOptimization {

   public Pass5UnusedLabelElimination(Program program) {
      super(program);
   }

   public boolean optimize() {
      Set<String> usedLabels = new LinkedHashSet<>();
      String currentScope = "";
      for (AsmSegment segment : getAsmProgram().getSegments()) {
         for (AsmLine line : segment.getLines()) {
            if(line instanceof AsmScopeBegin) {
               currentScope = ((AsmScopeBegin) line).getLabel();
            } else if(line instanceof AsmScopeEnd) {
               currentScope = "";
            } else if(line instanceof AsmInstruction) {
               AsmInstruction instruction = (AsmInstruction) line;
               if(instruction.getType().isJump()) {
                  String labelStr = currentScope+"::"+instruction.getParameter();
                  usedLabels.add(labelStr);
               }
            }
         }
      }
      List<AsmLine> removeLines = new ArrayList<>();
      for (AsmSegment segment : getAsmProgram().getSegments()) {
         for (AsmLine line : segment.getLines()) {
            if(line instanceof AsmScopeBegin) {
               currentScope = ((AsmScopeBegin) line).getLabel();
            } else if(line instanceof AsmScopeEnd) {
               currentScope = "";
            } else if(line instanceof AsmLabel) {
               AsmLabel label = (AsmLabel) line;
               String labelStr = currentScope+"::"+label.getLabel();
               if(!labelStr.contains("!") && !usedLabels.contains(labelStr)) {
                  removeLines.add(label);
               }
            }
         }
      }
      remove(removeLines);
      return removeLines.size() > 0;
   }
}
