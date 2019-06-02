package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.model.Program;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Optimize assembler code by removing jumps to labels immediately following the jump
 */
public class Pass5DoubleJumpElimination extends Pass5AsmOptimization {

   public Pass5DoubleJumpElimination(Program program) {
      super(program);
   }

   public boolean optimize() {
      boolean optimized = false;

      // Find all labels immediately followed by a a jump
      String currentScope = "";
      String currentLabel = null;
      Map<String, String> immediateJumps = new LinkedHashMap<>();
      for(AsmSegment segment : getAsmProgram().getSegments()) {
         for(AsmLine line : segment.getLines()) {
            if(line instanceof AsmScopeBegin) {
               currentScope = ((AsmScopeBegin) line).getLabel();
               currentLabel = null;
            } else if(line instanceof AsmScopeEnd) {
               currentScope = "";
               currentLabel = null;
            } else if(line instanceof AsmLabel) {
               currentLabel = ((AsmLabel) line).getLabel();
            } else if(line instanceof AsmComment || line instanceof AsmConstant || line instanceof AsmLabelDecl) {
               // ignore
            } else if(line instanceof AsmBasicUpstart || line instanceof AsmDataNumeric || line instanceof AsmDataFill || line instanceof AsmDataString || line instanceof AsmDataAlignment || line instanceof AsmSetPc || line instanceof AsmInlineKickAsm|| line instanceof AsmSetEncoding) {
               currentLabel = null;
            } else if(line instanceof AsmInstruction) {
               if(currentLabel != null) {
                  AsmInstruction asmInstruction = (AsmInstruction) line;
                  AsmInstructionType jmpType = AsmInstructionSet.getInstructionType("jmp", AsmAddressingMode.ABS, false);
                  AsmInstructionType rtsType = AsmInstructionSet.getInstructionType("rts", AsmAddressingMode.NON, false);
                  if(asmInstruction.getType().equals(jmpType)) {
                     immediateJumps.put(currentScope + "::" + currentLabel, asmInstruction.getParameter());
                  }
                  if(asmInstruction.getType().equals(rtsType)) {
                     immediateJumps.put(currentScope + "::" + currentLabel, "rts");
                  }
               }
               currentLabel = null;
            } else {
               throw new RuntimeException("ASM not handled " + line);
            }
         }
      }

      // Look through the code for double-jumps
      for(AsmSegment segment : getAsmProgram().getSegments()) {
         for(AsmLine line : segment.getLines()) {
            if(line instanceof AsmScopeBegin) {
               currentScope = ((AsmScopeBegin) line).getLabel();
            } else if(line instanceof AsmScopeEnd) {
               currentScope = "";
            } else if(line instanceof AsmInstruction) {
               AsmInstruction asmInstruction = (AsmInstruction) line;
               if(asmInstruction.getType().isJump()) {
                  String immediateJmpTarget = immediateJumps.get(currentScope + "::" + asmInstruction.getParameter());
                  if(immediateJmpTarget == "rts" && asmInstruction.getType().getMnemnonic() == "jmp") {
                     getLog().append("Replacing jump to rts with rts in " + asmInstruction.toString());
                     AsmInstructionType rtsType = AsmInstructionSet.getInstructionType("rts", AsmAddressingMode.NON, false);
                     asmInstruction.setType(rtsType);
                     optimized = true;
                  } else if(immediateJmpTarget != null && immediateJmpTarget != "rts" && !immediateJmpTarget.equals(asmInstruction.getParameter())) {
                     getLog().append("Skipping double jump to " + immediateJmpTarget + " in " + asmInstruction.toString());
                     asmInstruction.setParameter(immediateJmpTarget);
                     optimized = true;
                  }
               }
            }
         }
      }

      return optimized;
   }
}
