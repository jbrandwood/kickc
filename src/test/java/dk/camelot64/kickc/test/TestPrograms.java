package dk.camelot64.kickc.test;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.Compiler;
import dk.camelot64.kickc.fragment.AsmFragmentTemplateSynthesizer;
import dk.camelot64.kickc.fragment.AsmFragmentTemplateUsages;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import kickass.KickAssembler;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.*;
import java.net.URISyntaxException;
import java.nio.file.FileAlreadyExistsException;
import java.nio.file.Files;
import java.nio.file.Path;

import static junit.framework.TestCase.fail;
import static org.junit.Assert.assertTrue;

/**
 * Compile a number of source files and compare the resulting assembler with expected output
 */
public class TestPrograms {

   ReferenceHelper helper;

   String testPath;

   public TestPrograms() throws IOException {
      testPath = "src/test/java/dk/camelot64/kickc/test/kc";
      helper = new ReferenceHelper("dk/camelot64/kickc/test/ref/");
   }

   @BeforeClass
   public static void setUp() {
      AsmFragmentTemplateSynthesizer.clearCaches();
   }

   @AfterClass
   public static void tearDown() throws Exception {
      CompileLog log = new CompileLog();
      log.setSysOut(true);
      AsmFragmentTemplateUsages.logUsages(log, false, false, false, false, false, false);
   }

   @Test
   public void testForRangedWords() throws IOException, URISyntaxException {
      compileAndCompare("forrangedwords");
   }

   @Test
   public void testArrayLengthSymbolic() throws IOException, URISyntaxException {
      compileAndCompare("array-length-symbolic");
   }

   @Test
   public void testForRangeSymbolic() throws IOException, URISyntaxException {
      compileAndCompare("forrangesymbolic");
   }

   @Test
   public void testSinePlotter() throws IOException, URISyntaxException {
      compileAndCompare("sine-plotter");
   }

   @Test
   public void testScrollLogo() throws IOException, URISyntaxException {
      compileAndCompare("scrolllogo");
   }

   @Test
   public void testShowLogo() throws IOException, URISyntaxException {
      compileAndCompare("showlogo");
   }

   @Test
   public void testKasm() throws IOException, URISyntaxException {
      compileAndCompare("test-kasm");
   }

   @Test
   public void testLineAnim() throws IOException, URISyntaxException {
      compileAndCompare("line-anim");
   }

   @Test
   public void testInlineFunctionLevel2() throws IOException, URISyntaxException {
      compileAndCompare("inline-function-level2");
   }

   @Test
   public void testInlineFunctionPrint() throws IOException, URISyntaxException {
      compileAndCompare("inline-function-print");
   }

   @Test
   public void testInlineFunctionIf() throws IOException, URISyntaxException {
      compileAndCompare("inline-function-if");
   }

   @Test
   public void testInlineFunction() throws IOException, URISyntaxException {
      compileAndCompare("inline-function");
   }

   @Test
   public void testInlineFunctionMin() throws IOException, URISyntaxException {
      compileAndCompare("inline-function-min");
   }

   @Test
   public void testCompoundAssignment() throws IOException, URISyntaxException {
      compileAndCompare("compound-assignment");
   }

   @Test
   public void testChainedAssignment() throws IOException, URISyntaxException {
      compileAndCompare("chained-assignment");
   }

   @Test
   public void testConcatChar() throws IOException, URISyntaxException {
      compileAndCompare("concat-char");
   }

   @Test
   public void testConstMultDiv() throws IOException, URISyntaxException {
      compileAndCompare("const-mult-div");
   }

   @Test
   public void testDoubleAssignment() throws IOException, URISyntaxException {
      compileAndCompare("double-assignment");
   }

   @Test
   public void testConstWordPointer() throws IOException, URISyntaxException {
      compileAndCompare("const-word-pointer");
   }

   @Test
   public void testConstParam() throws IOException, URISyntaxException {
      compileAndCompare("const-param");
   }

   @Test
   public void testHelloWorld() throws IOException, URISyntaxException {
      compileAndCompare("helloworld");
   }

   @Test
   public void testHelloWorld2() throws IOException, URISyntaxException {
      compileAndCompare("helloworld2");
   }

