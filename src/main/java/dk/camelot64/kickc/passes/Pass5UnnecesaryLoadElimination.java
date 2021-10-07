package dk.camelot64.kickc.passes;

import dk.camelot64.cpufamily6502.CpuAddressingMode;
import dk.camelot64.cpufamily6502.CpuOpcode;
import dk.camelot64.kickc.asm.AsmChunk;
import dk.camelot64.kickc.asm.AsmInstruction;
import dk.camelot64.kickc.asm.AsmLine;
import dk.camelot64.kickc.asm.AsmProgramStaticRegisterValues;
import dk.camelot64.kickc.model.Program;

import java.util.List;
import java.util.ListIterator;

/**
 * Maps out register values entering all instructions. Removes unnecessary loads / clears / sets
 */
public class Pass5UnnecesaryLoadElimination extends Pass5AsmOptimization {

   public Pass5UnnecesaryLoadElimination(Program program) {
      super(program);
   }

   @Override
   public boolean optimize() {
      AsmProgramStaticRegisterValues staticValues = new AsmProgramStaticRegisterValues(getAsmProgram());
      boolean modified = false;

      for(AsmChunk chunk : getAsmProgram().getChunks()) {
         List<AsmLine> lines = chunk.getLines();
         ListIterator<AsmLine> lineIt = lines.listIterator();
         while(lineIt.hasNext()) {
            AsmLine line = lineIt.next();
            if(line instanceof AsmInstruction) {
               AsmInstruction instruction = (AsmInstruction) line;
               if(instruction.isNoOptimize()) {
                  continue;
               }
               CpuOpcode cpuOpcode = instruction.getCpuOpcode();

               if(cpuOpcode.getMnemonic().equals("lda") && cpuOpcode.getAddressingMode().equals(CpuAddressingMode.IMM)) {
                  String immValue = instruction.getOperand1();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getA(), immValue)) {
                     modified = remove(lineIt);
                  } else if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getX(), immValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TXA");
                     instruction.setCpuOpcode(getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("txa", CpuAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  } else if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getY(), immValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TYA");
                     instruction.setCpuOpcode(getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("tya", CpuAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  } else if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getZ(), immValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TZA");
                     instruction.setCpuOpcode(getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("tza", CpuAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  }
               }
               if(cpuOpcode.getMnemonic().equals("lda") && (cpuOpcode.getAddressingMode().equals(CpuAddressingMode.ZP) || cpuOpcode.getAddressingMode().equals(CpuAddressingMode.ABS))) {
                  String memValue = instruction.getOperand1();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(instructionValues.getaMem() != null && instructionValues.getaMem().equals(memValue)) {
                     modified = remove(lineIt);
                  } else if(instructionValues.getxMem() != null && instructionValues.getxMem().equals(memValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TXA");
                     instruction.setCpuOpcode(getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("txa", CpuAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  } else if(instructionValues.getyMem() != null && instructionValues.getyMem().equals(memValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TYA");
                     instruction.setCpuOpcode(getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("tya", CpuAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  } else if(instructionValues.getzMem() != null && instructionValues.getzMem().equals(memValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TZA");
                     instruction.setCpuOpcode(getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("tza", CpuAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  }
               }
               if(cpuOpcode.getMnemonic().equals("ldx") && cpuOpcode.getAddressingMode().equals(CpuAddressingMode.IMM)) {
                  String immValue = instruction.getOperand1();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getX(), immValue)) {
                     modified = remove(lineIt);
                  } else if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getA(), immValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TAX");
                     instruction.setCpuOpcode(getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("tax", CpuAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  }
               }
               if(cpuOpcode.getMnemonic().equals("ldx") && (cpuOpcode.getAddressingMode().equals(CpuAddressingMode.ZP) || cpuOpcode.getAddressingMode().equals(CpuAddressingMode.ABS))) {
                  String memValue = instruction.getOperand1();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(instructionValues.getxMem() != null && instructionValues.getxMem().equals(memValue)) {
                     modified = remove(lineIt);
                  } else if(instructionValues.getaMem() != null && instructionValues.getaMem().equals(memValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TAX");
                     instruction.setCpuOpcode(getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("tax", CpuAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  }
               }
               if(cpuOpcode.getMnemonic().equals("ldy") && cpuOpcode.getAddressingMode().equals(CpuAddressingMode.IMM)) {
                  String immValue = instruction.getOperand1();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getY(), immValue)) {
                     modified = remove(lineIt);
                  } else if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getA(), immValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TAY");
                     instruction.setCpuOpcode(getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("tay", CpuAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  }
               }
               if(cpuOpcode.getMnemonic().equals("ldy") && (cpuOpcode.getAddressingMode().equals(CpuAddressingMode.ZP) || cpuOpcode.getAddressingMode().equals(CpuAddressingMode.ABS))) {
                  String memValue = instruction.getOperand1();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(instructionValues.getyMem() != null && instructionValues.getyMem().equals(memValue)) {
                     modified = remove(lineIt);
                  } else if(instructionValues.getaMem() != null && instructionValues.getaMem().equals(memValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TAY");
                     instruction.setCpuOpcode(getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("tay", CpuAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  }
               }
               if(cpuOpcode.getMnemonic().equals("ldz") && cpuOpcode.getAddressingMode().equals(CpuAddressingMode.IMM)) {
                  String immValue = instruction.getOperand1();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getZ(), immValue)) {
                     modified = remove(lineIt);
                  } else if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getA(), immValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TAZ");
                     instruction.setCpuOpcode(getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("taz", CpuAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  }
               }
               if(cpuOpcode.getMnemonic().equals("ldz") && (cpuOpcode.getAddressingMode().equals(CpuAddressingMode.ZP) || cpuOpcode.getAddressingMode().equals(CpuAddressingMode.ABS))) {
                  String memValue = instruction.getOperand1();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(instructionValues.getzMem() != null && instructionValues.getzMem().equals(memValue)) {
                     modified = remove(lineIt);
                  } else if(instructionValues.getaMem() != null && instructionValues.getaMem().equals(memValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TAZ");
                     instruction.setCpuOpcode(getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("taz", CpuAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  }
               }
               if(cpuOpcode.getMnemonic().equals("clc")) {
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(Boolean.FALSE.equals(instructionValues.getFlagC())) {
                     modified = remove(lineIt);
                  }
               }
               if(cpuOpcode.getMnemonic().equals("sec")) {
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(Boolean.TRUE.equals(instructionValues.getFlagC())) {
                     modified = remove(lineIt);
                  }
               }
            }
         }
      }
      return modified;
   }

}
