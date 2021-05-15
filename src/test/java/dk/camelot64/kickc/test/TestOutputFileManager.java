package dk.camelot64.kickc.test;

import dk.camelot64.kickc.OutputFileManager;
import org.junit.jupiter.api.Test;

import java.nio.file.FileSystems;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class TestOutputFileManager {

   private static  Path path(String s) {
      return FileSystems.getDefault().getPath(s);
   }

   @Test
   /** The default file is current-dir / primary-file-basename . extension */
   void testDefaultFileNames() {
      final OutputFileManager outputFileManager = new OutputFileManager();
      outputFileManager.setCurrentDir(path("."));
      outputFileManager.setBinaryExtension("prg");
      outputFileManager.setPrimaryCFile(path("test.c"));
      assertEquals(path("test.prg"), outputFileManager.getBinaryOutputFile());
      assertEquals(path("test.asm"), outputFileManager.getAsmOutputFile());
   }

   @Test
   /** If the input file is in a folder the output file is  input-dir / primary-file-basename . extension */
   void testInputFolder() {
      final OutputFileManager outputFileManager = new OutputFileManager();
      outputFileManager.setCurrentDir(path("."));
      outputFileManager.setBinaryExtension("prg");
      outputFileManager.setPrimaryCFile(path("qwe/test.c"));
      assertEquals(path("qwe/test.prg"), outputFileManager.getBinaryOutputFile());
      assertEquals(path("qwe/test.asm"), outputFileManager.getAsmOutputFile());
   }

   @Test
   /** If -odir is passed this overwrites the input folder odir / primary-file-basename . extension */
   void testOutputDirFolder() {
      final OutputFileManager outputFileManager = new OutputFileManager();
      outputFileManager.setCurrentDir(path("."));
      outputFileManager.setBinaryExtension("prg");
      outputFileManager.setPrimaryCFile(path("qwe/test.c"));
      outputFileManager.setOutputDir(path("asd"));
      assertEquals(path("asd/test.prg"), outputFileManager.getBinaryOutputFile());
      assertEquals(path("asd/test.asm"), outputFileManager.getAsmOutputFile());
   }

   @Test
   /** If -o is passed with a folder name this overwrites the input folder and odir - output-dir / primary-file-basename . extension */
   void testOutputFileFolder() {
      final OutputFileManager outputFileManager = new OutputFileManager();
      outputFileManager.setCurrentDir(path("."));
      outputFileManager.setBinaryExtension("prg");
      outputFileManager.setPrimaryCFile(path("qwe/test.c"));
      outputFileManager.setOutputDir(path("asd"));
      outputFileManager.setAssembleOutput(true);
      outputFileManager.setOutputFileName("zxc/test.prg");
      assertEquals(path("zxc/test.prg"), outputFileManager.getBinaryOutputFile());
      assertEquals(path("zxc/test.asm"), outputFileManager.getAsmOutputFile());
   }

   @Test
   /** If -o is passed without a folder name we fall back to odir - odir / primary-file-basename . extension */
   void testOutputFileNoFolder() {
      final OutputFileManager outputFileManager = new OutputFileManager();
      outputFileManager.setCurrentDir(path("."));
      outputFileManager.setBinaryExtension("prg");
      outputFileManager.setPrimaryCFile(path("qwe/test.c"));
      outputFileManager.setOutputDir(path("asd"));
      outputFileManager.setAssembleOutput(true);
      outputFileManager.setOutputFileName("test.prg");
      assertEquals(path("asd/test.prg"), outputFileManager.getBinaryOutputFile());
      assertEquals(path("asd/test.asm"), outputFileManager.getAsmOutputFile());
   }

   @Test
   /** If -o is passed this overwrites the basename of the input file - output-dir / primary-file-basename . extension */
   void testOutputFileBaseName() {
      final OutputFileManager outputFileManager = new OutputFileManager();
      outputFileManager.setCurrentDir(path("."));
      outputFileManager.setBinaryExtension("prg");
      outputFileManager.setPrimaryCFile(path("qwe/test.c"));
      outputFileManager.setOutputDir(path("asd"));
      outputFileManager.setAssembleOutput(true);
      outputFileManager.setOutputFileName("zxc/prod.prg");
      assertEquals(path("zxc/prod.prg"), outputFileManager.getBinaryOutputFile());
      assertEquals(path("zxc/prod.asm"), outputFileManager.getAsmOutputFile());
   }

   @Test
   /** If -o is passed and assembleout=true this overwrites the file binary extension - output-dir / primary-file-basename . output-extension */
   void testOutputFileExtension() {
      final OutputFileManager outputFileManager = new OutputFileManager();
      outputFileManager.setCurrentDir(path("."));
      outputFileManager.setBinaryExtension("prg");
      outputFileManager.setPrimaryCFile(path("qwe/test.c"));
      outputFileManager.setOutputDir(path("asd"));
      outputFileManager.setAssembleOutput(true);
      outputFileManager.setOutputFileName("zxc/prod.bin");
      assertEquals(path("zxc/prod.bin"), outputFileManager.getBinaryOutputFile());
      assertEquals(path("zxc/prod.asm"), outputFileManager.getAsmOutputFile());
   }

   @Test
   /** If -o is passed and assembleout=false this overwrites the ASM file extension - output-dir / primary-file-basename . output-extension */
   void testOutputFileAsmExtension() {
      final OutputFileManager outputFileManager = new OutputFileManager();
      outputFileManager.setCurrentDir(path("."));
      outputFileManager.setBinaryExtension("prg");
      outputFileManager.setPrimaryCFile(path("qwe/test.c"));
      outputFileManager.setOutputDir(path("asd"));
      outputFileManager.setAssembleOutput(false);
      outputFileManager.setOutputFileName("zxc/prod.s");
      assertEquals(path("zxc/prod.prg"), outputFileManager.getBinaryOutputFile());
      assertEquals(path("zxc/prod.s"), outputFileManager.getAsmOutputFile());
   }


}