   @Test
   public void testChessboard() throws IOException, URISyntaxException {
      compileAndCompare("chessboard");
   }

   @Test
   public void testFragmentSynth() throws IOException, URISyntaxException {
      compileAndCompare("fragment-synth");
   }

   @Test
   public void testConstPointer() throws IOException, URISyntaxException {
      compileAndCompare("const-pointer");
   }

   @Test
   public void testVarForwardProblem() throws IOException, URISyntaxException {
         compileAndCompare("var-forward-problem");
   }

   @Test
   public void testInlineString3() throws IOException, URISyntaxException {
      compileAndCompare("inline-string-3");
   }

   @Test
   public void testEmptyBlockError() throws IOException, URISyntaxException {
      compileAndCompare("emptyblock-error");
   }

   @Test
   public void testConstCondition() throws IOException, URISyntaxException {
      compileAndCompare("const-condition");
   }

   @Test
   public void testBoolConst() throws IOException, URISyntaxException {
      compileAndCompare("bool-const");
   }

   @Test
   public void testBoolIfs() throws IOException, URISyntaxException {
      compileAndCompare("bool-ifs");
   }

   @Test
   public void testBoolVars() throws IOException, URISyntaxException {
      compileAndCompare("bool-vars");
   }

   @Test
   public void testBoolFunction() throws IOException, URISyntaxException {
      compileAndCompare("bool-function");
   }

   @Test
   public void testBoolPointer() throws IOException, URISyntaxException {
      compileAndCompare("bool-pointer");
   }

   @Test
   public void testC64DtvBlitterMin() throws IOException, URISyntaxException {
      compileAndCompare("c64dtv-blittermin");
   }

   @Test
   public void testC64Dtv8bppChunkyStretch() throws IOException, URISyntaxException {
      compileAndCompare("c64dtv-8bppchunkystretch");
   }

   @Test
   public void testC64Dtv8bppCharStretch() throws IOException, URISyntaxException {
      compileAndCompare("c64dtv-8bppcharstretch");
   }

   @Test
   public void testC64DtvGfxExplorer() throws IOException, URISyntaxException {
      compileAndCompare("c64dtv-gfxexplorer");
   }

   @Test
   public void testInlineString2() throws IOException, URISyntaxException {
      compileAndCompare("inline-string-2");
   }

   @Test
   public void testLoopProblem2() throws IOException, URISyntaxException {
      compileAndCompare("loop-problem2");
   }

   @Test
   public void testOperatorLoHiProblem() throws IOException, URISyntaxException {
      compileAndCompare("operator-lohi-problem");
   }

   @Test
   public void testKeyboardGlitch() throws IOException, URISyntaxException {
      compileAndCompare("keyboard-glitch");
   }

   @Test
   public void testC64DtvGfxModes() throws IOException, URISyntaxException {
      compileAndCompare("c64dtv-gfxmodes");
   }

   @Test
   public void testNoromCharset() throws IOException, URISyntaxException {
      compileAndCompare("norom-charset");
   }

   @Test
   public void testChargenAnalysis() throws IOException, URISyntaxException {
      compileAndCompare("chargen-analysis");
   }

   @Test
   public void testKeyboardSpace() throws IOException, URISyntaxException {
      compileAndCompare("test-keyboard-space");
   }

   @Test
   public void testKeyboard() throws IOException, URISyntaxException {
      compileAndCompare("test-keyboard");
   }

   @Test
   public void testC64DtvColor() throws IOException, URISyntaxException {
      compileAndCompare("c64dtv-color");
   }

   @Test
   public void testCastPrecedenceProblem() throws IOException, URISyntaxException {
      compileAndCompare("cast-precedence-problem");
   }

   @Test
   public void testLoopProblem() throws IOException, URISyntaxException {
      compileAndCompare("loop-problem");
   }

   @Test
   public void testLoHiConst() throws IOException, URISyntaxException {
      compileAndCompare("test-lohiconst");
   }

   @Test
   public void testSinusGen16() throws IOException, URISyntaxException {
      compileAndCompare("sinusgen16");
   }

   @Test
   public void testSinusGen16b() throws IOException, URISyntaxException {
      compileAndCompare("sinusgen16b");
   }

