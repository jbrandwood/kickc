package dk.camelot64.kickc.test;

import dk.camelot64.kickc.Compiler;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import junit.framework.TestCase;

import java.io.IOException;
import java.net.URISyntaxException;

/**
 * Compile a number of source files and compare the resulting assembler with expected output
 */
public class TestPrograms extends TestCase {

   ReferenceHelper helper;

   String testPath;

   public TestPrograms() throws IOException {
      testPath = "src/test/java/dk/camelot64/kickc/test/";
      helper = new ReferenceHelper("dk/camelot64/kickc/test/ref/");
   }

   public void testMemAlignment() throws IOException, URISyntaxException {
      compileAndCompare("mem-alignment");
   }

   public void testMultiply() throws IOException, URISyntaxException {
      compileAndCompare("test-multiply");
   }

   public void testArraysInit() throws IOException, URISyntaxException {
      compileAndCompare("arrays-init");
   }

   public void testConstantStringConcat() throws IOException, URISyntaxException {
      compileAndCompare("constant-string-concat");
   }

   public void testTrueInlineWords() throws IOException, URISyntaxException {
      compileAndCompare("true-inline-words");
   }

   public void testIncrementInArray() throws IOException, URISyntaxException {
      compileAndCompare("incrementinarray");
   }

   public void testForIncrementAssign() throws IOException, URISyntaxException {
      compileAndCompare("forincrementassign");
   }

   public void testConstants() throws IOException, URISyntaxException {
      compileAndCompare("constants");
   }

   public void testInlineAssignment() throws IOException, URISyntaxException {
      compileAndCompare("inline-assignment");
   }

   public void testInlineWord() throws IOException, URISyntaxException {
      compileAndCompare("inline-word");
   }

   public void testSignedWords() throws IOException, URISyntaxException {
      compileAndCompare("signed-words");
   }

   public void testSinusSprites() throws IOException, URISyntaxException {
      compileAndCompare("sinus-sprites");
   }

   public void testConstantAbsMin() throws IOException, URISyntaxException {
      compileAndCompare("constabsmin");
   }

   public void testBasicFloats() throws IOException, URISyntaxException {
      compileAndCompare("sinus-basic");
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

   public void testPrintMsg() throws IOException, URISyntaxException {
      compileAndCompare("printmsg");
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

   public void testInMemConstArray() throws IOException, URISyntaxException {
      compileAndCompare("inmem-const-array");
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

   public void testAssignConst() throws IOException, URISyntaxException {
      assertError("assign-const", "Constants can not be modified");
   }

   public void testStmtOutsideMethod() throws IOException, URISyntaxException {
      assertError("stmt-outside-method", "Error parsing");
   }

   public void testUseUndeclared() throws IOException, URISyntaxException {
      assertError("useundeclared", "Unknown variable");
   }

   public void testUseUninitialized() throws IOException, URISyntaxException {
      assertError("useuninitialized", "Variable used before being defined");
   }

   public void testTypeMismatch() throws IOException, URISyntaxException {
      assertError("typemismatch", "Type mismatch");
   }

   public void testToManyParams() throws IOException, URISyntaxException {
      assertError("tomanyparams", "Wrong number of parameters in call");
   }

   public void testToFewParams() throws IOException, URISyntaxException {
      assertError("tofewparams", "Wrong number of parameters in call");
   }

   public void testNoReturn() throws IOException, URISyntaxException {
      assertError("noreturn", "Method must end with a return statement");
   }

   public void testProcedureNotFound() throws IOException, URISyntaxException {
      assertError("procedurenotfound", "Called procedure not found");
   }

   public void testIllegalLValue() throws IOException, URISyntaxException {
      assertError("illegallvalue", "LValue is illegal");
   }

   public void testInvalidConstType() throws IOException, URISyntaxException {
      assertError("invalid-consttype", "Constant variable has a non-matching type");
   }

   public void testValueListError() throws IOException, URISyntaxException {
      assertError("valuelist-error", "Value list not resolved to word constructor");
   }

   public void testArrayUninitialized() throws IOException, URISyntaxException {
      assertError("array-uninitialized", "Cannot determine array size.");
   }

   public void testArrayLengthMismatch() throws IOException, URISyntaxException {
      assertError("array-length-mismatch", "Array length mismatch");
   }

   public void testStringLengthMismatch() throws IOException, URISyntaxException {
      assertError("string-length-mismatch", "Array length mismatch");
   }

   public void testIllegalAlignment() throws IOException, URISyntaxException {
      assertError("illegal-alignment", "Cannot align variable");
   }

   private void assertError(String kcFile, String expectError) throws IOException, URISyntaxException {
      try {
         compileAndCompare(kcFile);
      } catch (CompileError e) {
         System.out.println("Got error: "+e.getMessage());
         // expecting error!
         assertTrue("Error message expected  '"+expectError+"' - was:"+e.getMessage(), e.getMessage().contains(expectError));
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
         //System.out.println("\nCOMPILE LOG");
         //System.out.println(program.getLog().toString());
         fail("Output does not match reference!");
      }
   }


}