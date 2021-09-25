package dk.camelot64.kickc.passes;

import dk.camelot64.cpufamily6502.CpuAddressingMode;
import dk.camelot64.cpufamily6502.CpuOpcode;
import dk.camelot64.kickc.TmpDirManager;
import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import kickass.KickAssembler65CE02;
import kickass.nonasm.c64.CharToPetsciiConverter;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Identify and fix long branches (over 128 bytes).
 * Requires KickAssembler in CLASS path
 */
public class Pass5FixLongBranches extends Pass5AsmOptimization {

   public Pass5FixLongBranches(Program program) {
      super(program);
   }

   public boolean optimize() {

      // Make sure KickAssembler is present
      try {
         Class.forName("kickass.KickAssembler", false, getClass().getClassLoader());
      } catch(ClassNotFoundException e) {
         getLog().append("Warning! KickAssembler not found in java CLASSPATH. Cannot eliminate long branches.");
      }

      // Perform repeated optimization until no more branches are too long
      boolean anyOptimized = false;
      boolean stepOptimized = true;
      while(stepOptimized) {
         stepOptimized = step();
         anyOptimized = true;
      }
      return anyOptimized;
   }

   /**
    * Detect if any branch distance is to long, and fix it by rewriting the branch if it is.
    *
    * @return true if any branch was rewritten
    */
   private boolean step() {
      // Reindex ASM lines
      new Pass5ReindexAsmLines(getProgram()).optimize();
      Path tmpDir = TmpDirManager.MANAGER.newTmpDir();
      // Generate the ASM file
      try {
         //getLog().append("ASM");
         //getLog().append(getProgram().getAsm().toString(false, true));
         final Path asmFilePath = getProgram().getOutputFileManager().getOutputFile(tmpDir, getProgram().getOutputFileManager().getAsmExtension());
         writeOutputFile(asmFilePath, getProgram().getAsm().toString(new AsmProgram.AsmPrintState(false), null));
         // Copy Resource Files
         for(Path asmResourceFile : getProgram().getAsmResourceFiles()) {
            File binFile = getTmpFile(tmpDir, asmResourceFile.getFileName().toString());
            Files.copy(asmResourceFile, binFile.toPath());
         }
      } catch(IOException e) {
         throw new CompileError("Error writing ASM temp file.", e);
      }

      // Compile using KickAssembler - catch the output in a String
      File asmFile = getProgram().getOutputFileManager().getOutputFile(tmpDir, getProgram().getOutputFileManager().getAsmExtension()).toFile();
      File binaryFile = getProgram().getOutputFileManager().getOutputFile(tmpDir, getProgram().getOutputFileManager().getBinaryExtension()).toFile();
      ByteArrayOutputStream kickAssOut = new ByteArrayOutputStream();
      System.setOut(new PrintStream(kickAssOut));
      int asmRes = -1;
      try {
         CharToPetsciiConverter.setCurrentEncoding("screencode_mixed");
         asmRes = KickAssembler65CE02.main2(new String[]{asmFile.getAbsolutePath(), "-o", binaryFile.getAbsolutePath()});
      } catch(Throwable e) {
         if(e instanceof AssertionError && e.getMessage().contains("Invalid number of bytes in memblock!")) {
            throw new CompileError("Error! KickAssembler failed due to assertion. Please run java without -ea / -enableassertions.", e);
         } else {
            throw new CompileError("Error! KickAssembler failed, while trying to fix long branch. " + e);
         }
      } finally {
         System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out)));
      }
      String output = kickAssOut.toString();

      if(getLog().isVerboseFixLongBranch())
         getLog().append("Pass5FixLongBranches: ASM process result " + asmRes);

      // Look for a long branch distance error
      if(asmRes != 0) {
         String outputLines[] = output.split("\\r?\\n");
         for(int i = 0; i < outputLines.length; i++) {
            String outputLine = outputLines[i];
            if(outputLine.contains("Error: relative address is illegal (jump distance is too far).")) {
               // Found a long branch!
               String contextLine = outputLines[i + 1];
               if(getLog().isVerboseFixLongBranch())
                  getLog().append("Pass5FixLongBranches: Found long branch " + contextLine);
               Pattern contextPattern = Pattern.compile("at line ([0-9]*),.*");
               Matcher matcher = contextPattern.matcher(contextLine);
               if(matcher.matches()) {
                  String contextLineIdxStr = matcher.group(1);
                  int contextLineIdx = Integer.parseInt(contextLineIdxStr);
                  // Found line number
                  if(getLog().isVerboseFixLongBranch())
                     getLog().append("Pass5FixLongBranches: Found long branch line number " + contextLineIdx);
                  if(fixLongBranch(contextLineIdx - 1)) {
                     return true;
                  }
               }
               throw new CompileError("Error! Failed to fix long branch at " + contextLine);
            }
         }
         // KickAssembler returned error, but no long branch was found. Fail with the output from KickAss
         throw new CompileError("Error! Failed to compile using KickAss\n" + output);
      }
      return false;
   }

   /**
    * Fix a long branch detected at a specific ASM index
    *
    * @param idx The index of the ASM line with the long branch
    * @return True if the branch was fixed
    */
   private boolean fixLongBranch(int idx) {
      AsmProgram asm = getProgram().getAsm();
      AsmChunk asmChunk = asm.getAsmChunk(idx);
      if(asmChunk != null) {
         //getLog().append("Found ASM chunk "+asmChunk);
         AsmLine asmLine = asmChunk.getAsmLine(idx);
         if(asmLine instanceof AsmInstruction) {
            //getLog().append("Found ASM line "+asmLine);
            AsmInstruction asmInstruction = (AsmInstruction) asmLine;
            CpuOpcode cpuOpcode = asmInstruction.getCpuOpcode();
            CpuOpcode inverseCpuOpcode = invertBranch(cpuOpcode);
            if(inverseCpuOpcode != null) {
               //getLog().append("Inversed branch instruction "+asmInstructionType.getMnemnonic()+" -> "+inverseType.getMnemnonic());
               getLog().append("Fixing long branch [" + idx + "] " + asmLine.toString() + " to " + inverseCpuOpcode.getMnemonic());
               String branchDest = asmInstruction.getOperandJumpTarget();
               asmInstruction.setCpuOpcode(inverseCpuOpcode);
               String newLabel = AsmFormat.asmFix("!" + branchDest);
               asmInstruction.setOperandJumpTarget(newLabel + "+");
               CpuOpcode jmpOpcode = getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("jmp", CpuAddressingMode.ABS, false);
               AsmInstruction jmpInstruction = new AsmInstruction(jmpOpcode, branchDest, null);
               asmChunk.addLineAfter(asmInstruction, jmpInstruction);
               asmChunk.addLineAfter(jmpInstruction, new AsmLabel(newLabel));
               return true;
            }
         }
      }
      return false;
   }

   private CpuOpcode invertBranch(CpuOpcode cpuOpcode) {
      switch(cpuOpcode.getMnemonic()) {
         case "bcc":
            return getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("bcs", CpuAddressingMode.REL, false);
         case "bcs":
            return getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("bcc", CpuAddressingMode.REL, false);
         case "beq":
            return getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("bne", CpuAddressingMode.REL, false);
         case "bne":
            return getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("beq", CpuAddressingMode.REL, false);
         case "bpl":
            return getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("bmi", CpuAddressingMode.REL, false);
         case "bmi":
            return getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("bpl", CpuAddressingMode.REL, false);
         case "bvs":
            return getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("bvc", CpuAddressingMode.REL, false);
         case "bvc":
            return getAsmProgram().getTargetCpu().getCpu65xx().getOpcode("bvs", CpuAddressingMode.REL, false);
         default:
            return null;
      }
   }

   private File writeOutputFile(Path outputFile, String outputString) throws IOException {
      // Write output file
      File file = outputFile.toFile();
      FileOutputStream outputStream = new FileOutputStream(file);
      OutputStreamWriter writer = new OutputStreamWriter(outputStream);
      writer.write(outputString);
      writer.close();
      outputStream.close();
      //System.out.println("Long Branch ASM generated to " + file.getAbsolutePath());
      return file;
   }

   private static File getTmpFile(Path tmpDir, String fileName) {
      return new File(tmpDir.toFile(), fileName);
   }

}
