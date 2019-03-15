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

   final String stdlibPath = "src/main/kc/stdlib";
   final String testPath = "src/test/kc";
   final String refPath = "src/test/ref/";

   public TestPrograms() {
   }

   @BeforeClass
   public static void setUp() {
      AsmFragmentTemplateSynthesizer.initialize("src/main/fragment/");
   }

   @AfterClass
   public static void tearDown() {
      CompileLog log = new CompileLog();
      log.setSysOut(true);
      AsmFragmentTemplateUsages.logUsages(log, false, false, false, false, false, false);
   }

   @Test
   public void testInlineAsmRefScoped() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-ref-scoped");
   }

   @Test
   public void testInlineAsmRefoutLabel() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-label");
   }

   @Test
   public void testInlineAsmRefoutIllegal() throws IOException, URISyntaxException {
      assertError("inline-asm-refout-illegal", "Inline ASM reference is not constant");
   }

   @Test
   public void testInlineAsmRefoutConst() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-refout-const");
   }

   @Test
   public void testInlineAsmRefoutUndef() throws IOException, URISyntaxException {
      assertError("inline-asm-refout-undef", "Unknown variable qwe");
   }

   @Test
   public void testConstIfProblem() throws IOException, URISyntaxException {
      compileAndCompare("const-if-problem");
   }

   /*
   @Test
   public void testTetrisNullPointer() throws IOException, URISyntaxException {
      compileAndCompare("tetris-npe");
   }

   @Test
   public void testUnrollCall() throws IOException, URISyntaxException {
      compileAndCompare("unroll-call");
   }
   */



   @Test
   public void testInlineKasmRefout() throws IOException, URISyntaxException {
      compileAndCompare("inline-kasm-refout");
   }

   @Test
   public void testInlineKasmLoop() throws IOException, URISyntaxException {
      compileAndCompare("inline-kasm-loop");
   }

   @Test
   public void testInlineKasmData() throws IOException, URISyntaxException {
      compileAndCompare("inline-kasm-data");
   }

   @Test
   public void testInlineKasmResource() throws IOException, URISyntaxException {
      compileAndCompare("inline-kasm-resource");
   }

   @Test
   public void testInlineAsmRefout() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-refout");
   }

   @Test
   public void testInlineAsmOptimized() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-optimized");
   }

   @Test
   public void testCastNotNeeded() throws IOException, URISyntaxException {
      compileAndCompare("cast-not-needed");
   }

   @Test
   public void testNoLocalScope() throws IOException, URISyntaxException {
      assertError("nolocalscope", "Symbol already declared");
   }

   @Test
   public void testTypeMix() throws IOException, URISyntaxException {
      compileAndCompare("type-mix");
   }

   @Test
   public void testClobberProblem() throws IOException, URISyntaxException {
      compileAndCompare("scrollbig-clobber");
   }

   @Test
   public void testComparisonsSWord() throws IOException, URISyntaxException {
      compileAndCompare("test-comparisons-sword");
   }

   @Test
   public void testComparisonsWord() throws IOException, URISyntaxException {
      compileAndCompare("test-comparisons-word");
   }

   @Test
   public void testDuplicateLoopProblem() throws IOException, URISyntaxException {
      compileAndCompare("duplicate-loop-problem");
   }

   @Test
   public void testUseUninitialized() throws IOException, URISyntaxException {
      compileAndCompare("useuninitialized");
   }

   @Test
   public void testIllegalLValue2() throws IOException, URISyntaxException {
      assertError("illegallvalue2", "Illegal assignment Lvalue");
   }

   @Test
   public void testWordFragment1() throws IOException, URISyntaxException {
      compileAndCompare("wfragment1");
   }

   @Test
   public void testTravis1() throws IOException, URISyntaxException {
      compileAndCompare("travis1");
   }

   @Test
   public void testUninitialized() throws IOException, URISyntaxException {
      compileAndCompare("uninitialized");
   }

   @Test
   public void testStringConstConsolidationNoRoot() throws IOException, URISyntaxException {
      compileAndCompare("string-const-consolidation-noroot");
   }

   @Test
   public void testStringConstConsolidation() throws IOException, URISyntaxException {
      compileAndCompare("string-const-consolidation");
   }

   @Test
   public void testCommentsBlock() throws IOException, URISyntaxException {
      compileAndCompare("test-comments-block");
   }

   @Test
   public void testCommentsLoop() throws IOException, URISyntaxException {
      compileAndCompare("test-comments-loop");
   }

   @Test
   public void testCommentsSingle() throws IOException, URISyntaxException {
      compileAndCompare("test-comments-single");                                                        
   }

   @Test
   public void testCommentsUsage() throws IOException, URISyntaxException {
      compileAndCompare("test-comments-usage");
   }

   @Test
   public void testBgBlack() throws IOException, URISyntaxException {
      compileAndCompare("bgblack");
   }

   @Test
   public void testNoRecursionHeavy() throws IOException, URISyntaxException {
      compileAndCompare("no-recursion-heavy");
   }

   @Test
   public void testScrollUp() throws IOException, URISyntaxException {
      compileAndCompare("test-scroll-up");
   }

   @Test
   public void testRollSpriteMsb() throws IOException, URISyntaxException {
      compileAndCompare("roll-sprite-msb");
   }

   @Test
   public void testRollVariable() throws IOException, URISyntaxException {
      compileAndCompare("roll-variable");
   }

   @Test
   public void testWordsizeArrays() throws IOException, URISyntaxException {
      compileAndCompare("test-word-size-arrays");
   }

   @Test
   public void testRuntimeUnusedProcedure() throws IOException, URISyntaxException {
      compileAndCompare("runtime-unused-procedure");
   }

   //@Test
   //public void testRobozzle64() throws IOException, URISyntaxException {
   //   compileAndCompare("complex/robozzle64/robozzle64");
   //}

   //@Test
   //public void testTravisGame() throws IOException, URISyntaxException {
   //   compileAndCompare("complex/travis/game");
   //}

   @Test
   public void testTetrisSprites() throws IOException, URISyntaxException {
      compileAndCompare("complex/tetris/test-sprites");
   }

   @Test
   public void testTetris() throws IOException, URISyntaxException {
      compileAndCompare("complex/tetris/tetris");
   }

   @Test
   public void testConsolidateConstantProblem() throws IOException, URISyntaxException {
      compileAndCompare("consolidate-constant-problem");
   }

   @Test
   public void testConsolidateArrayIndexProblem() throws IOException, URISyntaxException {
      compileAndCompare("consolidate-array-index-problem");
   }

   @Test
   public void testScanDesireProblem() throws IOException, URISyntaxException {
      compileAndCompare("scan-desire-problem");
   }

   @Test
   public void testClobberAProblem() throws IOException, URISyntaxException {
      compileAndCompare("clobber-a-problem");
   }

   @Test
   public void testInterruptVolatileReuseProblem2() throws IOException, URISyntaxException {
      compileAndCompare("interrupt-volatile-reuse-problem2");
   }

   @Test
   public void testInterruptVolatileReuseProblem1() throws IOException, URISyntaxException {
      compileAndCompare("interrupt-volatile-reuse-problem1");
   }

   @Test
   public void testInitVolatiles() throws IOException, URISyntaxException {
      compileAndCompare("init-volatiles");
   }

   @Test
   public void testInterruptVolatileWrite() throws IOException, URISyntaxException {
      compileAndCompare("test-interrupt-volatile-write");
   }

   @Test
   public void testLongbranchInterruptProblem() throws IOException, URISyntaxException {
      compileAndCompare("longbranch-interrupt-problem");
   }

   @Test
   public void testVarInitProblem() throws IOException, URISyntaxException {
      compileAndCompare("var-init-problem");
   }


   @Test
   public void testFastMultiply8() throws IOException, URISyntaxException {
      compileAndCompare("examples/fastmultiply/fastmultiply8");
   }

   @Test
   public void test3DPerspective() throws IOException, URISyntaxException {
      compileAndCompare("examples/3d/perspective");
   }

   @Test
   public void test3D() throws IOException, URISyntaxException {
      compileAndCompare("examples/3d/3d");
   }

   @Test
   public void testTypeInferenceProblem() throws IOException, URISyntaxException {
      compileAndCompare("typeinference-problem");
   }

   @Test
   public void testRotate() throws IOException, URISyntaxException {
      compileAndCompare("examples/rotate/rotate");
   }

   @Test
   public void testInfLoopError() throws IOException, URISyntaxException {
      compileAndCompare("infloop-error");
   }

   @Test
   public void testMinFastMul16() throws IOException, URISyntaxException {
      compileAndCompare("min-fmul-16");
   }

   @Test
   public void testBitwiseNot() throws IOException, URISyntaxException {
      compileAndCompare("bitwise-not");
   }

   @Test
   public void testUnrollInfinite() throws IOException, URISyntaxException {
      assertError("unroll-infinite", "Loop cannot be unrolled.", false);
   }

   @Test
   public void testUnusedBlockProblem() throws IOException, URISyntaxException {
      compileAndCompare("unusedblockproblem");
   }

   @Test
   public void testUnrollScreenFillForDouble() throws IOException, URISyntaxException {
      compileAndCompare("unroll-screenfill-for-double");
   }

   @Test
   public void testUnrollScreenFillFor() throws IOException, URISyntaxException {
      compileAndCompare("unroll-screenfill-for");
   }

   @Test
   public void testUnrollScreenFillWhile() throws IOException, URISyntaxException {
      compileAndCompare("unroll-screenfill-while");
   }

   @Test
   public void testUnrollModifyVar() throws IOException, URISyntaxException {
      compileAndCompare("unroll-loop-modifyvar");
   }

   @Test
   public void testLoop100() throws IOException, URISyntaxException {
      compileAndCompare("loop100");
   }

   @Test
   public void testIrqHardwareClobberJsr() throws IOException, URISyntaxException {
      compileAndCompare("irq-hardware-clobber-jsr");
   }

   @Test
   public void testIrqHardwareClobber() throws IOException, URISyntaxException {
      compileAndCompare("irq-hardware-clobber");
   }

   @Test
   public void testIrqHardware() throws IOException, URISyntaxException {
      compileAndCompare("irq-hardware");
   }

   @Test
   public void testIrqKernel() throws IOException, URISyntaxException {
      compileAndCompare("irq-kernel");
   }

   @Test
   public void testIrqKernelMinimal() throws IOException, URISyntaxException {
      compileAndCompare("irq-kernel-minimal");
   }

   @Test
   public void testIrqHyperscreen() throws IOException, URISyntaxException {
      compileAndCompare("examples/irq/irq-hyperscreen");
   }

   @Test
   public void testIrqRaster() throws IOException, URISyntaxException {
      compileAndCompare("irq-raster");
   }

   @Test
   public void testInterruptVolatile() throws IOException, URISyntaxException {
      compileAndCompare("test-interrupt-volatile");
   }

   @Test
   public void testInterrupt() throws IOException, URISyntaxException {
      compileAndCompare("test-interrupt");
   }

   @Test
   public void testInterruptNoType() throws IOException, URISyntaxException {
      compileAndCompare("test-interrupt-notype");
   }

   @Test
   public void testMultiplexer() throws IOException, URISyntaxException {
      compileAndCompare("examples/multiplexer/simple-multiplexer", 10);
   }

   @Test
   public void testForRangedWords() throws IOException, URISyntaxException {
      compileAndCompare("forrangedwords");
   }

   @Test
   public void testArrayLengthSymbolicMin() throws IOException, URISyntaxException {
      compileAndCompare("array-length-symbolic-min");
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
      compileAndCompare("examples/sinplotter/sine-plotter");
   }

   @Test
   public void testScrollLogo() throws IOException, URISyntaxException {
      compileAndCompare("examples/scrolllogo/scrolllogo");
   }

   @Test
   public void testShowLogo() throws IOException, URISyntaxException {
      compileAndCompare("examples/showlogo/showlogo");
   }

   @Test
   public void testKasmPc() throws IOException, URISyntaxException {
      compileAndCompare("test-kasm-pc");
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
   public void testAssignmentCompound() throws IOException, URISyntaxException {
      compileAndCompare("assignment-compound");
   }

   @Test
   public void testAssignmentChained() throws IOException, URISyntaxException {
      compileAndCompare("assignment-chained");
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
      compileAndCompare("examples/helloworld/helloworld");
   }

   @Test
   public void testHelloWorld2() throws IOException, URISyntaxException {
      compileAndCompare("helloworld2");
   }

   @Test
   public void testHelloWorld2Inline() throws IOException, URISyntaxException {
      compileAndCompare("helloworld2-inline");
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
   public void testVarForwardProblem2() throws IOException, URISyntaxException {
      compileAndCompare("var-forward-problem2");
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
      compileAndCompare("c64dtv-gfxexplorer", 10);
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
      compileAndCompare("c64dtv-gfxmodes", 10);
   }

   @Test
   public void testNoromCharset() throws IOException, URISyntaxException {
      compileAndCompare("norom-charset");
   }

   @Test
   public void testChargenAnalysis() throws IOException, URISyntaxException {
      compileAndCompare("examples/chargen/chargen-analysis");
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
      compileAndCompare("examples/rasterbars/raster-bars");
   }

   @Test
   public void testComparisons() throws IOException, URISyntaxException {
      compileAndCompare("test-comparisons", 10);
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
      compileAndCompare("examples/sinsprites/sinus-sprites");
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
      compileAndCompare("examples/scrollbig/scrollbig");
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
      compileAndCompare("examples/bresenham/bitmap-bresenham");
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
      compileAndCompare("examples/scroll/scroll");
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
   public void testassignUndeclared() throws IOException, URISyntaxException {
      assertError("assignundeclared", "Unknown variable");
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
      assertError("noreturn", "Method must end with a return statement", false);
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
      assertError("invalid-consttype", "Constant variable has a non-matching type", false);
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
      assertError("array-length-mismatch", "Array length mismatch", false);
   }

   @Test
   public void testStringLengthMismatch() throws IOException, URISyntaxException {
      assertError("string-length-mismatch", "Array length mismatch", false);
   }

   @Test
   public void testIllegalAlignment() throws IOException, URISyntaxException {
      assertError("illegal-alignment", "Cannot align variable");
   }

   @Test
   public void testRegisterClobber() throws IOException, URISyntaxException {
      assertError("register-clobber", "register clobber problem", false);
   }

   @Test
   public void testRecursionError() throws IOException, URISyntaxException {
      assertError("recursion-error", "Recursion", false);
   }

   @Test
   public void testRecursionComplexError() throws IOException, URISyntaxException {
      assertError("recursion-error-complex", "Recursion", false);
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

   @Test
   public void testNoInlineInterrupt() throws IOException, URISyntaxException {
      assertError("no-inlineinterrupt", "Interrupts cannot be inlined", false);
   }

   @Test
   public void testNoCalledInterrupt() throws IOException, URISyntaxException {
      assertError("no-calledinterrupt", "Interrupts cannot be called.");
   }

   @Test
   public void testNoParamInterrupt() throws IOException, URISyntaxException {
      assertError("no-paraminterrupt", "Interrupts cannot have parameters.", false);
   }

   @Test
   public void testNoReturnInterrupt() throws IOException, URISyntaxException {
      assertError("no-returninterrupt", "Interrupts cannot return anything.", false);
   }

   @Test
   public void testConditionTypeMismatch() throws IOException, URISyntaxException {
      assertError("condition-type-mismatch", "Type mismatch non-boolean condition");
   }

   private void assertError(String kcFile, String expectError) throws IOException, URISyntaxException {
      assertError(kcFile, expectError, true);
   }

   private void assertError(String kcFile, String expectError, boolean expectLineNumber) throws IOException, URISyntaxException {
      try {
         compileAndCompare(kcFile);
      } catch(CompileError e) {
         System.out.println("Got error: " + e.getMessage());
         // expecting error!
         assertTrue("Error message expected  '" + expectError + "' - was:" + e.getMessage(), e.getMessage().contains(expectError));
         if(expectLineNumber) {
            // expecting line number!
            assertTrue("Error message expected  line number - was:" + e.getMessage(), e.getMessage().contains("Line"));
         }
         return;
      }
      fail("Expected compile error.");
   }

   private void compileAndCompare(String filename) throws IOException, URISyntaxException {
      TestPrograms tester = new TestPrograms();
      tester.testFile(filename, null);
   }

   private void compileAndCompare(String filename, int upliftCombinations) throws IOException, URISyntaxException {
      TestPrograms tester = new TestPrograms();
      tester.testFile(filename, upliftCombinations);
   }

   private void testFile(String fileName, Integer upliftCombinations) throws IOException, URISyntaxException {
      System.out.println("Testing output for " + fileName);
      Compiler compiler = new Compiler();
      compiler.addImportPath(stdlibPath);
      compiler.addImportPath(testPath);
      if(upliftCombinations != null) {
         compiler.setUpliftCombinations(upliftCombinations);
      }
      Program program = compiler.compile(fileName);

      compileAsm(fileName, program);

      boolean success = true;
      ReferenceHelper helper = new ReferenceHelperFolder(refPath);
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
         File asmFile = getBinFile(fileName, ".asm");
         String asmFolder = asmFile.getParent();
         File resFile = new File(asmFolder, asmResourceFile.getFileName().toString());
         mkPath(resFile);
         try {
            Files.copy(asmResourceFile, resFile.toPath());
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
      File binFile = new File(getBinDir(), fileName + extension);
      mkPath(binFile);
      return binFile;
   }

   /**
    * Ensures that the path to the passed file is created.
    *
    * @param file The file to create a path for
    */
   private void mkPath(File file) {
      Path parent = file.toPath().getParent();
      File dir = parent.toFile();
      if(!dir.exists()) {
         mkPath(dir);
         dir.mkdir();
      }
   }

   public File getBinDir() {
      Path tempDir = ReferenceHelper.getTempDir();
      File binDir = new File(tempDir.toFile(), "bin");
      if(!binDir.exists()) {
         binDir.mkdir();
      }
      return binDir;
   }


}