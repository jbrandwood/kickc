package dk.camelot64.kickc.test;

import dk.camelot64.kickc.*;
import dk.camelot64.kickc.Compiler;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.TargetPlatform;
import dk.camelot64.kickc.parser.CTargetPlatformParser;
import kickass.KickAssembler65CE02;
import kickass.nonasm.c64.CharToPetsciiConverter;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;

import java.io.*;
import java.lang.management.GarbageCollectorMXBean;
import java.lang.management.ManagementFactory;
import java.lang.management.MemoryUsage;
import java.nio.file.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Compile a number of source files and compare the resulting assembler with expected output
 */
public class TestPrograms {

   final String stdIncludePath = "src/main/kc/include";
   final String stdLibPath = "src/main/kc/lib";
   final String stdPlatformPath = "src/main/kc/target";
   final String testPath = "src/test/kc";
   final String refPath = "src/test/ref/";


   @BeforeAll
   public static void setUp() {
      TmpDirManager.init(new File("").toPath());
   }

   @AfterAll
   public static void tearDown() {
      if(TmpDirManager.MANAGER != null)
         TmpDirManager.MANAGER.cleanup();
      //AsmFragmentTemplateUsages.logUsages(log, false, false, false, false, false, false);
      //printGCStats();
   }

   public static void printGCStats() {
      long totalGarbageCollections = 0;
      long garbageCollectionTime = 0;

      for(GarbageCollectorMXBean gc :
            ManagementFactory.getGarbageCollectorMXBeans()) {

         long count = gc.getCollectionCount();

         if(count >= 0) {
            totalGarbageCollections += count;
         }

         long time = gc.getCollectionTime();

         if(time >= 0) {
            garbageCollectionTime += time;
         }
      }

      System.out.println("Total Garbage Collections: "
            + totalGarbageCollections);
      System.out.println("Total Garbage Collection Time (ms): "
            + garbageCollectionTime);

      MemoryUsage heapMemoryUsage = ManagementFactory.getMemoryMXBean().getHeapMemoryUsage();
      MemoryUsage nonHeapMemoryUsage = ManagementFactory.getMemoryMXBean().getNonHeapMemoryUsage();
      System.out.println("Heap Memory Usage: "
            + heapMemoryUsage.toString());
      System.out.println("Non-Heap Memory Usage: "
            + nonHeapMemoryUsage.toString());

   }

   protected static CompileLog log() {
      CompileLog log = new CompileLog();
      log.setSysOut(true);
      return log;
   }

   protected void assertError(String kcFile, String expectError) throws IOException {
      assertError(kcFile, expectError, true);
   }

   protected void assertError(String kcFile, String expectError, boolean expectSource) throws IOException {
      try {
         compileAndCompare(kcFile);
      } catch(CompileError e) {
         final String error = e.format();
         System.out.println("Got error: " + error);
         // expecting error!
         assertTrue(error.contains(expectError), "Error message expected  '" + expectError + "' - was:" + error);
         if(expectSource) {
            // expecting a source for the error, so it may be related back to a file/line
            assertNotNull(e.getSource(), "Error source expected");
            assertNotNull(e.getSource().getFileName(), "Error file name expected");
            assertNotNull(e.getSource().getLineNumber(), "Error line number expected");
            assertNotNull(e.getSource().getCharPosInLine(), "Error charpos expected");
         } else {
            assertTrue(e.getSource() == null || e.getSource().getFileName() == null, "No error information expected");
         }
         return;
      }
      fail("Expected compile error.");
   }

   protected void compileAndCompare(String filename) throws IOException {
      TestPrograms tester = new TestPrograms();
      tester.testFile(filename, null, null);
   }

   protected void compileAndCompare(String filename, CompileLog compileLog) throws IOException {
      TestPrograms tester = new TestPrograms();
      tester.testFile(filename, null, compileLog);
   }

   protected void compileAndCompare(String filename, int upliftCombinations) throws IOException {
      TestPrograms tester = new TestPrograms();
      tester.testFile(filename, upliftCombinations, null);
   }

   protected void compileAndCompare(String filename, int upliftCombinations, CompileLog log) throws IOException {
      TestPrograms tester = new TestPrograms();
      tester.testFile(filename, upliftCombinations, log);
   }

