package dk.camelot64.kickc.test;

import dk.camelot64.kickc.Compiler;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import junit.framework.TestCase;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;

import java.io.*;
import java.net.URISyntaxException;

/**
 * Compile a number of source files and compare the resulting assembler with expected output
 */
public class TestPrograms extends TestCase {

   ReferenceHelper helper;

   String testPath;

   public TestPrograms() throws IOException {
      testPath = "src/main/java/dk/camelot64/kickc/test/";
      helper = new ReferenceHelper("dk/camelot64/kickc/test/ref/");
   }

   public void testConstantAbsMin() throws IOException, URISyntaxException {
      compileAndCompare("constabsmin");
   }


   public void testBasicFloats() throws IOException, URISyntaxException {
      compileAndCompare("basic-floats");
   }

   public void testDoubleImport() throws IOException, URISyntaxException {
      compileAndCompare("double-import");
   }

   public void testImporting() throws IOException, URISyntaxException {
      compileAndCompare("importing");
   }

   public void testUnusedVars() throws IOException, URISyntaxException {
      compileAndCompare("unused-vars");
   }

   public void testFillscreen() throws IOException, URISyntaxException {
      compileAndCompare("fillscreen");
   }

   public void testLiverangeCallProblem() throws IOException, URISyntaxException {
      compileAndCompare("liverange-call-problem");
   }

   public void testPrintProblem() throws IOException, URISyntaxException {
      compileAndCompare("print-problem");
   }

   public void testPrint() throws IOException, URISyntaxException {
      compileAndCompare("print");
   }

   public void testUnusedMethod() throws IOException, URISyntaxException {
      compileAndCompare("unused-method");
   }

   public void testInlineString() throws IOException, URISyntaxException {
      compileAndCompare("inline-string");
   }

   public void testLocalString() throws IOException, URISyntaxException {
      compileAndCompare("local-string");
   }

   public void testInlineArrayProblem() throws IOException, URISyntaxException {
      String filename = "inlinearrayproblem";
      compileAndCompare(filename);
   }

   public void testImmZero() throws IOException, URISyntaxException {
      compileAndCompare("immzero");
   }

   public void testWordExpr() throws IOException, URISyntaxException {
      compileAndCompare("wordexpr");
   }

   public void testZpptr() throws IOException, URISyntaxException {
      compileAndCompare("zpptr");
   }

   public void testCasting() throws IOException, URISyntaxException {
      compileAndCompare("casting");
   }

   public void testSignedBytes() throws IOException, URISyntaxException {
      compileAndCompare("signed-bytes");
   }

   public void testScrollBig() throws IOException, URISyntaxException {
      compileAndCompare("scrollbig");
   }

   public void testPtrComplex() throws IOException, URISyntaxException {
      compileAndCompare("ptr-complex");
   }

   public void testIncD020() throws IOException, URISyntaxException {
      compileAndCompare("incd020");
   }

   public void testOverlapAllocation2() throws IOException, URISyntaxException {
      compileAndCompare("overlap-allocation-2");
   }

   public void testOverlapAllocation() throws IOException, URISyntaxException {
      compileAndCompare("overlap-allocation");
   }

   public void testBitmapBresenham() throws IOException, URISyntaxException {
      compileAndCompare("bitmap-bresenham");
   }

   public void testAsmClobber() throws IOException, URISyntaxException {
      compileAndCompare("asm-clobber");
   }

   public void testInlineAsm() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm");
   }

   public void testChargen() throws IOException, URISyntaxException {
      compileAndCompare("chargen");
   }

   public void testBitmapPlotter() throws IOException, URISyntaxException {
      compileAndCompare("bitmap-plotter");
   }

   public void testConstIdentification() throws IOException, URISyntaxException {
      compileAndCompare("const-identification");
   }

   public void testCallConstParam() throws IOException, URISyntaxException {
      compileAndCompare("callconstparam");
   }

   public void testScrollClobber() throws IOException, URISyntaxException {
      compileAndCompare("scroll-clobber");
   }

   public void testHalfscii() throws IOException, URISyntaxException {
      compileAndCompare("halfscii");
   }

   public void testLiterals() throws IOException, URISyntaxException {
      compileAndCompare("literals");
   }

   public void testScroll() throws IOException, URISyntaxException {
      compileAndCompare("scroll");
   }

   public void testConstantMin() throws IOException, URISyntaxException {
      compileAndCompare("constantmin");
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

   public void testInMemString() throws IOException, URISyntaxException {
      compileAndCompare("inmemstring");
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

   public void testIterArray() throws IOException, URISyntaxException {
      compileAndCompare("iterarray");
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

   public void testStmtOutsideMethod() throws IOException, URISyntaxException {
      try {
         compileAndCompare("stmt-outside-method");
      } catch (CompileError e) {
         // expecting error!
         return;
      }
      fail("Expected compile error.");
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

   public void testTypeMismatch() throws IOException, URISyntaxException {
      try {
         compileAndCompare("typemismatch");
      } catch (CompileError e) {
         // expecting error!
         return;
      }
      fail("Expected compile error.");
   }


   private void compileAndCompare(String filename) throws IOException, URISyntaxException {
      TestPrograms tester = new TestPrograms();
      tester.testFile(filename);
   }

   private void testFile(String fileName) throws IOException, URISyntaxException {
      System.out.println("Testing output for " + fileName);
      Compiler compiler = new Compiler();
      compiler.addImportPath(testPath);
      Program program = compiler.compile(fileName);
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