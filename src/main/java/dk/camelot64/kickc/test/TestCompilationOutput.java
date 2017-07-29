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
      TestCompilationOutput tester = new TestCompilationOutput();
      tester.testFile("flipper-rex2");
   }

   public void testBresenham() throws IOException, URISyntaxException {
      TestCompilationOutput tester = new TestCompilationOutput();
      tester.testFile("bresenham");
   }

   public void testMinus() throws IOException, URISyntaxException {
      TestCompilationOutput tester = new TestCompilationOutput();
      tester.testFile("minus");
   }

   public void testLoopMin() throws IOException, URISyntaxException {
      TestCompilationOutput tester = new TestCompilationOutput();
      tester.testFile("loopmin");
   }

   public void testSumMin() throws IOException, URISyntaxException {
      TestCompilationOutput tester = new TestCompilationOutput();
      tester.testFile("summin");
   }

   public void testLoopSplit() throws IOException, URISyntaxException {
      TestCompilationOutput tester = new TestCompilationOutput();
      tester.testFile("loopsplit");
   }

   public void testLoopNest() throws IOException, URISyntaxException {
      TestCompilationOutput tester = new TestCompilationOutput();
      tester.testFile("loopnest");
   }

   public void testLoopNest2() throws IOException, URISyntaxException {
      TestCompilationOutput tester = new TestCompilationOutput();
      tester.testFile("loopnest2");
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