   private void testFile(String fileName, Integer upliftCombinations, CompileLog compileLog) throws IOException {
      System.out.println("Testing output for " + fileName);
      Compiler compiler = new Compiler();
      //compiler.enableZeroPageCoalesce();
      compiler.setWarnFragmentMissing(true);
      compiler.setAsmFragmentBaseFolder(new File("src/main/fragment/").toPath());
      if(compileLog != null) {
         compiler.setLog(compileLog);
      }
      compiler.addIncludePath(testPath);
      compiler.addIncludePath(stdIncludePath);
      compiler.addLibraryPath(stdLibPath);
      compiler.addTargetPlatformPath(stdPlatformPath);
      if(upliftCombinations != null) {
         compiler.setUpliftCombinations(upliftCombinations);
      }
      final ArrayList<Path> files = new ArrayList<>();
      final Path filePath = Paths.get(fileName);
      files.add(filePath);
      Program program = compiler.getProgram();
      // Initialize the master ASM fragment synthesizer
      program.initAsmFragmentMasterSynthesizer(true);
      final File platformFile = SourceLoader.loadFile(TargetPlatform.DEFAULT_NAME + "." + CTargetPlatformParser.FILE_EXTENSION, filePath, program.getTargetPlatformPaths());
      final TargetPlatform targetPlatform = CTargetPlatformParser.parseTargetPlatformFile(TargetPlatform.DEFAULT_NAME, platformFile, filePath, program.getTargetPlatformPaths());
      program.setTargetPlatform(targetPlatform);
      program.addReservedZps(program.getTargetPlatform().getReservedZps());

      // Update the output file manager
      program.getOutputFileManager().setBinaryExtension(program.getTargetPlatform().getOutFileExtension());
      program.getOutputFileManager().setCurrentDir(FileSystems.getDefault().getPath("."));
      program.getOutputFileManager().setPrimaryCFile(filePath);

      final Map<String, String> defines = new HashMap<>();
      defines.put("__KICKC__", "1");
      defines.putAll(program.getTargetPlatform().getDefines());
      compiler.compile(files, defines);

      compileAsm(fileName, program);
      boolean success = true;
      ReferenceHelper helper = new ReferenceHelperFolder(refPath);
      String baseFileName = FileNameUtils.removeExtension(fileName);
      success &= helper.testOutput(baseFileName, ".asm", program.getAsm().toString(new AsmProgram.AsmPrintState(false, true, false, false), program));
      success &= helper.testOutput(baseFileName, ".sym", program.getScope().toString(program, false));
      success &= helper.testOutput(baseFileName, ".cfg", program.getGraph().toString(program));
      success &= helper.testOutput(baseFileName, ".log", program.getLog().toString());
      if(!success) {
         // System.out.println("\nCOMPILE LOG");
         // System.out.println(program.getLog().toString());
         fail("Output does not match reference!");
      }
      // Save the ASM fragment caches (if there are any changes)
      compiler.getAsmFragmentMasterSynthesizer().finalize(program.getLog());
   }

   private void compileAsm(String fileName, Program program) throws IOException {
      String baseFileName = FileNameUtils.removeExtension(fileName);
      writeBinFile(baseFileName, ".asm", program.getAsm().toString(new AsmProgram.AsmPrintState(false), program));
      for(Path asmResourceFile : program.getAsmResourceFiles()) {
         File asmFile = getBinFile(baseFileName, ".asm");
         String asmFolder = asmFile.getParent();
         File resFile = new File(asmFolder, asmResourceFile.getFileName().toString());
         mkPath(resFile);
         try {
            Files.copy(asmResourceFile, resFile.toPath());
         } catch(FileAlreadyExistsException e) {
            // Ignore this
         }
      }

      File asmFile = getBinFile(baseFileName, ".asm");
      File asmPrgFile = getBinFile(baseFileName, ".prg");
      File asmLogFile = getBinFile(baseFileName, ".log");
      ByteArrayOutputStream kickAssOut = new ByteArrayOutputStream();
      System.setOut(new PrintStream(kickAssOut));
      int asmRes = -1;
      try {
         CharToPetsciiConverter.setCurrentEncoding("screencode_mixed");
         asmRes = KickAssembler65CE02.main2(new String[]{asmFile.getAbsolutePath(), "-log", asmLogFile.getAbsolutePath(), "-o", asmPrgFile.getAbsolutePath(), "-vicesymbols", "-showmem", "-bytedump"});
      } catch(Throwable e) {
         fail("KickAssembling file failed! " + e.getMessage());
      } finally {
         System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out)));
      }
      if(asmRes != 0) {
         fail("KickAssembling file failed! " + kickAssOut.toString());
      }
   }

   public File writeBinFile(String fileName, String extension, String outputString) throws IOException {
      // Write output file
      File file = getBinFile(fileName, extension);
      FileOutputStream outputStream = new FileOutputStream(file);
      OutputStreamWriter writer = new OutputStreamWriter(outputStream);
      writer.write(outputString);
      writer.close();
      outputStream.close();
      System.out.println("ASM written to " + file.getAbsolutePath());
      return file;
   }

   public File getBinFile(String fileName, String extension) {
      File binFile = new File(getBinDir(), fileName + extension);
      mkPath(binFile);
      return binFile;
   }

   /**
    * Ensures that the path to the passed file is created.
    *
    * @param file The file to create a path for
    */
   private static void mkPath(File file) {
      Path parent = file.toPath().getParent();
      File dir = parent.toFile();
      if(!dir.exists()) {
         mkPath(dir);
         dir.mkdir();
      }
   }

   public static File getBinDir() {
      Path tempDir = ReferenceHelper.getTempDir();
      File binDir = new File(tempDir.toFile(), "bin");
      if(!binDir.exists()) {
         binDir.mkdir();
      }
      return binDir;
   }

   public static File getFragmentCacheDir() {
      Path tempDir = ReferenceHelper.getTempDir();
      File binDir = new File(tempDir.toFile(), "cache");
      if(!binDir.exists()) {
         binDir.mkdir();
      }
      return binDir;
   }

}