package dk.camelot64.kickc;

import dk.camelot64.kickc.model.CompileError;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Handles output directories and files
 * The binary program output file name generated has the following file name components:
 * <br>
 * <i>output-path / output-basename . output-extension</i>
 * <p>
 * Where each component is determined in the following way:
 * <p>
 * <i>Output-path</i> is the directory where the output files are generated. The following is a prioritized list specifying how the compiler finds this folder:
 * <ol>
 * <li>If the -o command line option is passed and the passed file name contains a directory part, then this directory is used.
 * <li>If the -odir command line option is passed, then this directory is used.
 * <li>If the first C-file passed to the compiler contains a directory part, then this directory is used.
 * <li>Otherwise the current directory is used.
 * </ol>
 * <p>
 * <i>Output-basename</i> is the file name of the output file without path and extension. The following is a prioritized list specifying how the compiler finds the output basename:
 * <ol>
 * <li>If the -o command line option is passed, then the basename of the passed file name is used.
 * <li>The basename of the first C-file passed to the compiler is used.
 * </ol>
 * <p>
 * <i>Output-extension</i> is the file extension of the output file. The following is a prioritized list specifying how the compiler finds the output extension:
 * <ol>
 * <li>If the -o command line option is passed and the compiler has been instructed to assemble the program (using -a or -e), then the extension of the passed file name is used.
 * <li>If the program contains #pragma extension(...) then the specified extension is used.
 * <li>If the -oext command line option is passed, then this extension is used.
 * <li>Otherwise the extension specified in the platform target (.tgt) file for the chosen platform is used.
 * </ol>
 * <p>
 * The ASM output file has the following file name components.
 * <br>
 * <i>output-path / output-basename asm-extension</i>
 * <p>
 * <i>Asm-extension</i> is the file extension of the ASM file. The following is a prioritized list specifying how the compiler finds the output extension:
 * <ol>
 * <li>If the -o command line option is passed and the compiler has not been instructed to assemble the program (using -a or -e), then the extension of the passed file name is used.
 * <li></li>Otherwise the extension “asm” is used
 * </ol>
 */
public class OutputFileManager {

   /** The output file name passed using -o */
   private String outputFileName;

   /** The output directory name passed using -odir */
   private Path outputDir;

   /** The current directory (where the compiler is executed). */
   private Path currentDir;

   /** The primary (first) C-file passed to the compiler. */
   private Path primaryCFile;

   /** The extension specified through #pragma extension, command line option -oext or the target platform TGT-file */
   private String binaryExtension;

   /** Has the compiler been instructed to compile the output file. */
   private boolean assembleOutput;

   public void setAssembleOutput(boolean assembleOutput) {
      this.assembleOutput = assembleOutput;
   }

   public void setOutputFileName(String outputFileName) {
      this.outputFileName = outputFileName;
   }

   public void setOutputDir(Path outputDir) {
      this.outputDir = outputDir;
   }

   public void setCurrentDir(Path currentDir) {
      this.currentDir = currentDir;
   }

   public void setPrimaryCFile(Path primaryCFile) {
      this.primaryCFile = primaryCFile;
   }

   public void setBinaryExtension(String binaryExtension) {
      this.binaryExtension = binaryExtension;
   }

   /**
    * Get the binary output file name with path and extension
    *
    * @return The binary output file
    */
   public Path getBinaryOutputFile() {
      return getOutputFile(getOutputDirectory(), getBinaryExtension());
   }

   /**
    * Get the output file name with a specific extension
    *
    * @return The output file with the specified extension
    */
   public Path getAsmOutputFile() {
      return getOutputFile(getOutputDirectory(), getAsmExtension());
   }

   /**
    * Get the output file name with a specific extension
    *
    * @return The output file with the specified extension
    */
   public Path getOutputFile(String extension) {
      return getOutputFile(getOutputDirectory(), extension);
   }

   /**
    * Get the output file name in a specific directory with a specific extension
    *
    * @return The output file with the specified directory and extension
    */
   public Path getOutputFile(Path outputDir, String extension) {
      String fileName = getOutputBaseName();
      if(extension.length() > 0) fileName += "." + extension;
      final Path outputFile = outputDir.resolve(fileName);
      return outputFile.normalize();
   }

