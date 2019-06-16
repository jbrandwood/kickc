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
import java.lang.management.GarbageCollectorMXBean;
import java.lang.management.ManagementFactory;
import java.lang.management.MemoryUsage;
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

   @Test
   public void testTypedef1() throws IOException, URISyntaxException {
      compileAndCompare("typedef-1");
   }

   @Test
   public void testTypedef0() throws IOException, URISyntaxException {
      compileAndCompare("typedef-0");
   }

   @Test
   public void testClearscreen() throws IOException, URISyntaxException {
      compileAndCompare("complex/clearscreen/clearscreen");
   }

   // TODO: Optimize unused IRQ's away (and other unused funtions that reference each other circularly)
   @Test
   public void testUnusedIrq() throws IOException, URISyntaxException {
      compileAndCompare("unused-irq");
   }

   /** TODO: Fix error with number resolving
   @Test
   public void testNumberTernaryFail() throws IOException, URISyntaxException {
      compileAndCompare("number-ternary-fail");
   }
    */

   @Test
   public void testTextbox() throws IOException, URISyntaxException {
      compileAndCompare("textbox");
   }

   @Test
   public void testStructPtr13() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-13");
   }

   /* TODO: Implement address-of (&) for struct values
   @Test
   public void testStructPtr12Ref() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-12-ref", log());
   }

   @Test
   public void testStructPtr12() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-12", log().verboseCreateSsa().verboseParse().verboseStatementSequence());
   }
   */

   @Test
   public void testStructPtr11() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-11");
   }

   @Test
   public void testStructPtr10() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-10");
   }

   @Test
   public void testStructPtr9() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-9");
   }

   @Test
   public void testStructPtr8() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-8");
   }

   @Test
   public void testStructPtr7() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-7");
   }

   @Test
   public void testStructPtr6() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-6");
   }

   @Test
   public void testStructPtr5() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-5");
   }

   @Test
   public void testStructPtr4() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-4");
   }

   @Test
   public void testStructPtr3() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-3");
   }

   @Test
   public void testStructPtr2() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-2");
   }

   @Test
   public void testStructPtr1() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-1");
   }

   @Test
   public void testStructPtr0() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-0");
   }

   @Test
   public void testStructError5() throws IOException, URISyntaxException {
      assertError("struct-err-5", "Unknown struct member");
   }

   @Test
   public void testStructError4() throws IOException, URISyntaxException {
      assertError("struct-err-4", "Unknown struct member");
   }

   @Test
   public void testStructError3() throws IOException, URISyntaxException {
      assertError("struct-err-3", "Parameters type mismatch in call");
   }

   @Test
   public void testStructError2() throws IOException, URISyntaxException {
      assertError("struct-err-2", "Incompatible struct assignment");
   }

   @Test
   public void testStructError1() throws IOException, URISyntaxException {
      assertError("struct-err-1", "Incompatible struct assignment");
   }

   @Test
   public void testStructError0() throws IOException, URISyntaxException {
      assertError("struct-err-0", "Unknown struct type");
   }

   @Test
   public void testStruct7() throws IOException, URISyntaxException {
      compileAndCompare("struct-7");
   }

   @Test
   public void testStruct6() throws IOException, URISyntaxException {
      compileAndCompare("struct-6");
   }

   @Test
   public void testStruct5() throws IOException, URISyntaxException {
      compileAndCompare("struct-5");
   }

   @Test
   public void testStruct4() throws IOException, URISyntaxException {
      compileAndCompare("struct-4");
   }

   @Test
   public void testStruct3() throws IOException, URISyntaxException {
      compileAndCompare("struct-3");
   }

   @Test
   public void testStruct2() throws IOException, URISyntaxException {
      compileAndCompare("struct-2");
   }

   @Test
   public void testStruct1() throws IOException, URISyntaxException {
      compileAndCompare("struct-1");
   }

   @Test
   public void testStruct0() throws IOException, URISyntaxException {
      compileAndCompare("struct-0");
   }

   @Test
   public void testSequenceLocality1() throws IOException, URISyntaxException {
      compileAndCompare("sequence-locality-1");
   }

   @Test
   public void testSequenceLocality0() throws IOException, URISyntaxException {
      compileAndCompare("sequence-locality-0");
   }

   public void testVoidParameter() throws IOException, URISyntaxException {
      compileAndCompare("void-parameter");
   }

   @Test
   public void testConditionInteger4() throws IOException, URISyntaxException {
      compileAndCompare("condition-integer-4");
   }

   @Test
   public void testConditionInteger3() throws IOException, URISyntaxException {
      compileAndCompare("condition-integer-3");
   }

   @Test
   public void testConditionInteger2() throws IOException, URISyntaxException {
      compileAndCompare("condition-integer-2");
   }

   @Test
   public void testConditionInteger1() throws IOException, URISyntaxException {
      compileAndCompare("condition-integer-1");
   }

   @Test
   public void testConditionInteger0() throws IOException, URISyntaxException {
      compileAndCompare("condition-integer-0");
   }

   @Test
   public void testStringUnknownEncoding() throws IOException, URISyntaxException {
      assertError("string-encoding-unknown", "Unknown string encoding");
   }

   @Test
   public void testStringEncodingMixError() throws IOException, URISyntaxException {
      assertError("string-encoding-mix-error", "Cannot mix encodings in concatenated strings");
   }

   @Test
   public void testStringEncodingPragma() throws IOException, URISyntaxException {
      compileAndCompare("string-encoding-pragma");
   }

   @Test
   public void testStringEncodingLiterals() throws IOException, URISyntaxException {
      compileAndCompare("string-encoding-literals");
   }

   @Test
   public void testRobozzleLabelProblem() throws IOException, URISyntaxException {
      compileAndCompare("robozzle64-label-problem");
   }

   @Test
   public void testGlobalPc() throws IOException, URISyntaxException {
      compileAndCompare("global-pc");
   }

   @Test
   public void testNoopCastElimination() throws IOException, URISyntaxException {
      compileAndCompare("noop-cast-elimination");
   }

   @Test
   public void testSignedWordMinusByte2() throws IOException, URISyntaxException {
      compileAndCompare("signed-word-minus-byte-2");
   }

   @Test
   public void testForTwoVars() throws IOException, URISyntaxException {
      compileAndCompare("for-two-vars");
   }

   @Test
   public void testC64DtvGfxExplorer() throws IOException, URISyntaxException {
      compileAndCompare("c64dtv-gfxexplorer", 10);
   }

   @Test
   public void testC64DtvGfxModes() throws IOException, URISyntaxException {
      compileAndCompare("c64dtv-gfxmodes", 10);
   }

   @Test
   public void testConstantStringConcat0() throws IOException, URISyntaxException {
      compileAndCompare("constant-string-concat-0");
   }

   @Test
   public void testLiterals() throws IOException, URISyntaxException {
      compileAndCompare("literals");
   }

   @Test
   public void testConstantStringConcat() throws IOException, URISyntaxException {
      compileAndCompare("constant-string-concat");
   }

   @Test
   public void testStatementSequence1() throws IOException, URISyntaxException {
      compileAndCompare("statement-sequence-1");
   }

   @Test
   public void testSubExprOptimize4() throws IOException, URISyntaxException {
      compileAndCompare("subexpr-optimize-4");
   }

   @Test
   public void testSubExprOptimize3() throws IOException, URISyntaxException {
      compileAndCompare("subexpr-optimize-3");
   }

   @Test
   public void testSubExprOptimize2() throws IOException, URISyntaxException {
      compileAndCompare("subexpr-optimize-2");
   }

   @Test
   public void testSubExprOptimize1() throws IOException, URISyntaxException {
      compileAndCompare("subexpr-optimize-1");
   }

   @Test
   public void testSubExprOptimize0() throws IOException, URISyntaxException {
      compileAndCompare("subexpr-optimize-0");
   }

   @Test
   public void testPtrPtrOptimize2() throws IOException, URISyntaxException {
      compileAndCompare("ptrptr-optimize-2");
   }

   @Test
   public void testPtrPtrOptimize1() throws IOException, URISyntaxException {
      compileAndCompare("ptrptr-optimize-1");
   }

   @Test
   public void testPtrPtrOptimize0() throws IOException, URISyntaxException {
      compileAndCompare("ptrptr-optimize-0");
   }

   @Test
   public void testHex2DecPtrPtr() throws IOException, URISyntaxException {
      compileAndCompare("hex2dec-ptrptr");
   }

   @Test
   public void testHex2Dec() throws IOException, URISyntaxException {
      compileAndCompare("hex2dec");
   }

   @Test
   public void testMemoryHeap() throws IOException, URISyntaxException {
      compileAndCompare("memory-heap");
   }

   @Test
   public void testTernaryInference() throws IOException, URISyntaxException {
      compileAndCompare("ternary-inference");
   }

   @Test
   public void testMul8uMin() throws IOException, URISyntaxException {
      compileAndCompare("mul8u-min");
   }

   @Test
   public void testNumberInferenceSum() throws IOException, URISyntaxException {
      compileAndCompare("number-inference-sum");
   }

   @Test
   public void testGfxBankOptimization() throws IOException, URISyntaxException {
      compileAndCompare("gfxbank");
   }

   @Test
   public void testDoubleIndexingArrays() throws IOException, URISyntaxException {
      compileAndCompare("double-indexing-arrays");
   }

   @Test
   public void testDerefidxWord2() throws IOException, URISyntaxException {
      compileAndCompare("derefidx-word-2");
   }

   @Test
   public void testDerefidxWord1() throws IOException, URISyntaxException {
      compileAndCompare("derefidx-word-1");
   }

   @Test
   public void testDerefidxWord0() throws IOException, URISyntaxException {
      compileAndCompare("derefidx-word-0");
   }

   @Test
   public void testFragmentVariations() throws IOException, URISyntaxException {
      compileAndCompare("fragment-variations");
   }

   @Test
   public void testTypeInference() throws IOException, URISyntaxException {
      compileAndCompare("type-inference");
   }

   @Test
   public void testMixedArray1() throws IOException, URISyntaxException {
      compileAndCompare("mixed-array-1");
   }

   @Test
   public void testMixedArray0() throws IOException, URISyntaxException {
      compileAndCompare("mixed-array-0");
   }

   @Test
   public void testInlinePointer2() throws IOException, URISyntaxException {
      compileAndCompare("inline-pointer-2");
   }

   @Test
   public void testInlinePointer1() throws IOException, URISyntaxException {
      compileAndCompare("inline-pointer-1");
   }

   @Test
   public void testInlinePointer0() throws IOException, URISyntaxException {
      compileAndCompare("inline-pointer-0");
   }

   @Test
   public void testToD018Problem() throws IOException, URISyntaxException {
      compileAndCompare("tod018-problem");
   }

   @Test
   public void testHelloWorld0() throws IOException, URISyntaxException {
      compileAndCompare("helloworld0");
   }

   @Test
   public void testNumberConversion() throws IOException, URISyntaxException {
      compileAndCompare("number-conversion");
   }

   @Test
   public void testNumberType() throws IOException, URISyntaxException {
      compileAndCompare("number-type");
   }

   @Test
   public void testIntegerConversion() throws IOException, URISyntaxException {
      compileAndCompare("int-conversion");
   }

   @Test
   public void testIntegerLiterals() throws IOException, URISyntaxException {
      compileAndCompare("int-literals");
   }

   @Test
   public void testSimpleLoop() throws IOException, URISyntaxException {
      compileAndCompare("simple-loop");
   }

   @Test
   public void testLiteralCharMinusNumber() throws IOException, URISyntaxException {
      compileAndCompare("literal-char-minus-number");
   }

   @Test
   public void testPaulNelsenSandboxTernaryError() throws IOException, URISyntaxException {
      compileAndCompare("sandbox-ternary-error");
   }

   @Test
   public void testPaulNelsenSandbox() throws IOException, URISyntaxException {
      compileAndCompare("sandbox");
   }

   @Test
   public void testPointerCast4() throws IOException, URISyntaxException {
      compileAndCompare("pointer-cast-4");
   }

   @Test
   public void testPointerCast3() throws IOException, URISyntaxException {
      compileAndCompare("pointer-cast-3");
   }

   @Test
   public void testTypeIdPlusByteProblem() throws IOException, URISyntaxException {
      compileAndCompare("typeid-plus-byte-problem");
   }

   @Test
   public void testTypeIdPlusBytes() throws IOException, URISyntaxException {
      compileAndCompare("typeid-plus-bytes");
   }

   @Test
   public void testTypeIdSimple() throws IOException, URISyntaxException {
      compileAndCompare("typeid-simple");
   }

   @Test
   public void testTypeSigned() throws IOException, URISyntaxException {
      compileAndCompare("type-signed");
   }

   @Test
   public void testConstIntCastProblem() throws IOException, URISyntaxException {
      compileAndCompare("const-int-cast-problem");
   }

   @Test
   public void testPointerPlus0() throws IOException, URISyntaxException {
      compileAndCompare("pointer-plus-0");
   }

   @Test
   public void testDerefToDerefIdx2() throws IOException, URISyntaxException {
      compileAndCompare("deref-to-derefidx-2");
   }

   @Test
   public void testDerefToDerefIdx() throws IOException, URISyntaxException {
      compileAndCompare("deref-to-derefidx");
   }

   @Test
   public void testSemiStruct2() throws IOException, URISyntaxException {
      compileAndCompare("semi-struct-2");
   }

   @Test
   public void testSemiStruct1() throws IOException, URISyntaxException {
      compileAndCompare("semi-struct-1");
   }

   @Test
   public void testStrip() throws IOException, URISyntaxException {
      compileAndCompare("strip");
   }

   @Test
   public void testReserveZpGlobal() throws IOException, URISyntaxException {
      compileAndCompare("reserve-zp-global");
   }

   @Test
   public void testReserveZpProcedure3() throws IOException, URISyntaxException {
      compileAndCompare("reserve-zp-procedure-3");
   }

   @Test
   public void testReserveZpProcedure2() throws IOException, URISyntaxException {
      compileAndCompare("reserve-zp-procedure-2");
   }

   @Test
   public void testReserveZpProcedure1() throws IOException, URISyntaxException {
      compileAndCompare("reserve-zp-procedure-1");
   }

   @Test
   public void testWordPointerCompound() throws IOException, URISyntaxException {
      compileAndCompare("word-pointer-compound");
   }

   @Test
   public void testWordPointerMath() throws IOException, URISyntaxException {
      compileAndCompare("word-pointer-math");
   }

   @Test
   public void testWordPointerMath0() throws IOException, URISyntaxException {
      compileAndCompare("word-pointer-math-0");
   }

   @Test
   public void testWordPointerIteration() throws IOException, URISyntaxException {
      compileAndCompare("word-pointer-iteration");
   }

   @Test
   public void testWordPointerIteration0() throws IOException, URISyntaxException {
      compileAndCompare("word-pointer-iteration-0");
   }

   @Test
   public void testWordArray2() throws IOException, URISyntaxException {
      compileAndCompare("word-array-2");
   }

   @Test
   public void testWordArray1() throws IOException, URISyntaxException {
      compileAndCompare("word-array-1");
   }

   @Test
   public void testWordArray0() throws IOException, URISyntaxException {
      compileAndCompare("word-array-0");
   }

   @Test
   public void testSizeofStruct() throws IOException, URISyntaxException {
      compileAndCompare("sizeof-struct");
   }

   @Test
   public void testSizeofArrays() throws IOException, URISyntaxException {
      compileAndCompare("sizeof-arrays");
   }

   @Test
   public void testSizeofExpression() throws IOException, URISyntaxException {
      compileAndCompare("sizeof-expr");
   }

   @Test
   public void testSizeofTypes() throws IOException, URISyntaxException {
      compileAndCompare("sizeof-types");
   }

   @Test
   public void testCommaDeclFor() throws IOException, URISyntaxException {
      compileAndCompare("comma-decl-for");
   }

   @Test
   public void testCommaDecl() throws IOException, URISyntaxException {
      compileAndCompare("comma-decl");
   }

   @Test
   public void testCommaExprFor() throws IOException, URISyntaxException {
      compileAndCompare("comma-expr-for");
   }

   @Test
   public void testCommaExpr2() throws IOException, URISyntaxException {
      compileAndCompare("comma-expr-2");
   }

   @Test
   public void testCommaExpr1() throws IOException, URISyntaxException {
      compileAndCompare("comma-expr-1");
   }

   @Test
   public void testForRangedNoVar() throws IOException, URISyntaxException {
      assertError("for-ranged-novar", "extraneous input");
   }

   @Test
   public void testForEmptyInit() throws IOException, URISyntaxException {
      compileAndCompare("for-empty-init");
   }

   @Test
   public void testForEmptyIncrement() throws IOException, URISyntaxException {
      compileAndCompare("for-empty-increment");
   }

   @Test
   public void testDivide2s() throws IOException, URISyntaxException {
      compileAndCompare("divide-2s");
   }

   @Test
   public void testMultiply2s() throws IOException, URISyntaxException {
      compileAndCompare("multiply-2s");
   }

   @Test
   public void testMultiplyNs() throws IOException, URISyntaxException {
      compileAndCompare("multiply-ns");
   }

   @Test
   public void testPointerCast2() throws IOException, URISyntaxException {
      compileAndCompare("pointer-cast-2");
   }

   @Test
   public void testPointerCast() throws IOException, URISyntaxException {
      compileAndCompare("pointer-cast");
   }

   @Test
   public void testLiteralStrings() throws IOException, URISyntaxException {
      compileAndCompare("literal-strings");
   }

   @Test
   public void testIllegalVoidParameter() throws IOException, URISyntaxException {
      assertError("illegal-void-parameter", "Illegal void parameter");
   }

   @Test
   public void testIllegalUnnamedParameter() throws IOException, URISyntaxException {
      assertError("illegal-unnamed-parameter", "Illegal unnamed parameter");
   }

   @Test
   public void testFire() throws IOException, URISyntaxException {
      compileAndCompare("examples/fire/fire");
   }

   @Test
   public void testCTypes() throws IOException, URISyntaxException {
      compileAndCompare("c-types");
   }

   @Test
   public void testPlus0() throws IOException, URISyntaxException {
      compileAndCompare("plus-0");
   }

   @Test
   public void testPlasmaUnroll() throws IOException, URISyntaxException {
      compileAndCompare("examples/plasma/plasma-unroll");
   }

   @Test
   public void testPlasma() throws IOException, URISyntaxException {
      compileAndCompare("examples/plasma/plasma");
   }

   @Test
   public void testTernary3() throws IOException, URISyntaxException {
      compileAndCompare("ternary-3");
   }

   @Test
   public void testTernary2() throws IOException, URISyntaxException {
      compileAndCompare("ternary-2");
   }

   @Test
   public void testTernary1() throws IOException, URISyntaxException {
      compileAndCompare("ternary-1");
   }

   @Test
   public void testPointerPointer3() throws IOException, URISyntaxException {
      compileAndCompare("pointer-pointer-3");
   }

   @Test
   public void testPointerPointer2() throws IOException, URISyntaxException {
      compileAndCompare("pointer-pointer-2");
   }

   @Test
   public void testPointerPointer1() throws IOException, URISyntaxException {
      compileAndCompare("pointer-pointer-1" );
   }

   @Test
   public void testFunctionPointerNoargCall10() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-10");
   }

   @Test
   public void testFunctionPointerNoargCall9() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-9");
   }

   @Test
   public void testFunctionPointerNoargCall8() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-8");
   }

   @Test
   public void testFunctionPointerNoargCall7() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-7");
   }

   @Test
   public void testFunctionPointerNoargCall6() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-6");
   }

   @Test
   public void testFunctionPointerNoargCall5() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-5");
   }

   @Test
   public void testFunctionPointerNoargCall4() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-4");
   }

   @Test
   public void testFunctionPointerNoargCall3() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-3");
   }

   @Test
   public void testFunctionPointerNoargCall2() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-2");
   }

   @Test
   public void testFunctionPointerNoargCall() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call");
   }

   @Test
   public void testFunctionPointerReturn() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-return");
   }

   @Test
   public void testFunctionPointerNoarg3() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-3");
   }

   @Test
   public void testFunctionPointerNoarg2() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-2");
   }

   @Test
   public void testFunctionPointerNoarg() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg");
   }

   @Test
   public void testComparisonRewriting() throws IOException, URISyntaxException {
      compileAndCompare("comparison-rewriting");
   }

   @Test
   public void testComparisonRewritingPointer() throws IOException, URISyntaxException {
      compileAndCompare("comparison-rewriting-pointer");
   }

   @Test
   public void testLoopBreakContinue() throws IOException, URISyntaxException {
      compileAndCompare("loop-break-continue");
   }

   @Test
   public void testLoopWhileContinue() throws IOException, URISyntaxException {
      compileAndCompare("loop-while-continue");
   }

   @Test
   public void testLoopContinue() throws IOException, URISyntaxException {
      compileAndCompare("loop-continue");
   }

   @Test
   public void testLoopBreakNested() throws IOException, URISyntaxException {
      compileAndCompare("loop-break-nested");
   }

   @Test
   public void testLoopBreak() throws IOException, URISyntaxException {
      compileAndCompare("loop-break");
   }

   @Test
   public void testLocalScopeLoops() throws IOException, URISyntaxException {
      compileAndCompare("localscope-loops");
   }

   @Test
   public void testLocalScopeSimple() throws IOException, URISyntaxException {
      compileAndCompare("localscope-simple");
   }

   @Test
   public void testIrqLocalVarOverlap() throws IOException, URISyntaxException {
      compileAndCompare("irq-local-var-overlap-problem");
   }

   @Test
   public void testMultiplexerIrq() throws IOException, URISyntaxException {
      compileAndCompare("multiplexer-irq/simple-multiplexer-irq", 10);
   }

   @Test
   public void testIrqVolatileProblem() throws IOException, URISyntaxException {
      compileAndCompare("irq-volatile-bool-problem");
   }

   @Test
   public void testMusicIrq() throws IOException, URISyntaxException {
      compileAndCompare("examples/music/music_irq");
   }

   @Test
   public void testMusic() throws IOException, URISyntaxException {
      compileAndCompare("examples/music/music");
   }

   @Test
   public void testConstEarlyIdentification() throws IOException, URISyntaxException {
      compileAndCompare("const-early-identification");
   }

   @Test
   public void testBoolNullPointerException() throws IOException, URISyntaxException {
      compileAndCompare("bool-nullpointer-exception");
   }

   @Test
   public void testSignedWordMinusByte() throws IOException, URISyntaxException {
      compileAndCompare("test-signed-word-minus-byte");
   }

   @Test
   public void testIrqIdxProblem() throws IOException, URISyntaxException {
      compileAndCompare("irq-idx-problem");
   }

   @Test
   public void testInlineKickAsmClobber() throws IOException, URISyntaxException {
      compileAndCompare("inline-kasm-clobber");
   }


   @Test
   public void testInlineAsmClobberNone() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-clobber-none");
   }

   @Test
   public void testInlineAsmJsrClobber() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-jsr-clobber");
   }

   @Test
   public void testComplexConditionalProblem() throws IOException, URISyntaxException {
      compileAndCompare("complex-conditional-problem");
   }

   @Test
   public void testConstSignedPromotion() throws IOException, URISyntaxException {
      compileAndCompare("const-signed-promotion");
   }

   @Test
   public void testSignedIndexedSubtract() throws IOException, URISyntaxException {
      compileAndCompare("signed-indexed-subtract");
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
   public void testCastNotNeeded2() throws IOException, URISyntaxException {
      compileAndCompare("cast-not-needed-2");
   }

   @Test
   public void testCastNotNeeded3() throws IOException, URISyntaxException {
      compileAndCompare("cast-not-needed-3");
   }

   @Test
   public void testCastNotNeeded() throws IOException, URISyntaxException {
      compileAndCompare("cast-not-needed");
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
   //   compileAndCompare("complex/robozzle_c64/robozzle64", log());
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
   public void testDeepNesting() throws IOException, URISyntaxException {
      compileAndCompare("deep-nesting");
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
   public void testC64DtvBlitterBox() throws IOException, URISyntaxException {
      compileAndCompare("c64dtv-blitter-box");
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
   public void testInlineString2() throws IOException, URISyntaxException {
      compileAndCompare("inline-string-2");
   }

   @Test
   public void testLoopProblem2() throws IOException, URISyntaxException {
      compileAndCompare("loop-problem2");
   }

   @Test
   public void testOperatorLoHiProblem1() throws IOException, URISyntaxException {
      compileAndCompare("operator-lohi-problem-1");
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
   public void testInlineWord0() throws IOException, URISyntaxException {
      compileAndCompare("inline-word-0");
   }

   @Test
   public void testInlineWord1() throws IOException, URISyntaxException {
      compileAndCompare("inline-word-1");
   }

   @Test
   public void testInlineWord2() throws IOException, URISyntaxException {
      compileAndCompare("inline-word-2");
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
      compileAndCompare("inline-asm-clobber");
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
      compileAndCompare("condition-type-mismatch");
   }

   @BeforeClass
   public static void setUp() {
      AsmFragmentTemplateSynthesizer.initialize("src/main/fragment/");
   }

   @AfterClass
   public static void tearDown() {
      CompileLog log = log();
      AsmFragmentTemplateUsages.logUsages(log, false, false, false, false, false, false);

      printGCStats();

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

   private static CompileLog log() {
      CompileLog log = new CompileLog();
      log.setSysOut(true);
      return log;
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
            assertTrue("Error message expected line number - was:" + e.getMessage(), e.getMessage().contains("Line"));
         }
         return;
      }
      fail("Expected compile error.");
   }

   private void compileAndCompare(String filename) throws IOException, URISyntaxException {
      TestPrograms tester = new TestPrograms();
      tester.testFile(filename, null, null);
   }

   private void compileAndCompare(String filename, CompileLog compileLog) throws IOException, URISyntaxException {
      TestPrograms tester = new TestPrograms();
      tester.testFile(filename, null, compileLog);
   }

   private void compileAndCompare(String filename, int upliftCombinations) throws IOException, URISyntaxException {
      TestPrograms tester = new TestPrograms();
      tester.testFile(filename, upliftCombinations, null);
   }

   private void compileAndCompare(String filename, CompileLog log, int upliftCombinations) throws IOException, URISyntaxException {
      TestPrograms tester = new TestPrograms();
      tester.testFile(filename, upliftCombinations, log);
   }

   private void testFile(String fileName, Integer upliftCombinations, CompileLog compileLog) throws IOException, URISyntaxException {
      System.out.println("Testing output for " + fileName);
      Compiler compiler = new Compiler();
      if(compileLog!=null) {
         compiler.setLog(compileLog);
      }
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
      success &= helper.testOutput(fileName, ".sym", program.getScope().toString(program, null));
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