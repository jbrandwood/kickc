package dk.camelot64.kickc.test;

import kickass.KickAssembler;
import kickass.nonasm.c64.CharToPetsciiConverter;
import org.junit.Test;

import java.io.*;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class TestKickAssRun {

   @Test
   public void testKickAssRun() throws IOException, URISyntaxException {
      ReferenceHelper asmHelper = new ReferenceHelperFolder("src/test/java/dk/camelot64/kickc/test/");
      URI asmUri = asmHelper.loadReferenceFile("kickasstest", ".asm");
      Path asmPath = Paths.get(asmUri);
      File asmPrgFile = getTmpFile("kickasstest", ".prg");
      ByteArrayOutputStream kickAssOut = new ByteArrayOutputStream();
      System.setOut(new PrintStream(kickAssOut));
      try {
         CharToPetsciiConverter.setCurrentEncoding("screencode_mixed");
         KickAssembler.main2(new String[]{asmPath.toAbsolutePath().toString(), "-o", asmPrgFile.getAbsolutePath()});
      } catch (AssertionError e) {
         System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out)));
         String output = kickAssOut.toString();
         System.out.println(output);
         throw e;
      } finally {
         System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out)));
      }
      String output = kickAssOut.toString();
      System.out.println(output);
   }


   public File getTmpFile(String fileName, String extension) throws IOException {
      Path tmpDir = Files.createTempDirectory("kickc");
      Path kcPath = FileSystems.getDefault().getPath(fileName);
      return new File(tmpDir.toFile(), kcPath.getFileName().toString() + extension);
   }


}
