package dk.camelot64.kickc.passes;

import dk.camelot64.cpufamily6502.AsmAddressingMode;
import dk.camelot64.cpufamily6502.AsmInstructionSet;
import dk.camelot64.cpufamily6502.AsmOpcode;
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
      for(AsmChunk chunk : getAsmProgram().getChunks()) {
         for(AsmLine line : chunk.getLines()) {
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
            } else if(line instanceof AsmBasicUpstart || line instanceof AsmDataNumeric || line instanceof AsmDataFill || line instanceof AsmDataString || line instanceof AsmDataAlignment || line instanceof AsmSetPc || line instanceof AsmInlineKickAsm|| line instanceof AsmSetEncoding|| line instanceof AsmSetCpu|| line instanceof AsmDataKickAsm|| line instanceof AsmSegmentDef|| line instanceof AsmSegment|| line instanceof AsmFile) {
               currentLabel = null;
            } else if(line instanceof AsmInstruction) {
               if(currentLabel != null) {
                  AsmInstruction asmInstruction = (AsmInstruction) line;
                  AsmOpcode jmpOpcode = AsmInstructionSet.getOpcode("jmp", AsmAddressingMode.ABS, false);
                  AsmOpcode rtsOpcode = AsmInstructionSet.getOpcode("rts", AsmAddressingMode.NON, false);
                  if(asmInstruction.getAsmOpcode().equals(jmpOpcode)) {
                     immediateJumps.put(currentScope + "::" + currentLabel, asmInstruction.getParameter());
                  }
                  if(asmInstruction.getAsmOpcode().equals(rtsOpcode)) {
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
      for(AsmChunk chunk : getAsmProgram().getChunks()) {
         for(AsmLine line : chunk.getLines()) {
            if(line instanceof AsmScopeBegin) {
               currentScope = ((AsmScopeBegin) line).getLabel();
            } else if(line instanceof AsmScopeEnd) {
               currentScope = "";
            } else if(line instanceof AsmInstruction) {
               AsmInstruction asmInstruction = (AsmInstruction) line;
               if(asmInstruction.getAsmOpcode().isJump()) {
                  String immediateJmpTarget = immediateJumps.get(currentScope + "::" + asmInstruction.getParameter());
                  if(immediateJmpTarget == "rts" && asmInstruction.getAsmOpcode().getMnemonic() == "jmp") {
                     getLog().append("Replacing jump to rts with rts in " + asmInstruction.toString());
                     AsmOpcode rtsOpcode = AsmInstructionSet.getOpcode("rts", AsmAddressingMode.NON, false);
                     asmInstruction.setAsmOpcode(rtsOpcode);
                     asmInstruction.setParameter(null);
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
