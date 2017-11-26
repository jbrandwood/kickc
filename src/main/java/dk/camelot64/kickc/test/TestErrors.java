package dk.camelot64.kickc.test;

import dk.camelot64.kickc.Compiler;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import junit.framework.TestCase;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;

import java.io.IOException;
import java.net.URISyntaxException;

/**
 * Some failing tests highlighting errors/problems in KickC
 */
public class TestErrors extends TestCase {

   ReferenceHelper helper;

   String testPath;

   public TestErrors() throws IOException {
      testPath = "src/main/java/dk/camelot64/kickc/test/";
      helper = new ReferenceHelper("dk/camelot64/kickc/test/ref/");
   }

   public void testLocalString() throws IOException, URISyntaxException {
      compileAndCompare("local-string");
   }

   public void testInlineString() throws IOException, URISyntaxException {
      compileAndCompare("inline-string");
   }

   public void testPrint() throws IOException, URISyntaxException {
      compileAndCompare("print");
   }

   public void testConstants() throws IOException, URISyntaxException {
      compileAndCompare("constants");
   }

   public void testInlineAsmParam() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-param");
   }

   public void testUseUninitialized() throws IOException, URISyntaxException {
      String filename = "useuninitialized";
      compileAndCompare(filename);
   }

   public void testForRangeSymbolic() throws IOException, URISyntaxException {
      String filename = "forrangesymbolic";
      compileAndCompare(filename);
   }

   public void testInlineArrayProblem() throws IOException, URISyntaxException {
      String filename = "inlinearrayproblem";
      compileAndCompare(filename);
   }

   public void testForIncrementAssign() throws IOException, URISyntaxException {
      String filename = "forincrementassign";
      compileAndCompare(filename);
   }

   private void compileAndCompare(String filename) throws IOException, URISyntaxException {
      TestErrors tester = new TestErrors();
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