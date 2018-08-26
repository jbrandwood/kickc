package dk.camelot64.kickc;

import dk.camelot64.kickc.model.Program;
import kickass.KickAssembler;
import picocli.CommandLine;

import java.io.*;
import java.util.concurrent.Callable;

import static junit.framework.TestCase.fail;

/** KickC Commandline */
@CommandLine.Command(description = "Compiles KickC source files to KickAssembler.",
      name = "kickc", mixinStandardHelpOptions = true, version = "KickC 0.7")
public class KickC implements Callable<Void> {

   @CommandLine.Parameters(index = "0", description = "The KickC file to compile.")
   private File kcFile = null;

   @CommandLine.Option(names = {"-libdir", "-I"}, description = "Path to a library folder, where the compiler looks for included files.")
   private File libdir = null;

   @CommandLine.Option(names = {"-o"}, description = "Name of the output file. By default it is the same as the input file with extension .asm")
   private String asmFileName = null;

   @CommandLine.Option(names = {"-a"}, description = "Assemble the output file using KickAssembler. Produces a .prg file.")
   private boolean assemble = false;

   public static void main(String[] args) throws Exception {
      CommandLine.call(new KickC(), args);
   }

   @Override
   public Void call() throws Exception {
      System.out.println("//------------------------------------");
      System.out.println("//   KickC v0.7 by Jesper Gravgaard   ");
      System.out.println("//------------------------------------");
      Compiler compiler = new Compiler();
      if(libdir != null) {
         compiler.addImportPath(libdir.getPath());
      }

      String outDirName = kcFile.getParent();
      File outDir = new File(".");

      if(asmFileName == null) {
         asmFileName = getFileBaseName(kcFile) + ".asm";
      }
      File asmFile = new File(asmFileName);
      System.out.println("Compiling "+ kcFile.getPath());
      Program program = compiler.compile(kcFile.getName());
      System.out.println("Writing asm file "+ asmFileName);
      FileOutputStream outputStream = new FileOutputStream(asmFileName);
      OutputStreamWriter writer = new OutputStreamWriter(outputStream);
      String assembler = program.getAsm().toString(false);
      writer.write(assembler);
      writer.close();
      outputStream.close();

      // Copy Resource Files (if out-dir is different from current dir)

      if(assemble) {
         File asmPrgFile = new File(getFileBaseName(kcFile)+ ".prg");
         File asmLogFile = new File(getFileBaseName(kcFile)+ ".klog");
         System.out.println("Assembling to "+ asmPrgFile.getPath());
         ByteArrayOutputStream kickAssOut = new ByteArrayOutputStream();
         System.setOut(new PrintStream(kickAssOut));
         int asmRes = KickAssembler.main2(new String[]{asmFile.getAbsolutePath(), "-log", asmLogFile.getAbsolutePath(), "-o", asmPrgFile.getAbsolutePath(), "-vicesymbols", "-showmem"});
         System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out)));
         if(asmRes != 0) {
            fail("KickAssembling file failed! " + kickAssOut.toString());
         }
      }

      return null;
   }

   String getFileBaseName(File file) {
      String name = file.getName();
      int i = name.lastIndexOf('.');
      return i > 0 ? name.substring(0, i) : name;
   }

   String getFileExtension(File file) {
      if(file == null) {
         return "";
      }
      String name = file.getName();
      int i = name.lastIndexOf('.');
      return i > 0 ? name.substring(i + 1) : "";
   }

}