   /**
    * Get the output directory
    * <i>Output-path</i> is the directory where the output files are generated. The following is a prioritized list specifying how the compiler finds this folder:
    * <ol>
    * <li>If the -o command line option is passed and the passed file name contains a directory part, then this directory is used.
    * <li>If the -odir command line option is passed, then this directory is used.
    * <li>If the first C-file passed to the compiler contains a directory part, then this directory is used.
    * <li>Otherwise the current directory is used.
    * </ol>
    *
    * @return The output directory
    */
   public Path getOutputDirectory() {
      // If the -o command line option is passed and the passed file name contains a directory part, then this directory is used.
      if(outputFileName != null) {
         final int lastSlashIdx = Math.max(outputFileName.lastIndexOf('/'), outputFileName.lastIndexOf('\\'));
         if(lastSlashIdx >= 0) {
            final String outputDirName = outputFileName.substring(0, lastSlashIdx);
            final Path outputFilePath = currentDir.resolve(outputDirName);
            if(!Files.exists(outputFilePath)) {
               try {
                  Files.createDirectories(outputFilePath);
               } catch(IOException e) {
                  throw new CompileError("Error creating output directory " + outputFilePath, e);
               }
            }
            return outputFilePath;
         }
      }
      // If the -odir command line option is passed, then this directory is used.
      if(outputDir != null) {
         if(!Files.exists(outputDir)) {
            try {
               Files.createDirectories(outputDir);
            } catch(IOException e) {
               throw new CompileError("Error creating output directory " + outputDir, e);
            }
         }
         return outputDir;
      }
      // If the first C-file passed to the compiler contains a directory part, then this directory is used.
      Path cFileDir = primaryCFile.getParent();
      if(cFileDir != null) {
         return cFileDir;
      }
      // Otherwise the current directory is used.
      return currentDir;
   }

   /**
    * Get the base name of the output file.
    * <i>Output-basename</i> is the file name of the output file without path and extension. The following is a prioritized list specifying how the compiler finds the output basename:
    * <ol>
    * <li>If the -o command line option is passed, then the basename of the passed file name is used.
    * <li>The basename of the first C-file passed to the compiler is used.
    * </ol>
    *
    * @return The output file base name
    */
   public String getOutputBaseName() {
      // If the -o command line option is passed, then the basename of the passed file name is used.
      if(outputFileName != null) {
         final Path outputFilePath = currentDir.resolve(outputFileName);
         return getBaseName(outputFilePath);
      }
      // The basename of the first C-file passed to the compiler is used.
      return getBaseName(primaryCFile);
   }

   /**
    * Get the base file name of a file without parent path and extension
    *
    * @param file The file path
    * @return The file base name
    */
   private static String getBaseName(Path file) {
      String name = file.getFileName().toString();
      int i = name.lastIndexOf('.');
      return i > 0 ? name.substring(0, i) : name;
   }

   /**
    * Get the extension for the binary output file
    * <p>
    * <i>Output-extension</i> is the file extension of the output file. The following is a prioritized list specifying how the compiler finds the output extension:
    * <ol>
    * <li>If the -o command line option is passed, then the extension of the passed file name is used.
    * <li>If the program contains #pragma extension(...) then the specified extension is used.
    * <li>If the -oext command line option is passed, then this extension is used.
    * <li>Otherwise the extension specified in the platform target (.tgt) file for the chosen platform is used.
    * </ol>
    *
    * @return The  binary output file extension
    */
   public String getBinaryExtension() {
      // If the -o command line option is passed, then the extension of the passed file name is used.
      if(assembleOutput && outputFileName != null) {
         final Path outputFilePath = currentDir.resolve(outputFileName);
         return getExtension(outputFilePath);
      }
      // If the program contains #pragma extension(...) then the specified extension is used.
      // If the -oext command line option is passed, then this extension is used.
      // Otherwise the extension specified in the platform target (.tgt) file for the chosen platform is used.
      return binaryExtension;
   }

   /**
    * Get the extension of the ASM file.
    * <p>
    * <i>Asm-extension</i> is the file extension of the ASM file.
    * The following is a prioritized list specifying how the compiler finds the output extension:
    * <ol>
    * <li>If the -o command line option is passed and the compiler has not been instructed to assemble the program (using -a or -e), then the extension of the passed file name is used.
    * <li>Otherwise the extension “asm” is used
    * </ol>
    *
    * @return The extension for the ASM file
    */
   public String getAsmExtension() {
      // If the -o command line option is passed and the compiler has not been instructed to assemble the program (using -a or -e), then the extension of the passed file name is used.
      if(!assembleOutput && outputFileName != null) {
         final Path outputFilePath = currentDir.resolve(outputFileName);
         return getExtension(outputFilePath);
      }
      // Otherwise the extension “asm” is used
      return "asm";
   }

   /**
    * Get the file name extension of a file
    *
    * @param file The file path
    * @return The file name extension
    */
   private static String getExtension(Path file) {
      String name = file.getFileName().toString();
      int i = name.lastIndexOf('.');
      return i > 0 ? name.substring(i + 1) : "";
   }

   /**
    * Determine if the resource files should be copied.
    * The resources are copied if the primary C-file is not located in the output directory
    *
    * @return true if the resources should be copied
    */
   public boolean shouldCopyResources() {
      final Path cFileDirectory = primaryCFile.getParent().toAbsolutePath();
      final Path outputDirectory = getOutputDirectory().toAbsolutePath();
      return !cFileDirectory.equals(outputDirectory);
   }

}