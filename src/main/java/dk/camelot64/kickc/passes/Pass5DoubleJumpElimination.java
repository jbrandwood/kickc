package dk.camelot64.kickc.passes;

import dk.camelot64.cpufamily6502.CpuAddressingMode;
import dk.camelot64.cpufamily6502.CpuOpcode;
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
            } else if(line instanceof AsmBasicUpstart || line instanceof AsmDataNumeric || line instanceof AsmDataZeroFill || line instanceof AsmDataString || line instanceof AsmDataAlignment || line instanceof AsmSetPc || line instanceof AsmInlineKickAsm|| line instanceof AsmSetEncoding|| line instanceof AsmSetCpu|| line instanceof AsmDataKickAsm|| line instanceof AsmSegmentDef|| line instanceof AsmSegment|| line instanceof AsmFile) {
               currentLabel = null;
            } else if(line instanceof AsmInstruction) {
               if(currentLabel != null) {
                  AsmInstruction asmInstruction = (AsmInstruction) line;
                  CpuOpcode jmpOpcode = getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("jmp", CpuAddressingMode.ABS, false);
                  CpuOpcode rtsOpcode = getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("rts", CpuAddressingMode.NON, false);
                  if(asmInstruction.getCpuOpcode().equals(jmpOpcode)) {
                     immediateJumps.put(currentScope + "::" + currentLabel, asmInstruction.getOperand1());
                  }
                  if(asmInstruction.getCpuOpcode().equals(rtsOpcode)) {
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
               if(asmInstruction.getCpuOpcode().isJump()) {
                  String jumpTarget = immediateJumps.get(currentScope + "::" + asmInstruction.getOperandJumpTarget());
                  if(jumpTarget == "rts" && asmInstruction.getCpuOpcode().getMnemonic() == "jmp") {
                     getLog().append("Replacing jump to rts with rts in " + asmInstruction.toString());
                     CpuOpcode rtsOpcode = getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("rts", CpuAddressingMode.NON, false);
                     asmInstruction.setCpuOpcode(rtsOpcode);
                     asmInstruction.setOperand1(null);
                     asmInstruction.setOperand2(null);
                     optimized = true;
                  } else if(jumpTarget != null && jumpTarget != "rts" && !jumpTarget.equals(asmInstruction.getOperandJumpTarget())) {
                     getLog().append("Skipping double jump to " + jumpTarget + " in " + asmInstruction.toString());
                     asmInstruction.setOperandJumpTarget(jumpTarget);
                     optimized = true;
                  }
               }
            }
         }
      }

      return optimized;
   }
}
