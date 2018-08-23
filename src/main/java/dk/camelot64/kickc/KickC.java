package dk.camelot64.kickc;

import dk.camelot64.kickc.model.Program;
import picocli.CommandLine;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.concurrent.Callable;

/** KickC Commandline */
@CommandLine.Command(description = "Compiles KickC source files to KickAssembler.",
      name = "kickc", mixinStandardHelpOptions = true, version = "KickC 0.7")
public class KickC implements Callable<Void> {

   @CommandLine.Parameters(index = "0", description = "The KickC file to compile.")
   private File file = null;

   @CommandLine.Option(names = {"-libdir", "-I"}, description = "Path to a library folder, where the compiler looks for included files.")
   private File libdir = null;

   @CommandLine.Option(names = {"-o"}, description = "Name of the output file. By default it is the same as the input file with extension .asm")
   private String outname = null;

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
      if(outname == null) {
         outname = getFileBaseName(file) + ".asm";
      }
      System.out.println("Compiling "+file.getPath());
      Program program = compiler.compile(file.getName());
      System.out.println("Writing asm file "+outname);
      FileOutputStream outputStream = new FileOutputStream(outname);
      OutputStreamWriter writer = new OutputStreamWriter(outputStream);
      String assembler = program.getAsm().toString(false);
      writer.write(assembler);
      writer.close();
      outputStream.close();

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
