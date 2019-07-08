package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import kickass.KickAssembler;

import java.io.*;
import java.nio.file.*;
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
      String fileName = getProgram().getFileName();
      try {
         //getLog().append("ASM");
         //getLog().append(getProgram().getAsm().toString(false, true));

         writeOutputFile(fileName, ".asm", getProgram().getAsm().toString(new AsmProgram.AsmPrintState(false, false), null));

         // Copy Resource Files
         for(Path asmResourceFile : getProgram().getAsmResourceFiles()) {
            File binFile = getTmpFile(asmResourceFile.getFileName().toString());
            Files.copy(asmResourceFile, binFile.toPath());
         }

      } catch(IOException e) {
         throw new CompileError("Error writing ASM temp file.", e);
      }

      // Compile using KickAssembler - catch the output in a String
      File asmFile = getTmpFile(fileName, ".asm");
      File asmPrgFile = getTmpFile(fileName, ".prg");
      ByteArrayOutputStream kickAssOut = new ByteArrayOutputStream();
      System.setOut(new PrintStream(kickAssOut));
      int asmRes = -1;
      try {
         asmRes = KickAssembler.main2(new String[]{asmFile.getAbsolutePath(), "-o", asmPrgFile.getAbsolutePath()});
      } catch(Throwable e) {
         throw new CompileError("Error! KickAssembler failed, while trying to fix long branch. " + e);
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
                     return true;
                  }
               }
               throw new CompileError("Error! Failed to fix long branch at " + contextLine);
            }
         }
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
      AsmSegment asmSegment = asm.getAsmSegment(idx);
      if(asmSegment != null) {
         //getLog().append("Found ASM segment "+asmSegment);
         AsmLine asmLine = asmSegment.getAsmLine(idx);
         if(asmLine != null && asmLine instanceof AsmInstruction) {
            //getLog().append("Found ASM line "+asmLine);
            AsmInstruction asmInstruction = (AsmInstruction) asmLine;
            AsmInstructionType asmInstructionType = asmInstruction.getType();
            AsmInstructionType inverseType = invertBranch(asmInstructionType);
            if(inverseType != null) {
               //getLog().append("Inversed branch instruction "+asmInstructionType.getMnemnonic()+" -> "+inverseType.getMnemnonic());
               getLog().append("Fixing long branch [" + idx + "] " + asmLine.toString() + " to " + inverseType.getMnemnonic());
               String branchDest = asmInstruction.getParameter();
               asmInstruction.setType(inverseType);
               String newLabel = ("!" + branchDest).replace("$","_");
               asmInstruction.setParameter(newLabel+"+");
               AsmInstructionType jmpType = AsmInstructionSet.getInstructionType("jmp", AsmAddressingMode.ABS, false);
               AsmInstruction jmpInstruction = new AsmInstruction(jmpType, branchDest);
               asmSegment.addLineAfter(asmInstruction, jmpInstruction);
               asmSegment.addLineAfter(jmpInstruction, new AsmLabel(newLabel));
               return true;
            }
         }
      }
      return false;
   }

   private AsmInstructionType invertBranch(AsmInstructionType type) {
      switch(type.getMnemnonic()) {
         case "bcc":
            return AsmInstructionSet.getInstructionType("bcs", AsmAddressingMode.REL, false);
         case "bcs":
            return AsmInstructionSet.getInstructionType("bcc", AsmAddressingMode.REL, false);
         case "beq":
            return AsmInstructionSet.getInstructionType("bne", AsmAddressingMode.REL, false);
         case "bne":
            return AsmInstructionSet.getInstructionType("beq", AsmAddressingMode.REL, false);
         case "bpl":
            return AsmInstructionSet.getInstructionType("bmi", AsmAddressingMode.REL, false);
         case "bmi":
            return AsmInstructionSet.getInstructionType("bpl", AsmAddressingMode.REL, false);
         case "bvs":
            return AsmInstructionSet.getInstructionType("bvc", AsmAddressingMode.REL, false);
         case "bvc":
            return AsmInstructionSet.getInstructionType("bvs", AsmAddressingMode.REL, false);
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
