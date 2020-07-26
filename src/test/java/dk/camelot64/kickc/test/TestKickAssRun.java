package dk.camelot64.kickc.test;

import kickass.KickAssembler65CE02;
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

   /**
    * Test running KickAsm assembler to compile an ASM file
    */
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
         KickAssembler65CE02.main2(new String[]{asmPath.toAbsolutePath().toString(), "-o", asmPrgFile.getAbsolutePath()});
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

   @Test
   public void testPetsciiEscapeSequences() {

      printPetscii("petscii_mixed", '\b', "\\b");
      printPetscii("petscii_mixed", '\f', "\\f");
      printPetscii("petscii_mixed", '\n', "\\n");
      printPetscii("petscii_mixed", '\r', "\\r");
      printPetscii("petscii_mixed", '\t', "\\t");
      printPetscii("petscii_mixed", '\\', "\\\\");
      printPetscii("petscii_mixed", '\'', "\\'");
      printPetscii("petscii_mixed", '\"', "\\\"");

      printPetscii("petscii_upper", '\b', "\\b");
      printPetscii("petscii_upper", '\f', "\\f");
      printPetscii("petscii_upper", '\n', "\\n");
      printPetscii("petscii_upper", '\r', "\\r");
      printPetscii("petscii_upper", '\t', "\\t");
      printPetscii("petscii_upper", '\\', "\\\\");
      printPetscii("petscii_upper", '\'', "\\'");
      printPetscii("petscii_upper", '\"', "\\\"");

      printPetscii("screencode_mixed", '\b', "\\b");
      printPetscii("screencode_mixed", '\f', "\\f");
      printPetscii("screencode_mixed", '\n', "\\n");
      printPetscii("screencode_mixed", '\r', "\\r");
      printPetscii("screencode_mixed", '\t', "\\t");
      printPetscii("screencode_mixed", '\\', "\\\\");
      printPetscii("screencode_mixed", '\'', "\\'");
      printPetscii("screencode_mixed", '\"', "\\\"");

      printPetscii("screencode_upper", '\b', "\\b");
      printPetscii("screencode_upper", '\f', "\\f");
      printPetscii("screencode_upper", '\n', "\\n");
      printPetscii("screencode_upper", '\r', "\\r");
      printPetscii("screencode_upper", '\t', "\\t");
      printPetscii("screencode_upper", '\\', "\\\\");
      printPetscii("screencode_upper", '\'', "\\'");
      printPetscii("screencode_upper", '\"', "\\\"");
   }

   private void printPetscii(String encoding, char ch, String sCh) {
      CharToPetsciiConverter.setCurrentEncoding(encoding);
      Byte petscii = CharToPetsciiConverter.convert(ch);
      System.out.println(encoding+": "+sCh+" > "+(petscii==null?"null":(int)petscii));
   }


}