   @Test
   public void testSinusGenScale8() throws IOException, URISyntaxException {
      compileAndCompare("sinusgenscale8");
   }

   @Test
   public void testSinusGen8() throws IOException, URISyntaxException {
      compileAndCompare("sinusgen8");
   }

   @Test
   public void testSinusGen8b() throws IOException, URISyntaxException {
      compileAndCompare("sinusgen8b");
   }

   @Test
   public void testLineGen() throws IOException, URISyntaxException {
      compileAndCompare("linegen");
   }

   @Test
   public void testLowHigh() throws IOException, URISyntaxException {
      compileAndCompare("test-lowhigh");
   }

   @Test
   public void testLongJump2() throws IOException, URISyntaxException {
      compileAndCompare("longjump2");
   }

   @Test
   public void testLongJump() throws IOException, URISyntaxException {
      compileAndCompare("longjump");
   }

   @Test
   public void testAddressOfParam() throws IOException, URISyntaxException {
      compileAndCompare("test-address-of-param");
   }

   @Test
   public void testAddressOf() throws IOException, URISyntaxException {
      compileAndCompare("test-address-of");
   }

   @Test
   public void testDivision() throws IOException, URISyntaxException {
      compileAndCompare("test-division");
   }

   @Test
   public void testVarRegister() throws IOException, URISyntaxException {
      compileAndCompare("var-register");
   }

   @Test
   public void testDword() throws IOException, URISyntaxException {
      compileAndCompare("dword");
   }

   @Test
   public void testCastDeref() throws IOException, URISyntaxException {
      compileAndCompare("cast-deref");
   }

   @Test
   public void testRasterBars() throws IOException, URISyntaxException {
      compileAndCompare("raster-bars");
   }

   @Test
   public void testComparisons() throws IOException, URISyntaxException {
      compileAndCompare("test-comparisons");
   }

   @Test
   public void testMemAlignment() throws IOException, URISyntaxException {
      compileAndCompare("mem-alignment");
   }

   @Test
   public void testMultiply8Bit() throws IOException, URISyntaxException {
      compileAndCompare("test-multiply-8bit");
   }

   @Test
   public void testMultiply16Bit() throws IOException, URISyntaxException {
      compileAndCompare("test-multiply-16bit");
   }

   @Test
   public void testArraysInit() throws IOException, URISyntaxException {
      compileAndCompare("arrays-init");
   }

   @Test
   public void testConstantStringConcat() throws IOException, URISyntaxException {
      compileAndCompare("constant-string-concat");
   }

   @Test
   public void testTrueInlineWords() throws IOException, URISyntaxException {
      compileAndCompare("true-inline-words");
   }

   @Test
   public void testIncrementInArray() throws IOException, URISyntaxException {
      compileAndCompare("incrementinarray");
   }

   @Test
   public void testForIncrementAssign() throws IOException, URISyntaxException {
      compileAndCompare("forincrementassign");
   }

   @Test
   public void testConstants() throws IOException, URISyntaxException {
      compileAndCompare("constants");
   }

   @Test
   public void testInlineAssignment() throws IOException, URISyntaxException {
      compileAndCompare("inline-assignment");
   }

   @Test
   public void testInlineWord() throws IOException, URISyntaxException {
      compileAndCompare("inline-word");
   }

   @Test
   public void testSignedWords() throws IOException, URISyntaxException {
      compileAndCompare("signed-words");
   }

   @Test
   public void testSinusSprites() throws IOException, URISyntaxException {
      compileAndCompare("sinus-sprites");
   }

   @Test
   public void testConstantAbsMin() throws IOException, URISyntaxException {
      compileAndCompare("constabsmin");
   }

   @Test
   public void testBasicFloats() throws IOException, URISyntaxException {
      compileAndCompare("sinus-basic");
   }

   @Test
   public void testDoubleImport() throws IOException, URISyntaxException {
      compileAndCompare("double-import");
   }

   @Test
   public void testImporting() throws IOException, URISyntaxException {
      compileAndCompare("importing");
   }

   @Test
   public void testUnusedVars() throws IOException, URISyntaxException {
      compileAndCompare("unused-vars");
   }

   @Test
   public void testFillscreen() throws IOException, URISyntaxException {
      compileAndCompare("fillscreen");
   }

