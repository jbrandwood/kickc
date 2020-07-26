package dk.camelot64.kickc.passes;

import dk.camelot64.cpufamily6502.AsmAddressingMode;
import dk.camelot64.cpufamily6502.AsmInstructionSet;
import dk.camelot64.cpufamily6502.AsmOpcode;
import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import kickass.KickAssembler65CE02;
import kickass.nonasm.c64.CharToPetsciiConverter;

import java.io.*;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Identify and fix long branches (over 128 bytes).
 * Requires KickAssembler in CLASS path
 */
public class Pass5FixLongBranches extends Pass5AsmOptimization {

   private Path tmpDir;

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

      // Create a temporary directory for the ASM file
      try {
         tmpDir = Files.createTempDirectory("kickc");
      } catch(IOException e) {
         throw new CompileError("Error creating temp file.", e);
      }

      // Generate the ASM file
      String outputFileName = getProgram().getPrimaryFileName();
      try {
         //getLog().append("ASM");
         //getLog().append(getProgram().getAsm().toString(false, true));

         writeOutputFile(outputFileName, ".asm", getProgram().getAsm().toString(new AsmProgram.AsmPrintState(false), null));

         // Copy Resource Files
         for(Path asmResourceFile : getProgram().getAsmResourceFiles()) {
            File binFile = getTmpFile(asmResourceFile.getFileName().toString());
            Files.copy(asmResourceFile, binFile.toPath());
         }

      } catch(IOException e) {
         throw new CompileError("Error writing ASM temp file.", e);
      }

      // Compile using KickAssembler - catch the output in a String
      File asmFile = getTmpFile(outputFileName, ".asm");
      File binaryFile = getTmpFile(outputFileName, "."+getProgram().getTargetPlatform().getOutFileExtension());
      ByteArrayOutputStream kickAssOut = new ByteArrayOutputStream();
      System.setOut(new PrintStream(kickAssOut));
      int asmRes = -1;
      try {
         CharToPetsciiConverter.setCurrentEncoding("screencode_mixed");
         asmRes = KickAssembler65CE02.main2(new String[]{asmFile.getAbsolutePath(), "-o", binaryFile.getAbsolutePath()});
      } catch(Throwable e) {
         if(e instanceof AssertionError && e.getMessage().contains("Invalid number of bytes in memblock!")) {
            throw new CompileError("Error! KickAssembler failed due to assertion. Please run java without -ea / -enableassertions.", e);
         }  else {
            throw new CompileError("Error! KickAssembler failed, while trying to fix long branch. " + e);
         }
      }  finally {
         System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out)));
      }
      String output = kickAssOut.toString();

      // Look for a long branch distance error
      if(asmRes != 0) {
         String outputLines[] = output.split("\\r?\\n");
         for(int i = 0; i < outputLines.length; i++) {
            String outputLine = outputLines[i];
            if(outputLine.contains("Error: relative address is illegal (jump distance is too far).")) {
               // Found a long branch!
               String contextLine = outputLines[i + 1];
               Pattern contextPattern = Pattern.compile("at line ([0-9]*),.*");
               Matcher matcher = contextPattern.matcher(contextLine);
               //getLog().append("Found long branch "+contextLine);
               if(matcher.matches()) {
                  String contextLineIdxStr = matcher.group(1);
                  int contextLineIdx = Integer.parseInt(contextLineIdxStr);
                  // Found line number
                  //getLog().append("Found long branch line number "+contextLineIdx);
                  if(fixLongBranch(contextLineIdx - 1)) {
                     removeTmpDir();
                     return true;
                  }
               }
               throw new CompileError("Error! Failed to fix long branch at " + contextLine);
            }
         }
      }

      removeTmpDir();
      return false;
   }

   private void removeTmpDir() {
      // Delete the temporary directory with folders
      String[]entries = tmpDir.toFile().list();
      for(String s: entries){
         File currentFile = new File(tmpDir.toFile(),s);
         if(!currentFile.delete()) {
            System.err.println("Warning! Cannot delete temporary file "+currentFile.getAbsolutePath());
         }
      }
      if(!tmpDir.toFile().delete()) {
         System.err.println("Warning! Cannot delete temporary folder "+tmpDir.toAbsolutePath());
      }
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
         if(asmLine != null && asmLine instanceof AsmInstruction) {
            //getLog().append("Found ASM line "+asmLine);
            AsmInstruction asmInstruction = (AsmInstruction) asmLine;
            AsmOpcode asmOpcode = asmInstruction.getAsmOpcode();
            AsmOpcode inverseAsmOpcode = invertBranch(asmOpcode);
            if(inverseAsmOpcode != null) {
               //getLog().append("Inversed branch instruction "+asmInstructionType.getMnemnonic()+" -> "+inverseType.getMnemnonic());
               getLog().append("Fixing long branch [" + idx + "] " + asmLine.toString() + " to " + inverseAsmOpcode.getMnemonic());
               String branchDest = asmInstruction.getParameter();
               asmInstruction.setAsmOpcode(inverseAsmOpcode);
               String newLabel = AsmFormat.asmFix("!" + branchDest);
               asmInstruction.setParameter(newLabel+"+");
               AsmOpcode jmpOpcode = AsmInstructionSet.getOpcode("jmp", AsmAddressingMode.ABS, false);
               AsmInstruction jmpInstruction = new AsmInstruction(jmpOpcode, branchDest);
               asmChunk.addLineAfter(asmInstruction, jmpInstruction);
               asmChunk.addLineAfter(jmpInstruction, new AsmLabel(newLabel));
               return true;
            }
         }
      }
      return false;
   }

   private AsmOpcode invertBranch(AsmOpcode asmOpcode) {
      switch(asmOpcode.getMnemonic()) {
         case "bcc":
            return AsmInstructionSet.getOpcode("bcs", AsmAddressingMode.REL, false);
         case "bcs":
            return AsmInstructionSet.getOpcode("bcc", AsmAddressingMode.REL, false);
         case "beq":
            return AsmInstructionSet.getOpcode("bne", AsmAddressingMode.REL, false);
         case "bne":
            return AsmInstructionSet.getOpcode("beq", AsmAddressingMode.REL, false);
         case "bpl":
            return AsmInstructionSet.getOpcode("bmi", AsmAddressingMode.REL, false);
         case "bmi":
            return AsmInstructionSet.getOpcode("bpl", AsmAddressingMode.REL, false);
         case "bvs":
            return AsmInstructionSet.getOpcode("bvc", AsmAddressingMode.REL, false);
         case "bvc":
            return AsmInstructionSet.getOpcode("bvs", AsmAddressingMode.REL, false);
         default:
            return null;
      }
   }

   public File writeOutputFile(String fileName, String extension, String outputString) throws IOException {
      // Write output file
      File file = getTmpFile(fileName, extension);
      FileOutputStream outputStream = new FileOutputStream(file);
      OutputStreamWriter writer = new OutputStreamWriter(outputStream);
      writer.write(outputString);
      writer.close();
      outputStream.close();
      //System.out.println("Long Branch ASM generated to " + file.getAbsolutePath());
      return file;
   }

   public File getTmpFile(String fileName, String extension) {
      Path kcPath = FileSystems.getDefault().getPath(fileName);
      return new File(tmpDir.toFile(), kcPath.getFileName().toString() + extension);
   }

   public File getTmpFile(String fileName) {
      return new File(tmpDir.toFile(), fileName );
   }

}
