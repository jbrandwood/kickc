package dk.camelot64.kickc;

import dk.camelot64.kickc.model.Program;
import kickass.KickAssembler;
import picocli.CommandLine;

import java.io.*;
import java.nio.file.*;
import java.util.concurrent.Callable;

import static junit.framework.TestCase.fail;

/** KickC Commandline */
@CommandLine.Command(description = "Compiles KickC source files to KickAssembler.",
      name = "kickc", mixinStandardHelpOptions = true, version = "KickC 0.5 SNAPSHOT")
public class KickC implements Callable<Void> {

   @CommandLine.Parameters(index = "0", description = "The KickC file to compile.")
   private Path kcFile = null;

   @CommandLine.Option(names = {"-I", "-libdir" }, description = "Path to a library folder, where the compiler looks for included files.")
   private Path libDir = null;

   @CommandLine.Option(names = {"-o"}, description = "Name of the output file. By default it is the same as the input file with extension .asm")
   private String asmFileName = null;

   @CommandLine.Option(names = {"-odir" }, description = "Path to the output folder, where the compiler places all generated files. By default the folder of the output file is used.")
   private Path outputDir = null;

   @CommandLine.Option(names = {"-a"}, description = "Assemble the output file using KickAssembler. Produces a .prg file.")
   private boolean assemble = false;

   @CommandLine.Option(names = {"-e"}, description = "Execute the assembled prg file using VICE. Implicitly assembles the output.")
   private boolean execute = false;

   public static void main(String[] args) throws Exception {
      CommandLine.call(new KickC(), args);
   }

   @Override
   public Void call() throws Exception {
      System.out.println("//-------------------------------------");
      System.out.println("//   " + getVersion() + " by Jesper Gravgaard   ");
      System.out.println("//-------------------------------------");

      Compiler compiler = new Compiler();

      compiler.addImportPath(".");
      if(libDir != null) {
         compiler.addImportPath(libDir.toString());
      }

      String fileBaseName = getFileBaseName(kcFile);

      Path kcFileDir  = kcFile.getParent();
      if(kcFileDir==null) {
         kcFileDir = FileSystems.getDefault().getPath(".");
      }

      if(outputDir==null) {
         outputDir = kcFileDir;
      }
      if(!Files.exists(outputDir)) {
         Files.createDirectory(outputDir);
      }

      if(asmFileName == null) {
         asmFileName = fileBaseName + ".asm";
      }

      System.out.println("Compiling " + kcFile);
      Program program = compiler.compile(kcFile.toString());

      Path asmPath = outputDir.resolve(asmFileName);
      System.out.println("Writing asm file " + asmPath);
      FileOutputStream asmOutputStream = new FileOutputStream(asmPath.toFile());
      OutputStreamWriter asmWriter = new OutputStreamWriter(asmOutputStream);
      String asmCodeString = program.getAsm().toString(false);
      asmWriter.write(asmCodeString);
      asmWriter.close();
      asmOutputStream.close();

      // Copy Resource Files (if out-dir is different from in-dir)
      if(!kcFileDir.toAbsolutePath().equals(outputDir.toAbsolutePath())) {
         for(Path resourcePath : program.getAsmResourceFiles()) {
            Path outResourcePath = outputDir.resolve(resourcePath.getFileName().toString());
            System.out.println("Copying resource " + outResourcePath);
            try {
               Files.copy(resourcePath, outResourcePath);
            } catch(FileAlreadyExistsException e) {
               // Ignore this
            }
         }
      }

      // Assemble the asm-file if instructed
      Path prgPath = outputDir.resolve(fileBaseName + ".prg");
      if(assemble || execute) {
         Path kasmLogPath = outputDir.resolve(fileBaseName+".klog");
         System.out.println("Assembling to " + prgPath.toString());
         ByteArrayOutputStream kasmLogOutputStream = new ByteArrayOutputStream();
         System.setOut(new PrintStream(kasmLogOutputStream));
         int kasmResult = KickAssembler.main2(new String[]{asmPath.toString(), "-log", kasmLogPath.toString(), "-o", prgPath.toString(), "-vicesymbols", "-showmem"});
         System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out)));
         if(kasmResult != 0) {
            fail("KickAssembling file failed! " + kasmLogOutputStream.toString());
         }
      }

      // Execute the prg-file if instructed
      if(execute) {
         System.out.println("Executing " + prgPath);
         Process process = Runtime.getRuntime().exec("x64 " + prgPath.toString() );
         process.waitFor();
      }

      return null;
   }

   /**
    * Get the current version of KickC
    * @return The name and version (eg "KickC 0.5")
    */
   private String getVersion() {
      return new CommandLine(new KickC()).getCommandSpec().version()[0];
   }

   String getFileBaseName(Path file) {
      String name = file.getFileName().toString();
      int i = name.lastIndexOf('.');
      return i > 0 ? name.substring(0, i) : name;
   }

   String getFileExtension(Path file) {
      if(file == null) {
         return "";
      }
      String name = file.getFileName().toString();
      int i = name.lastIndexOf('.');
      return i > 0 ? name.substring(i + 1) : "";
   }

}
