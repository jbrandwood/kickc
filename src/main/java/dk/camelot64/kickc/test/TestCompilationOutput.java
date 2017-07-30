package dk.camelot64.kickc.test;

import dk.camelot64.kickc.Compiler;
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

   public void testFlipper() throws IOException, URISyntaxException {
      compileAndCompare("flipper-rex2");
   }

   public void testBresenham() throws IOException, URISyntaxException {
      compileAndCompare("bresenham");
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

   public void testUseGlobal() throws IOException, URISyntaxException {
      compileAndCompare("useglobal");
   }

   public void testUseUninitialized() throws IOException, URISyntaxException {
      String filename = "useuninitialized";
      compileAndCompare(filename);
   }

   public void testUseUndeclared() throws IOException, URISyntaxException {
      compileAndCompare("useundeclared");
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
      Compiler.CompilationResult output = compiler.compile(input);
      boolean success = true;
      success &= helper.testOutput(fileName, ".asm", output.getAsmProgram().toString(false));
      success &= helper.testOutput(fileName, ".sym", output.getScope().getSymbolTableContents());
      success &= helper.testOutput(fileName, ".cfg", output.getGraph().toString(output.getScope()));
      success &= helper.testOutput(fileName, ".log", output.getLog().toString());
      if (!success) {
         fail("Output does not match reference!");
      }
   }


}