   @Test
   public void testLiverangeCallProblem() throws IOException, URISyntaxException {
      compileAndCompare("liverange-call-problem");
   }

   @Test
   public void testPrintProblem() throws IOException, URISyntaxException {
      compileAndCompare("print-problem");
   }

   @Test
   public void testPrintMsg() throws IOException, URISyntaxException {
      compileAndCompare("printmsg");
   }

   @Test
   public void testUnusedMethod() throws IOException, URISyntaxException {
      compileAndCompare("unused-method");
   }

   @Test
   public void testInlineString() throws IOException, URISyntaxException {
      compileAndCompare("inline-string");
   }

   @Test
   public void testLocalString() throws IOException, URISyntaxException {
      compileAndCompare("local-string");
   }

   @Test
   public void testInlineArrayProblem() throws IOException, URISyntaxException {
      compileAndCompare("inlinearrayproblem");
   }

   @Test
   public void testImmZero() throws IOException, URISyntaxException {
      compileAndCompare("immzero");
   }

   @Test
   public void testWordExpr() throws IOException, URISyntaxException {
      compileAndCompare("wordexpr");
   }

   @Test
   public void testZpptr() throws IOException, URISyntaxException {
      compileAndCompare("zpptr");
   }

   @Test
   public void testCasting() throws IOException, URISyntaxException {
      compileAndCompare("casting");
   }

   @Test
   public void testSignedBytes() throws IOException, URISyntaxException {
      compileAndCompare("signed-bytes");
   }

   @Test
   public void testScrollBig() throws IOException, URISyntaxException {
      compileAndCompare("scrollbig");
   }

   @Test
   public void testPtrComplex() throws IOException, URISyntaxException {
      compileAndCompare("ptr-complex");
   }

   @Test
   public void testIncD020() throws IOException, URISyntaxException {
      compileAndCompare("incd020");
   }

   @Test
   public void testOverlapAllocation2() throws IOException, URISyntaxException {
      compileAndCompare("overlap-allocation-2");
   }

   @Test
   public void testOverlapAllocation() throws IOException, URISyntaxException {
      compileAndCompare("overlap-allocation");
   }

   @Test
   public void testBitmapBresenham() throws IOException, URISyntaxException {
      compileAndCompare("bitmap-bresenham");
   }

   @Test
   public void testAsmClobber() throws IOException, URISyntaxException {
      compileAndCompare("asm-clobber");
   }

