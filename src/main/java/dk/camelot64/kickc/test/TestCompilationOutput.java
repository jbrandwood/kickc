package dk.camelot64.kickc.test;

import dk.camelot64.kickc.Compiler;
import dk.camelot64.kickc.icl.CompileError;
import dk.camelot64.kickc.icl.Program;
import junit.framework.TestCase;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;

import java.io.*;
import java.net.URISyntaxException;

/**
 * Compile a number of source files and compare the resulting assembler with expected output
 */
public class TestCompilationOutput extends TestCase {

   ReferenceHelper helper;

   String testPath;

   public TestCompilationOutput() throws IOException {
      testPath = "src/main/java/dk/camelot64/kickc/test/";
      helper = new ReferenceHelper("dk/camelot64/kickc/test/ref/");
   }

   public void testLiveRange() throws IOException, URISyntaxException {
      compileAndCompare("liverange");
   }

   public void testZpParamMin() throws IOException, URISyntaxException {
      compileAndCompare("zpparammin");
   }

   public void testInMemArray() throws IOException, URISyntaxException {
      compileAndCompare("inmemarray");
   }

   public void testVoronoi() throws IOException, URISyntaxException {
      compileAndCompare("voronoi");
   }

   public void testFlipper() throws IOException, URISyntaxException {
      compileAndCompare("flipper-rex2");
   }

   public void testBresenham() throws IOException, URISyntaxException {
      compileAndCompare("bresenham");
   }

   public void testBresenhamArr() throws IOException, URISyntaxException {
      compileAndCompare("bresenhamarr");
   }

   public void testMinus() throws IOException, URISyntaxException {
      compileAndCompare("minus");
   }

   public void testLoopMin() throws IOException, URISyntaxException {
      compileAndCompare("loopmin");
   }

   public void testSumMin() throws IOException, URISyntaxException {
      compileAndCompare("summin");
   }

   public void testLoopSplit() throws IOException, URISyntaxException {
      compileAndCompare("loopsplit");
   }

   public void testLoopNest() throws IOException, URISyntaxException {
      compileAndCompare("loopnest");
   }

   public void testLoopNest2() throws IOException, URISyntaxException {
      compileAndCompare("loopnest2");
   }

   public void testFibMem() throws IOException, URISyntaxException {
      compileAndCompare("fibmem");
   }

   public void testPtrTest() throws IOException, URISyntaxException {
      compileAndCompare("ptrtest");
   }

   public void testPtrTestMin() throws IOException, URISyntaxException {
      compileAndCompare("ptrtestmin");
   }

   public void testUseGlobal() throws IOException, URISyntaxException {
      compileAndCompare("useglobal");
   }

   public void testModGlobal() throws IOException, URISyntaxException {
      compileAndCompare("modglobal");
   }

   public void testModGlobalMin() throws IOException, URISyntaxException {
      compileAndCompare("modglobalmin");
   }

   public void testIfMin() throws IOException, URISyntaxException {
      compileAndCompare("ifmin");
   }

   public void testForClassicMin() throws IOException, URISyntaxException {
      compileAndCompare("forclassicmin");
   }

   public void testForRangeMin() throws IOException, URISyntaxException {
      compileAndCompare("forrangemin");
   }

   public void testUseUninitialized() throws IOException, URISyntaxException {
      String filename = "useuninitialized";
      compileAndCompare(filename);
   }

   public void testUseUndeclared() throws IOException, URISyntaxException {
      try {
         compileAndCompare("useundeclared");
      } catch (CompileError e) {
         // expecting error!
         return;
      }
      fail("Expected compile error.");
   }


   private void compileAndCompare(String filename) throws IOException, URISyntaxException {
      TestCompilationOutput tester = new TestCompilationOutput();
      tester.testFile(filename);
   }

   private void testFile(String fileName) throws IOException, URISyntaxException {
      String inputPath = testPath + fileName + ".kc";
      System.out.println("Testing output for " + inputPath);
      CharStream input = CharStreams.fromFileName(inputPath);
      Compiler compiler = new Compiler();
      Program program = compiler.compile(input);
      boolean success = true;
      success &= helper.testOutput(fileName, ".asm", program.getAsm().toString(false));
      success &= helper.testOutput(fileName, ".sym", program.getScope().getSymbolTableContents(program));
      success &= helper.testOutput(fileName, ".cfg", program.getGraph().toString(program));
      success &= helper.testOutput(fileName, ".log", program.getLog().toString());
      if (!success) {
         fail("Output does not match reference!");
      }
   }


}