   @Test
   public void testInlineAsm() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm");
   }

   @Test
   public void testChargen() throws IOException, URISyntaxException {
      compileAndCompare("chargen");
   }

   @Test
   public void testBitmapPlotter() throws IOException, URISyntaxException {
      compileAndCompare("bitmap-plotter");
   }

   @Test
   public void testConstIdentification() throws IOException, URISyntaxException {
      compileAndCompare("const-identification");
   }

   @Test
   public void testCallConstParam() throws IOException, URISyntaxException {
      compileAndCompare("callconstparam");
   }

   @Test
   public void testScrollClobber() throws IOException, URISyntaxException {
      compileAndCompare("scroll-clobber");
   }

   @Test
   public void testHalfscii() throws IOException, URISyntaxException {
      compileAndCompare("halfscii");
   }

   @Test
   public void testLiterals() throws IOException, URISyntaxException {
      compileAndCompare("literals");
   }

   @Test
   public void testScroll() throws IOException, URISyntaxException {
      compileAndCompare("scroll");
   }

   @Test
   public void testConstantMin() throws IOException, URISyntaxException {
      compileAndCompare("constantmin");
   }

   @Test
   public void testLiveRange() throws IOException, URISyntaxException {
      compileAndCompare("liverange");
   }

   @Test
   public void testZpParamMin() throws IOException, URISyntaxException {
      compileAndCompare("zpparammin");
   }

   @Test
   public void testInMemArray() throws IOException, URISyntaxException {
      compileAndCompare("inmemarray");
   }

   @Test
   public void testInMemConstArray() throws IOException, URISyntaxException {
      compileAndCompare("inmem-const-array");
   }

   @Test
   public void testInMemString() throws IOException, URISyntaxException {
      compileAndCompare("inmemstring");
   }

   @Test
   public void testVoronoi() throws IOException, URISyntaxException {
      compileAndCompare("voronoi");
   }

   @Test
   public void testFlipper() throws IOException, URISyntaxException {
      compileAndCompare("flipper-rex2");
   }

   @Test
   public void testBresenham() throws IOException, URISyntaxException {
      compileAndCompare("bresenham");
   }

   @Test
   public void testBresenhamArr() throws IOException, URISyntaxException {
      compileAndCompare("bresenhamarr");
   }

   @Test
   public void testIterArray() throws IOException, URISyntaxException {
      compileAndCompare("iterarray");
   }

   @Test
   public void testLoopMin() throws IOException, URISyntaxException {
      compileAndCompare("loopmin");
   }

   @Test
   public void testSumMin() throws IOException, URISyntaxException {
      compileAndCompare("summin");
   }

   @Test
   public void testLoopSplit() throws IOException, URISyntaxException {
      compileAndCompare("loopsplit");
   }

   @Test
   public void testLoopNest() throws IOException, URISyntaxException {
      compileAndCompare("loopnest");
   }

   @Test
   public void testLoopNest2() throws IOException, URISyntaxException {
      compileAndCompare("loopnest2");
   }

   @Test
   public void testLoopNest3() throws IOException, URISyntaxException {
      compileAndCompare("loopnest3");
   }

   @Test
   public void testFibMem() throws IOException, URISyntaxException {
      compileAndCompare("fibmem");
   }

   @Test
   public void testPtrTest() throws IOException, URISyntaxException {
      compileAndCompare("ptrtest");
   }

   @Test
   public void testPtrTestMin() throws IOException, URISyntaxException {
      compileAndCompare("ptrtestmin");
   }

   @Test
   public void testUseGlobal() throws IOException, URISyntaxException {
      compileAndCompare("useglobal");
   }

   @Test
   public void testModGlobal() throws IOException, URISyntaxException {
      compileAndCompare("modglobal");
   }

   @Test
   public void testModGlobalMin() throws IOException, URISyntaxException {
      compileAndCompare("modglobalmin");
   }

   @Test
   public void testIfMin() throws IOException, URISyntaxException {
      compileAndCompare("ifmin");
   }

   @Test
   public void testForClassicMin() throws IOException, URISyntaxException {
      compileAndCompare("forclassicmin");
   }

   @Test
   public void testForRangeMin() throws IOException, URISyntaxException {
      compileAndCompare("forrangemin");
   }

   @Test
   public void testAssignConst() throws IOException, URISyntaxException {
      assertError("assign-const", "Constants can not be modified");
   }

   @Test
   public void testStmtOutsideMethod() throws IOException, URISyntaxException {
      assertError("stmt-outside-method", "Error parsing");
   }

   @Test
   public void testUseUndeclared() throws IOException, URISyntaxException {
      assertError("useundeclared", "Unknown variable");
   }

   @Test
   public void testUseUninitialized() throws IOException, URISyntaxException {
      assertError("useuninitialized", "Variable used before being defined");
   }

   @Test
   public void testUseUninitialized2() throws IOException, URISyntaxException {
      assertError("useuninitialized2", "Variable used before being defined");
   }

   @Test
   public void testTypeMismatch() throws IOException, URISyntaxException {
      assertError("typemismatch", "Type mismatch");
   }

   @Test
   public void testToManyParams() throws IOException, URISyntaxException {
      assertError("tomanyparams", "Wrong number of parameters in call");
   }

   @Test
   public void testToFewParams() throws IOException, URISyntaxException {
      assertError("tofewparams", "Wrong number of parameters in call");
   }

   @Test
   public void testNoReturn() throws IOException, URISyntaxException {
      assertError("noreturn", "Method must end with a return statement");
   }

   @Test
   public void testProcedureNotFound() throws IOException, URISyntaxException {
      assertError("procedurenotfound", "Called procedure not found");
   }

   @Test
   public void testIllegalLValue() throws IOException, URISyntaxException {
      assertError("illegallvalue", "LValue is illegal");
   }

   @Test
   public void testInvalidConstType() throws IOException, URISyntaxException {
      assertError("invalid-consttype", "Constant variable has a non-matching type");
   }

   @Test
   public void testValueListError() throws IOException, URISyntaxException {
      assertError("valuelist-error", "Value list not resolved to word constructor");
   }

   @Test
   public void testArrayUninitialized() throws IOException, URISyntaxException {
      assertError("array-uninitialized", "Array has no declared size.");
   }

   @Test
   public void testArrayLengthMismatch() throws IOException, URISyntaxException {
      assertError("array-length-mismatch", "Array length mismatch");
   }

   @Test
   public void testStringLengthMismatch() throws IOException, URISyntaxException {
      assertError("string-length-mismatch", "Array length mismatch");
   }

   @Test
   public void testIllegalAlignment() throws IOException, URISyntaxException {
      assertError("illegal-alignment", "Cannot align variable");
   }

   @Test
   public void testRegisterClobber() throws IOException, URISyntaxException {
      assertError("register-clobber", "CLOBBER ERROR");
   }

   @Test
   public void testRecursionError() throws IOException, URISyntaxException {
      assertError("recursion-error", "Recursion");
   }

   @Test
   public void testRecursionComplexError() throws IOException, URISyntaxException {
      assertError("recursion-error-complex", "Recursion");
   }

   @Test
   public void testConstPointerModifyError() throws IOException, URISyntaxException {
      assertError("const-pointer-modify", "Constants can not be modified");
   }

   @Test
   public void testNoMulRuntime() throws IOException, URISyntaxException {
      assertError("no-mul-runtime", "Runtime multiplication not supported");
   }

   @Test
   public void testNoDivRuntime() throws IOException, URISyntaxException {
      assertError("no-div-runtime", "Runtime division not supported");
   }

   @Test
   public void testNoModRuntime() throws IOException, URISyntaxException {
      assertError("no-mod-runtime", "Runtime modulo not supported");
   }


   private void assertError(String kcFile, String expectError) throws IOException, URISyntaxException {
      try {
         compileAndCompare(kcFile);
      } catch(CompileError e) {
         System.out.println("Got error: " + e.getMessage());
         // expecting error!
         assertTrue("Error message expected  '" + expectError + "' - was:" + e.getMessage(), e.getMessage().contains(expectError));
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

      compileAsm(fileName, program);

      boolean success = true;
      success &= helper.testOutput(fileName, ".asm", program.getAsm().toString(false));
      success &= helper.testOutput(fileName, ".sym", program.getScope().getSymbolTableContents(program));
      success &= helper.testOutput(fileName, ".cfg", program.getGraph().toString(program));
      success &= helper.testOutput(fileName, ".log", program.getLog().toString());
      if(!success) {
         //System.out.println("\nCOMPILE LOG");
         //System.out.println(program.getLog().toString());
         fail("Output does not match reference!");
      }
   }

   private void compileAsm(String fileName, Program program) throws IOException {
      writeBinFile(fileName, ".asm", program.getAsm().toString(false));
      for(Path asmResourceFile : program.getAsmResourceFiles()) {
         File binFile = getBinFile(asmResourceFile.getFileName().toString());
         try {
            Files.copy(asmResourceFile, binFile.toPath());
         } catch(FileAlreadyExistsException e) {
            // Ignore this
         }
      }

      File asmFile = getBinFile(fileName, ".asm");
      File asmPrgFile = getBinFile(fileName, ".prg");
      File asmLogFile = getBinFile(fileName, ".log");
      ByteArrayOutputStream kickAssOut = new ByteArrayOutputStream();
      System.setOut(new PrintStream(kickAssOut));
      int asmRes = KickAssembler.main2(new String[]{asmFile.getAbsolutePath(), "-log", asmLogFile.getAbsolutePath(), "-o", asmPrgFile.getAbsolutePath(), "-vicesymbols", "-showmem"});
      System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out)));
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
      return new File(getBinDir(), fileName + extension);
   }

   public File getBinFile(String fileName) {
      return new File(getBinDir(), fileName);
   }

   public File getBinDir() {
      Path tempDir = helper.getTempDir();
      File binDir = new File(tempDir.toFile(), "bin");
      if(!binDir.exists()) {
         binDir.mkdir();

      }
      return binDir;
   }


}