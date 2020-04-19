package dk.camelot64.kickc.test;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.Compiler;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.fragment.AsmFragmentTemplateSynthesizer;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.TargetCpu;
import kickass.KickAssembler;
import kickass.nonasm.c64.CharToPetsciiConverter;
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
import java.nio.file.Paths;
import java.util.ArrayList;

import static junit.framework.TestCase.fail;
import static org.junit.Assert.assertTrue;

/**
 * Compile a number of source files and compare the resulting assembler with expected output
 */
public class TestPrograms {

   final String stdIncludePath = "src/main/kc/include";
   final String stdLibPath = "src/main/kc/lib";
   final String testPath = "src/test/kc";
   final String refPath = "src/test/ref/";

   public TestPrograms() {
   }

   @Test
   public void testProblemNegateConst() throws IOException, URISyntaxException {
      compileAndCompare("problem-negate-const.c");
   }

   @Test
   public void testProblemStructInlineParameter1() throws IOException, URISyntaxException {
      compileAndCompare("problem-struct-inline-parameter-1.c");
   }

   @Test
   public void testProblemStructInlineParameter() throws IOException, URISyntaxException {
      compileAndCompare("problem-struct-inline-parameter.c");
   }

   @Test
   public void testPrintf2() throws IOException, URISyntaxException {
      compileAndCompare("printf-2.c");
   }

   @Test
   public void testPrintf1() throws IOException, URISyntaxException {
      compileAndCompare("printf-1.c");
   }

   @Test
   public void testPrimes10002() throws IOException, URISyntaxException {
      compileAndCompare("primes-1000-2.c");
   }

   @Test
   public void testPrimes1000() throws IOException, URISyntaxException {
      compileAndCompare("primes-1000.c");
   }

   @Test
   public void testConioNachtScreen() throws IOException, URISyntaxException {
      compileAndCompare("examples/conio/nacht-screen.c");
   }

   @Test
   public void testPostIncrementProblem() throws IOException, URISyntaxException {
      compileAndCompare("post-increment-problem.c");
   }

   @Test
   public void testStrncat0() throws IOException, URISyntaxException {
      compileAndCompare("strncat-0.c");
   }

   @Test
   public void testIncludes3() throws IOException, URISyntaxException {
      compileAndCompare("complex/includes/includes-3.c");
   }

   @Test
   public void testIncludes2() throws IOException, URISyntaxException {
      compileAndCompare("complex/includes/includes-2.c");
   }

   @Test
   public void testIncludes1() throws IOException, URISyntaxException {
      compileAndCompare("complex/includes/includes-1.c");
   }

   @Test
   public void testCStyleDeclVarMultiple() throws IOException, URISyntaxException {
      compileAndCompare("cstyle-decl-var-multiple.c");
   }

   @Test
   public void testCStyleDeclVarMissing() throws IOException, URISyntaxException {
      assertError("cstyle-decl-var-missing.c", "Variable is declared but never defined: SCREEN", false);
   }

   @Test
   public void testCStyleDeclVarMismatch() throws IOException, URISyntaxException {
      assertError("cstyle-decl-var-mismatch.c", "Error! Conflicting declarations for: SCREEN");
   }

   @Test
   public void testCStyleDeclVarRedefinition() throws IOException, URISyntaxException {
      assertError("cstyle-decl-var-redefinition.c", "Error! Redefinition of variable: SCREEN");
   }

   @Test
   public void testCStyleDeclVar() throws IOException, URISyntaxException {
      compileAndCompare("cstyle-decl-var.c");
   }

   @Test
   public void testCStyleDeclFunctionMissing() throws IOException, URISyntaxException {
      assertError("cstyle-decl-function-missing.c", "Error! Function body is never defined: sum", false);
   }

   @Test
   public void testCStyleDeclFunctionRedefinition() throws IOException, URISyntaxException {
      assertError("cstyle-decl-function-redefinition.c", "Error! Redefinition of function: sum");
   }

   @Test
   public void testCStyleDeclFunctionMismatch() throws IOException, URISyntaxException {
      assertError("cstyle-decl-function-mismatch.c", "Error! Conflicting declarations for: sum");
   }

   @Test
   public void testCStyleDeclFunction() throws IOException, URISyntaxException {
      compileAndCompare("cstyle-decl-function.c");
   }

   @Test
   public void testPreprocessor9() throws IOException, URISyntaxException {
      compileAndCompare("preprocessor-9.c");
   }

   @Test
   public void testPreprocessor8() throws IOException, URISyntaxException {
      compileAndCompare("preprocessor-8.c");
   }

   @Test
   public void testPreprocessor7() throws IOException, URISyntaxException {
      compileAndCompare("preprocessor-7.c");
   }

   @Test
   public void testPreprocessor6() throws IOException, URISyntaxException {
      compileAndCompare("preprocessor-6.c");
   }

   @Test
   public void testPreprocessor5() throws IOException, URISyntaxException {
      compileAndCompare("preprocessor-5.c");
   }

   @Test
   public void testPreprocessor4() throws IOException, URISyntaxException {
      compileAndCompare("preprocessor-4.c");
   }

   @Test
   public void testPreprocessor3() throws IOException, URISyntaxException {
      compileAndCompare("preprocessor-3.c");
   }

   @Test
   public void testPreprocessor2() throws IOException, URISyntaxException {
      compileAndCompare("preprocessor-2.c");
   }

   @Test
   public void testPreprocessor1() throws IOException, URISyntaxException {
      compileAndCompare("preprocessor-1.c");
   }

   @Test
   public void testPreprocessor0() throws IOException, URISyntaxException {
      compileAndCompare("preprocessor-0.c");
   }

   @Test
   public void testMaCoalesceProblem() throws IOException, URISyntaxException {
      compileAndCompare("ma_coalesce_problem.c");
   }

   @Test
   public void testVarModelMaMem5() throws IOException, URISyntaxException {
      compileAndCompare("varmodel-ma_mem-5.c");
   }

   @Test
   public void testVarModelMaMem4() throws IOException, URISyntaxException {
      compileAndCompare("varmodel-ma_mem-4.c");
   }

   @Test
   public void testVarModelMaMem3() throws IOException, URISyntaxException {
      compileAndCompare("varmodel-ma_mem-3.c");
   }

   @Test
   public void testVarModelMaMem2() throws IOException, URISyntaxException {
      compileAndCompare("varmodel-ma_mem-2.c");
   }

   @Test
   public void testVarModelMaMem() throws IOException, URISyntaxException {
      compileAndCompare("varmodel-ma_mem.c");
   }

   @Test
   public void testVarModelUnknown() throws IOException, URISyntaxException {
      assertError("varmodel-unknown.c", "Error! Malformed var_model parameter");
   }

   @Test
   public void testMillforkPlasma() throws IOException, URISyntaxException {
      compileAndCompare("millfork-benchmarks/plasma-kc.c");
   }

   @Test
   public void testMillforkRomsum() throws IOException, URISyntaxException {
      compileAndCompare("millfork-benchmarks/romsum-kc.c");
   }

   @Test
   public void testMillforkSieve() throws IOException, URISyntaxException {
      compileAndCompare("millfork-benchmarks/sieve-kc.c");
   }

   @Test
   public void testMillforkLinkedlist() throws IOException, URISyntaxException {
      compileAndCompare("millfork-benchmarks/linkedlist-kc.c");
   }


   @Test
   public void testSqrDelta() throws IOException, URISyntaxException {
      compileAndCompare("sqr-delta.c");
   }

   @Test
   public void testRegister1() throws IOException, URISyntaxException {
      assertError("register-1.c", "Unknown register");
   }

   @Test
   public void testRegister0() throws IOException, URISyntaxException {
      compileAndCompare("register-0.c");
   }

   // TODO: Fix this. Currently a volatile __address() variable can still be optimized away completely.
   //@Test
   //public void testAddress7() throws IOException, URISyntaxException {
   //   compileAndCompare("address-7.c", log());
   //}

   @Test
   public void testAddress6() throws IOException, URISyntaxException {
      compileAndCompare("address-6.c");
   }

   @Test
   public void testAddress5() throws IOException, URISyntaxException {
      compileAndCompare("address-5.c");
   }

   @Test
   public void testAddress4() throws IOException, URISyntaxException {
      compileAndCompare("address-4.c");
   }

   @Test
   public void testAddress3() throws IOException, URISyntaxException {
      compileAndCompare("address-3.c");
   }

   @Test
   public void testAddress2() throws IOException, URISyntaxException {
      compileAndCompare("address-2.c");
   }

   @Test
   public void testAddress1() throws IOException, URISyntaxException {
      compileAndCompare("address-1.c");
   }

   @Test
   public void testAddress0() throws IOException, URISyntaxException {
      compileAndCompare("address-0.c");
   }

   @Test
   public void testVolatile2() throws IOException, URISyntaxException {
      compileAndCompare("volatile-2.c");
   }

   @Test
   public void testVolatile1() throws IOException, URISyntaxException {
      compileAndCompare("volatile-1.c");
   }

   @Test
   public void testVolatile0() throws IOException, URISyntaxException {
      compileAndCompare("volatile-0.c");
   }

   @Test
   public void testNomodify5() throws IOException, URISyntaxException {
      assertError("nomodify-5.c", "const variable may not be modified");
   }

   @Test
   public void testNomodify4() throws IOException, URISyntaxException {
      compileAndCompare("nomodify-4.c");
   }

   @Test
   public void testNomodify3() throws IOException, URISyntaxException {
      compileAndCompare("nomodify-3.c");
   }

   @Test
   public void testNomodify2() throws IOException, URISyntaxException {
      assertError("nomodify-2.c", "const variable may not be modified");
   }

   @Test
   public void testNomodify1() throws IOException, URISyntaxException {
      assertError("nomodify-1.c", "const variable may not be modified");
   }

   @Test
   public void testNomodify0() throws IOException, URISyntaxException {
      assertError("nomodify-0.c", "const variable may not be modified");
   }

   @Test
   public void testKernalLoad() throws IOException, URISyntaxException {
      compileAndCompare("examples/kernalload/kernalload.c");
   }

   @Test
   public void testConstantWithPrePost() throws IOException, URISyntaxException {
      assertError("constant-prepost.c", "Constant value contains a pre/post-modifier");
   }

   @Test
   public void testSpriteScroller() throws IOException, URISyntaxException {
      compileAndCompare("complex/spritescroller/spritescroller.c");
   }

   @Test
   public void testGridBobs() throws IOException, URISyntaxException {
      compileAndCompare("complex/prebob/grid-bobs.c");
   }

   @Test
   public void testVogelBobs() throws IOException, URISyntaxException {
      compileAndCompare("complex/prebob/vogel-bobs.c");
   }

   @Test
   public void testVogelSprites() throws IOException, URISyntaxException {
      compileAndCompare("complex/prebob/vogel-sprites.c");
   }

   @Test
   public void testUnaryPlus() throws IOException, URISyntaxException {
      compileAndCompare("unary-plus.c");
   }

   @Test
   public void testConstDeclaration() throws IOException, URISyntaxException {
      compileAndCompare("const-declaration.c");
   }

   @Test
   public void testStaticRegisterOptimizationProblem() throws IOException, URISyntaxException {
      compileAndCompare("static-register-optimization-problem.c");
   }

   @Test
   public void testDeclaredSsaVar0() throws IOException, URISyntaxException {
      compileAndCompare("declared-ssa-var-0.c");
   }

   @Test
   public void testDeclaredMemoryVar8() throws IOException, URISyntaxException {
      compileAndCompare("declared-memory-var-8.c");
   }

   @Test
   public void testDeclaredMemoryVar7() throws IOException, URISyntaxException {
      compileAndCompare("declared-memory-var-7.c");
   }

   @Test
   public void testDeclaredMemoryVar6() throws IOException, URISyntaxException {
      compileAndCompare("declared-memory-var-6.c");
   }

   @Test
   public void testDeclaredMemoryVar5() throws IOException, URISyntaxException {
      compileAndCompare("declared-memory-var-5.c");
   }

   @Test
   public void testDeclaredMemoryVar4() throws IOException, URISyntaxException {
      compileAndCompare("declared-memory-var-4.c");
   }

   @Test
   public void testDeclaredMemoryVar3() throws IOException, URISyntaxException {
      compileAndCompare("declared-memory-var-3.c");
   }

   @Test
   public void testDeclaredMemoryVar2() throws IOException, URISyntaxException {
      compileAndCompare("declared-memory-var-2.c");
   }

   @Test
   public void testDeclaredMemoryVar1() throws IOException, URISyntaxException {
      compileAndCompare("declared-memory-var-1.c");
   }

   @Test
   public void testDeclaredMemoryVar0() throws IOException, URISyntaxException {
      compileAndCompare("declared-memory-var-0.c");
   }

   @Test
   public void testProcedureCallingConventionStack12() throws IOException, URISyntaxException {
      compileAndCompare("procedure-callingconvention-stack-12.c");
   }

   @Test
   public void testProcedureCallingConventionStack11() throws IOException, URISyntaxException {
      compileAndCompare("procedure-callingconvention-stack-11.c");
   }

   @Test
   public void testProcedureCallingConventionStack10() throws IOException, URISyntaxException {
      compileAndCompare("procedure-callingconvention-stack-10.c");
   }

   @Test
   public void testProcedureCallingConventionStack9() throws IOException, URISyntaxException {
      compileAndCompare("procedure-callingconvention-stack-9.c");
   }

   @Test
   public void testProcedureCallingConventionStack8() throws IOException, URISyntaxException {
      compileAndCompare("procedure-callingconvention-stack-8.c");
   }

   @Test
   public void testProcedureCallingConventionStack7() throws IOException, URISyntaxException {
      compileAndCompare("procedure-callingconvention-stack-7.c");
   }

   /*
   @Test
   public void testProcedureCallingConventionStack6() throws IOException, URISyntaxException {
      compileAndCompare("procedure-callingconvention-stack-6.c", log()); //, log().verboseCreateSsa().verboseParse().verboseStatementSequence());
   }
   */

   @Test
   public void testProcedureCallingConventionStack5() throws IOException, URISyntaxException {
      compileAndCompare("procedure-callingconvention-stack-5.c"); //, log().verboseCreateSsa().verboseParse().verboseStatementSequence());
   }

   @Test
   public void testProcedureCallingConventionStack4() throws IOException, URISyntaxException {
      compileAndCompare("procedure-callingconvention-stack-4.c"); //, log().verboseCreateSsa().verboseParse().verboseStatementSequence());
   }

   @Test
   public void testProcedureCallingConventionStack3() throws IOException, URISyntaxException {
      compileAndCompare("procedure-callingconvention-stack-3.c"); //, log().verboseCreateSsa().verboseParse().verboseStatementSequence());
   }

   @Test
   public void testProcedureCallingConventionStack2() throws IOException, URISyntaxException {
      compileAndCompare("procedure-callingconvention-stack-2.c"); //, log().verboseCreateSsa().verboseParse().verboseStatementSequence());
   }

   @Test
   public void testProcedureCallingConventionStack1() throws IOException, URISyntaxException {
      compileAndCompare("procedure-callingconvention-stack-1.c");
   }

   @Test
   public void testProcedureCallingConventionStack0() throws IOException, URISyntaxException {
      compileAndCompare("procedure-callingconvention-stack-0.c");
   }

   @Test
   public void testSignedCharComparison() throws IOException, URISyntaxException {
      compileAndCompare("signed-char-comparison.c");
   }

   @Test
   public void testBitmapLineAnim2() throws IOException, URISyntaxException {
      compileAndCompare("bitmap-line-anim-2.c");
   }

   @Test
   public void testBitmapLineAnim1() throws IOException, URISyntaxException {
      compileAndCompare("bitmap-line-anim-1.c");
   }

   @Test
   public void testStackRelativeAddressing() throws IOException, URISyntaxException {
      compileAndCompare("stack-relative-addressing.c");
   }

   @Test
   public void testStringPointerProblem() throws IOException, URISyntaxException {
      compileAndCompare("string-pointer-problem.c");
   }

/*
   @Test
   public void testMaze() throws IOException, URISyntaxException {
      compileAndCompare("complex/maze/maze.c", log().verboseSSAOptimize());
   }

   @Test
   public void testOs52() throws IOException, URISyntaxException {
         compileAndCompare("complex/unit5/os5.2.c");
   }

   @Test
   public void testOs51() throws IOException, URISyntaxException {
      compileAndCompare("complex/unit5/os5.1.c");
   }
*/

   @Test
   public void testCpu6502() throws IOException, URISyntaxException {
      compileAndCompare("cpu-6502.c");
   }

   @Test
   public void testZpCode() throws IOException, URISyntaxException {
      compileAndCompare("examples/zpcode/zpcode.c");
   }

   // Fix parameter type problem - https://gitlab.com/camelot/kickc/issues/299
   /*
   @Test
   public void testParameterAutocastWrong() throws IOException, URISyntaxException {
      compileAndCompare("parameter-autocast-wrong.c");
   }
   */

   /**
    * Fix number type resolving https://gitlab.com/camelot/kickc/issues/199
    *
    * @Test public void testConstBool0() throws IOException, URISyntaxException {
    * compileAndCompare("const-bool-0.c");
    * }
    */

   @Test
   public void testAsmCullingJmp() throws IOException, URISyntaxException {
      compileAndCompare("asm-culling-jmp.c");
   }

   @Test
   public void testZeropageDetectAdvanced() throws IOException, URISyntaxException {
      compileAndCompare("zeropage-detect-advanced.c");
   }

   @Test
   public void testKickasmUsesPreventDeletion() throws IOException, URISyntaxException {
      compileAndCompare("kickasm-uses-prevent-deletion.c");
   }

   @Test
   public void testAsmUses0() throws IOException, URISyntaxException {
      compileAndCompare("asm-uses-0.c");
   }

   // TODO: Fix inline kickasm uses handling of used variables. https://gitlab.com/camelot/kickc/issues/296
   /*
   @Test
   public void testKickasmUses1() throws IOException, URISyntaxException {
      compileAndCompare("kickasm-uses-1.c");
   }

   @Test
   public void testKickasmUses0() throws IOException, URISyntaxException {
      compileAndCompare("kickasm-uses-0.c");
   }
   */


   @Test
   public void testBitmapCircle2() throws IOException, URISyntaxException {
      compileAndCompare("bitmap-circle-2.c");
   }

   @Test
   public void testBitmapCircle() throws IOException, URISyntaxException {
      compileAndCompare("bitmap-circle.c");
   }

   // TODO: Optimize comparisons with values outside the range of types https://gitlab.com/camelot/kickc/issues/291
   @Test
   public void testOptimizeUnsignedComparisons() throws IOException, URISyntaxException {
      compileAndCompare("optimize-unsigned-comparisons.c");
   }

   // TODO: Fix loop head problem! https://gitlab.com/camelot/kickc/issues/290
   @Test
   public void testLoopheadProblem3() throws IOException, URISyntaxException {
      compileAndCompare("loophead-problem-3.c");
   }

   // TODO: Fix loop head problem! https://gitlab.com/camelot/kickc/issues/290
   @Test
   public void testLoopheadProblem2() throws IOException, URISyntaxException {
      compileAndCompare("loophead-problem-2.c");
   }

   // TODO: Fix loop head problem! https://gitlab.com/camelot/kickc/issues/261
   @Test
   public void testLoopheadProblem() throws IOException, URISyntaxException {
      compileAndCompare("loophead-problem.c");
   }

   @Test
   public void testPointerPlusSignedWord() throws IOException, URISyntaxException {
      compileAndCompare("pointer-plus-signed-word.c");
   }

   @Test
   public void testAsmMnemonicNames() throws IOException, URISyntaxException {
      compileAndCompare("asm-mnemonic-names.c");
   }

   @Test
   public void testParseNegatedStructRef() throws IOException, URISyntaxException {
      compileAndCompare("parse-negated-struct-ref.c");
   }

   @Test
   public void testLongPointer1() throws IOException, URISyntaxException {
      compileAndCompare("long-pointer-1.c");
   }

   @Test
   public void testLongPointer0() throws IOException, URISyntaxException {
      compileAndCompare("long-pointer-0.c");
   }

   @Test
   public void testPointerAnding() throws IOException, URISyntaxException {
      compileAndCompare("pointer-anding.c");
   }

   @Test
   public void testForcedZeropage() throws IOException, URISyntaxException {
      compileAndCompare("forced-zeropage.c");
   }

   @Test
   public void testFloatErrorMessage() throws IOException, URISyntaxException {
      assertError("float-error-message.c", "Non-integer numbers are not supported");
   }

   @Test
   public void testFunctionAsArray() throws IOException, URISyntaxException {
      assertError("function-as-array.c", "Error! Dereferencing a non-pointer type void()");
   }

   @Test
   public void testCodeAfterReturn1() throws IOException, URISyntaxException {
      compileAndCompare("code-after-return-1.c");
   }

   @Test
   public void testCodeAfterReturn() throws IOException, URISyntaxException {
      compileAndCompare("code-after-return.c");
   }

   @Test
   public void testStringEscapesErr1() throws IOException, URISyntaxException {
      assertError("string-escapes-err-1.c", "Illegal string escape sequence");
   }

   @Test
   public void testStringEscapesErr0() throws IOException, URISyntaxException {
      assertError("string-escapes-err-0.c", "Unfinished string escape sequence at end of string");
   }

   @Test
   public void testStringEscapes5() throws IOException, URISyntaxException {
      compileAndCompare("string-escapes-5.c");
   }

   @Test
   public void testStringEscapes4() throws IOException, URISyntaxException {
      compileAndCompare("string-escapes-4.c");
   }

   @Test
   public void testStringEscapes3() throws IOException, URISyntaxException {
      compileAndCompare("string-escapes-3.c");
   }

   @Test
   public void testStringEscapes2() throws IOException, URISyntaxException {
      compileAndCompare("string-escapes-2.c");
   }

   @Test
   public void testStringEscapes1() throws IOException, URISyntaxException {
      compileAndCompare("string-escapes-1.c");
   }

   @Test
   public void testStringEscapes0() throws IOException, URISyntaxException {
      compileAndCompare("string-escapes-0.c");
   }

   @Test
   public void testSwitch3Err() throws IOException, URISyntaxException {
      assertError("switch-3-err.c", "Continue not inside a loop!");
   }

   @Test
   public void testSwitch4() throws IOException, URISyntaxException {
      compileAndCompare("switch-4.c");
   }

   @Test
   public void testSwitch2() throws IOException, URISyntaxException {
      compileAndCompare("switch-2.c");
   }

   @Test
   public void testSwitch1() throws IOException, URISyntaxException {
      compileAndCompare("switch-1.c");
   }

   @Test
   public void testSwitch0() throws IOException, URISyntaxException {
      compileAndCompare("switch-0.c");
   }

   @Test
   public void testCastError() throws IOException, URISyntaxException {
      assertError("cast-error.c", "Type mismatch");
   }

   @Test
   public void testInlineAsmParam() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-param.c");
   }

   @Test
   public void testAtariTempest() throws IOException, URISyntaxException {
      compileAndCompare("complex/ataritempest/ataritempest.c");
   }

   @Test
   public void testXMega65Logo() throws IOException, URISyntaxException {
      compileAndCompare("complex/xmega65/xmega65logo.c");
   }

   @Test
   public void testXMega65() throws IOException, URISyntaxException {
      compileAndCompare("complex/xmega65/xmega65.c");
   }

   @Test
   public void testLinking() throws IOException, URISyntaxException {
      compileAndCompare("examples/linking/linking.c");
   }

   @Test
   public void testNmiSamples() throws IOException, URISyntaxException {
      compileAndCompare("examples/nmisamples/nmisamples.c");
   }

   @Test
   public void testEncodingLiteralChar() throws IOException, URISyntaxException {
      compileAndCompare("encoding-literal-char.c");
   }

   @Test
   public void testKcKaStringEncoding() throws IOException, URISyntaxException {
      compileAndCompare("kc-ka-string-encoding.c");
   }

   @Test
   public void testGlobalPcMultiple() throws IOException, URISyntaxException {
      compileAndCompare("global-pc-multiple.c");
   }

   @Test
   public void testStructPosFill() throws IOException, URISyntaxException {
      compileAndCompare("struct-pos-fill.c");
   }

   @Test
   public void testDannyJoystickProblem() throws IOException, URISyntaxException {
      compileAndCompare("danny-joystick-problem.c");
   }

   @Test
   public void testZeropageSinus() throws IOException, URISyntaxException {
      compileAndCompare("zeropage-sinus.c");
   }

   @Test
   public void testProcessorPortTest() throws IOException, URISyntaxException {
      compileAndCompare("processor-port-test.c");
   }

   @Test
   public void testSieve() throws IOException, URISyntaxException {
      compileAndCompare("sieve.c");
   }

   @Test
   public void testSieveMin() throws IOException, URISyntaxException {
      compileAndCompare("sieve-min.c");
   }

   @Test
   public void testCoalesceAssignment() throws IOException, URISyntaxException {
      compileAndCompare("coalesce-assignment.c");
   }

   @Test
   public void testArray16bitLookup() throws IOException, URISyntaxException {
      compileAndCompare("array-16bit-lookup.c");
   }

   @Test
   public void testZeropageExhausted() throws IOException, URISyntaxException {
      assertError("zeropage-exhausted.c", "Variables used in program do not fit on zeropage", false);
   }

   @Test
   public void testPlatformAsm6502() throws IOException, URISyntaxException {
      compileAndCompare("platform-asm6502.c");
   }

   @Test
   public void testEuclid2() throws IOException, URISyntaxException {
      compileAndCompare("euclid-3.c");
   }

   @Test
   public void testEuclidProblem2() throws IOException, URISyntaxException {
      compileAndCompare("euclid-problem-2.c");
   }

   @Test
   public void testEuclidProblem() throws IOException, URISyntaxException {
      compileAndCompare("euclid-problem.c");
   }

   @Test
   public void testFastMultiply127() throws IOException, URISyntaxException {
      compileAndCompare("fastmultiply-127.c");
   }

   @Test
   public void testTrueTypeSplines() throws IOException, URISyntaxException {
      compileAndCompare("complex/splines/truetype-splines.c");
   }

   @Test
   public void testProblemNegativeWordConst() throws IOException, URISyntaxException {
      compileAndCompare("problem-negative-word-const.c");
   }

   //@Test
   //public void testProblemConstAddition() throws IOException, URISyntaxException {
   //   compileAndCompare("problem-const-addition.c", log());
   //}

   @Test
   public void testInnerIncrementProblem() throws IOException, URISyntaxException {
      compileAndCompare("inner-increment-problem.c");
   }

   @Test
   public void testFillSquare() throws IOException, URISyntaxException {
      compileAndCompare("fill-square.c");
   }

   @Test
   public void testPlasmaCenter() throws IOException, URISyntaxException {
      compileAndCompare("plasma-center.c");
   }

   @Test
   public void testScreenShowSpiralBuckets() throws IOException, URISyntaxException {
      compileAndCompare("screen-show-spiral-buckets.c");
   }

   @Test
   public void testScreenShowSpiral() throws IOException, URISyntaxException {
      compileAndCompare("screen-show-spiral.c");
   }

   @Test
   public void testNesArray() throws IOException, URISyntaxException {
      compileAndCompare("nes-array.c");
   }

   @Test
   public void testLiverangeProblem0() throws IOException, URISyntaxException {
      compileAndCompare("liverange-problem-0.c");
   }

   @Test
   public void testCiaTimerCyclecount() throws IOException, URISyntaxException {
      compileAndCompare("cia-timer-cyclecount.c");
   }

   @Test
   public void testCiaTimerSimple() throws IOException, URISyntaxException {
      compileAndCompare("cia-timer-simple.c");
   }

   @Test
   public void testArraysInitKasm0() throws IOException, URISyntaxException {
      compileAndCompare("arrays-init-kasm-0.c");
   }

   @Test
   public void testScreenCenterAngle() throws IOException, URISyntaxException {
      compileAndCompare("screen-center-angle.c");
   }

   @Test
   public void testCordicAtan2Clear() throws IOException, URISyntaxException {
      compileAndCompare("cordic-atan2-clear.c");
   }

   @Test
   public void testCordicAtan2Ref() throws IOException, URISyntaxException {
      compileAndCompare("cordic-atan2-16-ref.c");
   }

   @Test
   public void testCordicAtan2_16() throws IOException, URISyntaxException {
      compileAndCompare("cordic-atan2-16.c");
   }

   @Test
   public void testCordicAtan2_8() throws IOException, URISyntaxException {
      compileAndCompare("cordic-atan2.c");
   }

   @Test
   public void testDefaultFont() throws IOException, URISyntaxException {
      compileAndCompare("default-font.c");
   }

   @Test
   public void testUnsignedVoidError() throws IOException, URISyntaxException {
      assertError("unsigned-void-error.c", "Unknown type unsigned void");
   }

   @Test
   public void testScreenCenterDistance() throws IOException, URISyntaxException {
      compileAndCompare("screen-center-distance.c");
   }

   @Test
   public void testFontHexShow() throws IOException, URISyntaxException {
      compileAndCompare("font-hex-show.c");
   }

   @Test
   public void testMemcpy1() throws IOException, URISyntaxException {
      compileAndCompare("memcpy-1.c");
   }

   @Test
   public void testMemcpy0() throws IOException, URISyntaxException {
      compileAndCompare("memcpy-0.c");
   }

   @Test
   public void testBitmapPlot3() throws IOException, URISyntaxException {
      compileAndCompare("bitmap-plot-3.c");
   }

   @Test
   public void testBitmapPlot2() throws IOException, URISyntaxException {
      compileAndCompare("bitmap-plot-2.c");
   }

   @Test
   public void testBitmapPlot1() throws IOException, URISyntaxException {
      compileAndCompare("bitmap-plot-1.c");
   }

   @Test
   public void testBitmapPlot0() throws IOException, URISyntaxException {
      compileAndCompare("bitmap-plot-0.c");
   }

   @Test
   public void testCallParameterAutocast() throws IOException, URISyntaxException {
      compileAndCompare("call-parameter-autocast.c");
   }

   @Test
   public void testPointerVoidErr0() throws IOException, URISyntaxException {
      assertError("pointer-void-err-0.c", "Void pointer math not allowed.");
   }

   @Test
   public void testPointerVoid3() throws IOException, URISyntaxException {
      compileAndCompare("pointer-void-3.c");
   }

   @Test
   public void testPointerVoid2() throws IOException, URISyntaxException {
      compileAndCompare("pointer-void-2.c");
   }

   @Test
   public void testPointerVoid1() throws IOException, URISyntaxException {
      compileAndCompare("pointer-void-1.c");
   }

   @Test
   public void testPointerVoid0() throws IOException, URISyntaxException {
      compileAndCompare("pointer-void-0.c");
   }

   @Test
   public void testEnumErr2() throws IOException, URISyntaxException {
      assertError("enum-err-2.c", "Enum value not constant");
   }

   @Test
   public void testEnumErr1() throws IOException, URISyntaxException {
      assertError("enum-err-1.c", "Symbol already declared");
   }

   @Test
   public void testEnumErr0() throws IOException, URISyntaxException {
      assertError("enum-err-0.c", "Symbol already declared");
   }

   @Test
   public void testEnum8() throws IOException, URISyntaxException {
      compileAndCompare("enum-8.c");
   }

   @Test
   public void testEnum7() throws IOException, URISyntaxException {
      compileAndCompare("enum-7.c");
   }

   @Test
   public void testEnum6() throws IOException, URISyntaxException {
      compileAndCompare("enum-6.c");
   }

   @Test
   public void testEnum5() throws IOException, URISyntaxException {
      compileAndCompare("enum-5.c");
   }

   @Test
   public void testEnum4() throws IOException, URISyntaxException {
      compileAndCompare("enum-4.c");
   }

   @Test
   public void testEnum3() throws IOException, URISyntaxException {
      compileAndCompare("enum-3.c");
   }

   @Test
   public void testEnum2() throws IOException, URISyntaxException {
      compileAndCompare("enum-2.c");
   }

   @Test
   public void testEnum1() throws IOException, URISyntaxException {
      compileAndCompare("enum-1.c");
   }

   @Test
   public void testEnum0() throws IOException, URISyntaxException {
      compileAndCompare("enum-0.c");
   }

   @Test
   public void testPointerConstTypedef() throws IOException, URISyntaxException {
      compileAndCompare("pointer-const-typedef.c");
   }

   @Test
   public void testTypedef7() throws IOException, URISyntaxException {
      compileAndCompare("typedef-7.c");
   }

   @Test
   public void testTypedef6() throws IOException, URISyntaxException {
      compileAndCompare("typedef-6.c");
   }

   @Test
   public void testTypedef5() throws IOException, URISyntaxException {
      compileAndCompare("typedef-5.c");
   }

   @Test
   public void testTypedef4() throws IOException, URISyntaxException {
      compileAndCompare("typedef-4.c");
   }

   @Test
   public void testTypedef3() throws IOException, URISyntaxException {
      compileAndCompare("typedef-3.c");
   }

   @Test
   public void testTypedef2() throws IOException, URISyntaxException {
      compileAndCompare("typedef-2.c");
   }

   @Test
   public void testTypedef1() throws IOException, URISyntaxException {
      compileAndCompare("typedef-1.c");
   }

   @Test
   public void testTypedef0() throws IOException, URISyntaxException {
      compileAndCompare("typedef-0.c");
   }

   @Test
   public void testMedusa() throws IOException, URISyntaxException {
      compileAndCompare("complex/medusa/medusa.c");
   }

   @Test
   public void testClearscreen() throws IOException, URISyntaxException {
      compileAndCompare("complex/clearscreen/clearscreen.c");
   }

   // TODO: Optimize unused IRQ's away (and other unused funtions that reference each other circularly)
   @Test
   public void testUnusedIrq() throws IOException, URISyntaxException {
      compileAndCompare("unused-irq.c");
   }


/*
    * TODO: Fix error with number resolving

     @Test public void testNumberTernaryFail2() throws IOException, URISyntaxException {
     compileAndCompare("number-ternary-fail-2.c");
     }
     @Test public void testNumberTernaryFail() throws IOException, URISyntaxException {
     compileAndCompare("number-ternary-fail.c");
     }

   @Test public void testNumberTernaryFail3() throws IOException, URISyntaxException {
      compileAndCompare("number-ternary-fail-3.c");
   }

 */


   @Test
   public void testTextbox() throws IOException, URISyntaxException {
      compileAndCompare("textbox.c");
   }

   @Test
   public void testInitializer0() throws IOException, URISyntaxException {
      compileAndCompare("initializer-0.c");
   }

   @Test
   public void testInitializer1() throws IOException, URISyntaxException {
      compileAndCompare("initializer-1.c");
   }

   @Test
   public void testInitializer2() throws IOException, URISyntaxException {
      compileAndCompare("initializer-2.c");
   }

   @Test
   public void testInitializer3() throws IOException, URISyntaxException {
      compileAndCompare("initializer-3.c");
   }

   /*
   @Test
   public void testProblemInlineStructReturn() throws IOException, URISyntaxException {
      compileAndCompare("problem-inline-struct-return.c", log().verboseCreateSsa());
   }
   */

   @Test
   public void testStructError6() throws IOException, URISyntaxException {
      assertError("struct-error-6.c", "Value list cannot initialize type");
   }

   @Test
   public void testStructPtr34() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-34.c");
   }

   @Test
   public void testStructPtr33() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-33.c");
   }

   @Test
   public void testStructPtr32() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-32.c");
   }

   @Test
   public void testStructPtr31() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-31.c");
   }

   @Test
   public void testStructPtr30() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-30.c");
   }

   // TODO: Fix problem with structs containing pointer elements
   //@Test
   //public void testStructPtr29() throws IOException, URISyntaxException {
   //   compileAndCompare("struct-ptr-29.c");
   //}

   @Test
   public void testStructPtr28() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-28.c");
   }

   @Test
   public void testStructPtr26() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-26.c");
   }

   @Test
   public void testStructPtr25() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-25.c");
   }

   @Test
   public void testStructPtr24() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-24.c");
   }

   @Test
   public void testStructPtr23() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-23.c");
   }

   @Test
   public void testStructPtr22() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-22.c");
   }

   @Test
   public void testStructPtr21() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-21.c");
   }

   @Test
   public void testStructPtr20() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-20.c");
   }

   @Test
   public void testStructPtr19() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-19.c");
   }

   @Test
   public void testStructPtr18() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-18.c");
   }

   @Test
   public void testStructPtr17() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-17.c");
   }

   @Test
   public void testStructPtr16() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-16.c");
   }

   @Test
   public void testStructPtr15() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-15.c");
   }

   @Test
   public void testStructPtr14() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-14.c");
   }

   @Test
   public void testStructPtr13() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-13.c");
   }

   @Test
   public void testStructPtr12Ref() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-12-ref.c");
   }

   @Test
   public void testStructPtr12() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-12.c");
   }

   @Test
   public void testStructPtr11() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-11.c");
   }

   @Test
   public void testStructPtr10() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-10.c");
   }

   @Test
   public void testStructPtr9() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-9.c");
   }

   @Test
   public void testStructPtr8() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-8.c");
   }

   @Test
   public void testStructPtr7() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-7.c");
   }

   @Test
   public void testStructPtr6() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-6.c");
   }

   @Test
   public void testStructPtr5() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-5.c");
   }

   @Test
   public void testStructPtr4() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-4.c");
   }

   @Test
   public void testStructPtr3() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-3.c");
   }

   @Test
   public void testStructPtr2() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-2.c");
   }

   @Test
   public void testStructPtr1() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-1.c");
   }

   @Test
   public void testStructPtr0() throws IOException, URISyntaxException {
      compileAndCompare("struct-ptr-0.c");
   }

   @Test
   public void testStructError5() throws IOException, URISyntaxException {
      assertError("struct-err-5.c", "Unknown struct member");
   }

   @Test
   public void testStructError4() throws IOException, URISyntaxException {
      assertError("struct-err-4.c", "Unknown struct member");
   }

   @Test
   public void testStructError3() throws IOException, URISyntaxException {
      assertError("struct-err-3.c", "Parameters type mismatch in call");
   }

   @Test
   public void testStructError2() throws IOException, URISyntaxException {
      assertError("struct-err-2.c", "Type mismatch");
   }

   @Test
   public void testStructError1() throws IOException, URISyntaxException {
      assertError("struct-err-1.c", "Type mismatch");
   }

   @Test
   public void testStructError0() throws IOException, URISyntaxException {
      assertError("struct-err-0.c", "Unknown struct type");
   }


   @Test
   public void testStructDirectives() throws IOException, URISyntaxException {
      compileAndCompare("struct-directives.c");
   }

   @Test
   public void testStruct42() throws IOException, URISyntaxException {
      compileAndCompare("struct-42.c");
   }

   @Test
   public void testStruct41() throws IOException, URISyntaxException {
      compileAndCompare("struct-41.c");
   }

   @Test
   public void testStruct40() throws IOException, URISyntaxException {
      compileAndCompare("struct-40.c");
   }

   @Test
   public void testStruct39() throws IOException, URISyntaxException {
      compileAndCompare("struct-39.c");
   }

   @Test
   public void testStruct38() throws IOException, URISyntaxException {
      compileAndCompare("struct-38.c");
   }

   @Test
   public void testStruct37() throws IOException, URISyntaxException {
      compileAndCompare("struct-37.c");
   }

   @Test
   public void testStruct36() throws IOException, URISyntaxException {
      compileAndCompare("struct-36.c");
   }

   @Test
   public void testStruct35() throws IOException, URISyntaxException {
      compileAndCompare("struct-35.c");
   }

   @Test
   public void testStruct34() throws IOException, URISyntaxException {
      compileAndCompare("struct-34.c");
   }

   @Test
   public void testStruct33() throws IOException, URISyntaxException {
      compileAndCompare("struct-33.c");
   }

   @Test
   public void testStruct32() throws IOException, URISyntaxException {
      compileAndCompare("struct-32.c");
   }

   @Test
   public void testStruct31() throws IOException, URISyntaxException {
      compileAndCompare("struct-31.c");
   }

   @Test
   public void testStruct30() throws IOException, URISyntaxException {
      compileAndCompare("struct-30.c");
   }

   @Test
   public void testStruct29() throws IOException, URISyntaxException {
      compileAndCompare("struct-29.c");
   }

   @Test
   public void testStruct28() throws IOException, URISyntaxException {
      compileAndCompare("struct-28.c");
   }

   @Test
   public void testStruct27() throws IOException, URISyntaxException {
      compileAndCompare("struct-27.c");
   }

   @Test
   public void testStruct26() throws IOException, URISyntaxException {
      compileAndCompare("struct-26.c");
   }

   @Test
   public void testStruct25() throws IOException, URISyntaxException {
      compileAndCompare("struct-25.c");
   }

   @Test
   public void testStruct24() throws IOException, URISyntaxException {
      compileAndCompare("struct-24.c");
   }

   @Test
   public void testStruct23() throws IOException, URISyntaxException {
      compileAndCompare("struct-23.c");
   }

   @Test
   public void testStruct22() throws IOException, URISyntaxException {
      compileAndCompare("struct-22.c");
   }

   @Test
   public void testStruct21() throws IOException, URISyntaxException {
      compileAndCompare("struct-21.c");
   }

   @Test
   public void testStruct20() throws IOException, URISyntaxException {
      compileAndCompare("struct-20.c");
   }

   @Test
   public void testStruct19() throws IOException, URISyntaxException {
      compileAndCompare("struct-19.c");
   }

   @Test
   public void testStruct18() throws IOException, URISyntaxException {
      compileAndCompare("struct-18.c");
   }

   @Test
   public void testStruct17() throws IOException, URISyntaxException {
      compileAndCompare("struct-17.c");
   }

   @Test
   public void testStruct16() throws IOException, URISyntaxException {
      compileAndCompare("struct-16.c");
   }

   @Test
   public void testStruct15() throws IOException, URISyntaxException {
      compileAndCompare("struct-15.c");
   }

   @Test
   public void testStruct14() throws IOException, URISyntaxException {
      compileAndCompare("struct-14.c");
   }

   @Test
   public void testStruct13() throws IOException, URISyntaxException {
      compileAndCompare("struct-13.c");
   }

   @Test
   public void testStruct12() throws IOException, URISyntaxException {
      compileAndCompare("struct-12.c");
   }

   @Test
   public void testStruct11b() throws IOException, URISyntaxException {
      compileAndCompare("struct-11b.c");
   }

   @Test
   public void testStruct11() throws IOException, URISyntaxException {
      compileAndCompare("struct-11.c");
   }

   @Test
   public void testStruct10() throws IOException, URISyntaxException {
      compileAndCompare("struct-10.c");
   }

   @Test
   public void testStruct9() throws IOException, URISyntaxException {
      compileAndCompare("struct-9.c");
   }

   @Test
   public void testStruct8() throws IOException, URISyntaxException {
      compileAndCompare("struct-8.c");
   }

   @Test
   public void testStruct7() throws IOException, URISyntaxException {
      compileAndCompare("struct-7.c");
   }

   @Test
   public void testStruct6() throws IOException, URISyntaxException {
      compileAndCompare("struct-6.c");
   }

   @Test
   public void testStruct5() throws IOException, URISyntaxException {
      compileAndCompare("struct-5.c");
   }

   @Test
   public void testStruct4() throws IOException, URISyntaxException {
      compileAndCompare("struct-4.c");
   }

   @Test
   public void testStruct3() throws IOException, URISyntaxException {
      compileAndCompare("struct-3.c");
   }

   @Test
   public void testStruct2() throws IOException, URISyntaxException {
      compileAndCompare("struct-2.c");
   }

   @Test
   public void testStruct1() throws IOException, URISyntaxException {
      compileAndCompare("struct-1.c");
   }

   @Test
   public void testStruct0() throws IOException, URISyntaxException {
      compileAndCompare("struct-0.c");
   }

   @Test
   public void testSequenceLocality1() throws IOException, URISyntaxException {
      compileAndCompare("sequence-locality-1.c");
   }

   @Test
   public void testSequenceLocality0() throws IOException, URISyntaxException {
      compileAndCompare("sequence-locality-0.c");
   }

   @Test
   public void testVoidParameter() throws IOException, URISyntaxException {
      compileAndCompare("void-parameter.c");
   }

   @Test
   public void testConditionInteger4() throws IOException, URISyntaxException {
      compileAndCompare("condition-integer-4.c");
   }

   @Test
   public void testConditionInteger3() throws IOException, URISyntaxException {
      compileAndCompare("condition-integer-3.c");
   }

   @Test
   public void testConditionInteger2() throws IOException, URISyntaxException {
      compileAndCompare("condition-integer-2.c");
   }

   @Test
   public void testConditionInteger1() throws IOException, URISyntaxException {
      compileAndCompare("condition-integer-1.c");
   }

   @Test
   public void testConditionInteger0() throws IOException, URISyntaxException {
      compileAndCompare("condition-integer-0.c");
   }

   @Test
   public void testStringUnknownEncoding() throws IOException, URISyntaxException {
      assertError("string-encoding-unknown.c", "Unknown string encoding");
   }

   @Test
   public void testStringEncodingMixError() throws IOException, URISyntaxException {
      assertError("string-encoding-mix-error.c", "Cannot mix encodings in concatenated strings");
   }

   @Test
   public void testStringEncodingPragma() throws IOException, URISyntaxException {
      compileAndCompare("string-encoding-pragma.c");
   }

   @Test
   public void testStringEncodingLiterals() throws IOException, URISyntaxException {
      compileAndCompare("string-encoding-literals.c");
   }

   @Test
   public void testRobozzleLabelProblem() throws IOException, URISyntaxException {
      compileAndCompare("robozzle64-label-problem.c");
   }

   @Test
   public void testGlobalPc() throws IOException, URISyntaxException {
      compileAndCompare("global-pc.c");
   }

   @Test
   public void testNoopCastElimination() throws IOException, URISyntaxException {
      compileAndCompare("noop-cast-elimination.c");
   }

   @Test
   public void testSignedWordMinusByte2() throws IOException, URISyntaxException {
      compileAndCompare("signed-word-minus-byte-2.c");
   }

   @Test
   public void testForTwoVars() throws IOException, URISyntaxException {
      compileAndCompare("for-two-vars.c");
   }

   @Test
   public void testC64DtvGfxExplorer() throws IOException, URISyntaxException {
      compileAndCompare("c64dtv-gfxexplorer.c", 10);
   }

   @Test
   public void testC64DtvGfxModes() throws IOException, URISyntaxException {
      compileAndCompare("c64dtv-gfxmodes.c", 10);
   }

   @Test
   public void testConstantStringConcat0() throws IOException, URISyntaxException {
      compileAndCompare("constant-string-concat-0.c");
   }

   @Test
   public void testLiterals() throws IOException, URISyntaxException {
      compileAndCompare("literals.c");
   }

   @Test
   public void testConstantStringConcat() throws IOException, URISyntaxException {
      compileAndCompare("constant-string-concat.c");
   }

   @Test
   public void testStatementSequence1() throws IOException, URISyntaxException {
      compileAndCompare("statement-sequence-1.c");
   }

   @Test
   public void testSubExprOptimize4() throws IOException, URISyntaxException {
      compileAndCompare("subexpr-optimize-4.c");
   }

   @Test
   public void testSubExprOptimize3() throws IOException, URISyntaxException {
      compileAndCompare("subexpr-optimize-3.c");
   }

   @Test
   public void testSubExprOptimize2() throws IOException, URISyntaxException {
      compileAndCompare("subexpr-optimize-2.c");
   }

   @Test
   public void testSubExprOptimize1() throws IOException, URISyntaxException {
      compileAndCompare("subexpr-optimize-1.c");
   }

   @Test
   public void testSubExprOptimize0() throws IOException, URISyntaxException {
      compileAndCompare("subexpr-optimize-0.c");
   }

   @Test
   public void testPtrPtrOptimize2() throws IOException, URISyntaxException {
      compileAndCompare("ptrptr-optimize-2.c");
   }

   @Test
   public void testPtrPtrOptimize1() throws IOException, URISyntaxException {
      compileAndCompare("ptrptr-optimize-1.c");
   }

   @Test
   public void testPtrPtrOptimize0() throws IOException, URISyntaxException {
      compileAndCompare("ptrptr-optimize-0.c");
   }

   @Test
   public void testHex2DecPtrPtr() throws IOException, URISyntaxException {
      compileAndCompare("hex2dec-ptrptr.c");
   }

   @Test
   public void testHex2Dec() throws IOException, URISyntaxException {
      compileAndCompare("hex2dec.c");
   }

   @Test
   public void testMemoryHeap() throws IOException, URISyntaxException {
      compileAndCompare("memory-heap.c");
   }

   @Test
   public void testMalloc1() throws IOException, URISyntaxException {
      compileAndCompare("malloc-1.c");
   }

   @Test
   public void testMalloc0() throws IOException, URISyntaxException {
      compileAndCompare("malloc-0.c");
   }

   @Test
   public void testTernaryInference() throws IOException, URISyntaxException {
      compileAndCompare("ternary-inference.c");
   }

   @Test
   public void testMul8uMin() throws IOException, URISyntaxException {
      compileAndCompare("mul8u-min.c");
   }

   @Test
   public void testNumberInferenceSum() throws IOException, URISyntaxException {
      compileAndCompare("number-inference-sum.c");
   }

   @Test
   public void testGfxBankOptimization() throws IOException, URISyntaxException {
      compileAndCompare("gfxbank.c");
   }

   @Test
   public void testDoubleIndexingArrays() throws IOException, URISyntaxException {
      compileAndCompare("double-indexing-arrays.c");
   }

   @Test
   public void testDerefidxWord2() throws IOException, URISyntaxException {
      compileAndCompare("derefidx-word-2.c");
   }

   @Test
   public void testDerefidxWord1() throws IOException, URISyntaxException {
      compileAndCompare("derefidx-word-1.c");
   }

   @Test
   public void testDerefidxWord0() throws IOException, URISyntaxException {
      compileAndCompare("derefidx-word-0.c");
   }

   @Test
   public void testFragmentVariations() throws IOException, URISyntaxException {
      compileAndCompare("fragment-variations.c");
   }

   // TODO: Fix call parameter type conversion (See SymbolTypeConversion) https://gitlab.com/camelot/kickc/issues/283
   /*
   @Test
   public void testTypePromotionScharParam() throws IOException, URISyntaxException {
      compileAndCompare("type-promotion-schar-param.c");
   }

   @Test
   public void testTypePromotionBoolParam() throws IOException, URISyntaxException {
      compileAndCompare("type-promotion-bool-param.c");
   }
   */

   @Test
   public void testTypeInference() throws IOException, URISyntaxException {
      compileAndCompare("type-inference.c");
   }

   @Test
   public void testMixedArray1() throws IOException, URISyntaxException {
      compileAndCompare("mixed-array-1.c");
   }

   @Test
   public void testMixedArray0() throws IOException, URISyntaxException {
      compileAndCompare("mixed-array-0.c");
   }

   @Test
   public void testInlinePointer2() throws IOException, URISyntaxException {
      compileAndCompare("inline-pointer-2.c");
   }

   @Test
   public void testInlinePointer1() throws IOException, URISyntaxException {
      compileAndCompare("inline-pointer-1.c");
   }

   @Test
   public void testInlinePointer0() throws IOException, URISyntaxException {
      compileAndCompare("inline-pointer-0.c");
   }

   @Test
   public void testToD018Problem() throws IOException, URISyntaxException {
      compileAndCompare("tod018-problem.c");
   }

   @Test
   public void testHelloWorld0() throws IOException, URISyntaxException {
      compileAndCompare("helloworld0.c");
   }

   @Test
   public void testNumberConversion() throws IOException, URISyntaxException {
      compileAndCompare("number-conversion.c");
   }

   @Test
   public void testNumberType() throws IOException, URISyntaxException {
      compileAndCompare("number-type.c");
   }

   @Test
   public void testIntegerConversion() throws IOException, URISyntaxException {
      compileAndCompare("int-conversion.c");
   }

   @Test
   public void testIntegerLiterals() throws IOException, URISyntaxException {
      compileAndCompare("int-literals.c");
   }

   @Test
   public void testSimpleLoop() throws IOException, URISyntaxException {
      compileAndCompare("simple-loop.c");
   }

   @Test
   public void testLiteralCharMinusNumber() throws IOException, URISyntaxException {
      compileAndCompare("literal-char-minus-number.c");
   }

   @Test
   public void testPaulNelsenSandboxTernaryError() throws IOException, URISyntaxException {
      compileAndCompare("sandbox-ternary-error.c");
   }

   @Test
   public void testPaulNelsenSandbox() throws IOException, URISyntaxException {
      compileAndCompare("sandbox.c");
   }

   @Test
   public void testPointerConstDeep() throws IOException, URISyntaxException {
      assertError("pointer-const-deep.c", "Deep const/volatile not supported");
   }

   @Test
   public void testPointerConst() throws IOException, URISyntaxException {
      compileAndCompare("pointer-const.c");
   }

   @Test
   public void testPointerCast4() throws IOException, URISyntaxException {
      compileAndCompare("pointer-cast-4.c");
   }

   @Test
   public void testPointerCast3() throws IOException, URISyntaxException {
      compileAndCompare("pointer-cast-3.c");
   }

   @Test
   public void testTypeIdPlusByteProblem() throws IOException, URISyntaxException {
      compileAndCompare("typeid-plus-byte-problem.c");
   }

   @Test
   public void testTypeIdPlusBytes() throws IOException, URISyntaxException {
      compileAndCompare("typeid-plus-bytes.c");
   }

   @Test
   public void testTypeIdSimple() throws IOException, URISyntaxException {
      compileAndCompare("typeid-simple.c");
   }

   @Test
   public void testTypeSigned() throws IOException, URISyntaxException {
      compileAndCompare("type-signed.c");
   }

   @Test
   public void testConstIntCastProblem() throws IOException, URISyntaxException {
      compileAndCompare("const-int-cast-problem.c");
   }

   @Test
   public void testPointerPlus0() throws IOException, URISyntaxException {
      compileAndCompare("pointer-plus-0.c");
   }

   @Test
   public void testDerefToDerefIdx2() throws IOException, URISyntaxException {
      compileAndCompare("deref-to-derefidx-2.c");
   }

   @Test
   public void testDerefToDerefIdx() throws IOException, URISyntaxException {
      compileAndCompare("deref-to-derefidx.c");
   }

   @Test
   public void testSemiStruct2() throws IOException, URISyntaxException {
      compileAndCompare("semi-struct-2.c");
   }

   @Test
   public void testSemiStruct1() throws IOException, URISyntaxException {
      compileAndCompare("semi-struct-1.c");
   }

   @Test
   public void testStrip() throws IOException, URISyntaxException {
      compileAndCompare("strip.c");
   }

   @Test
   public void testReserveZpGlobal() throws IOException, URISyntaxException {
      compileAndCompare("reserve-zp-global.c");
   }

   @Test
   public void testReserveZpProcedure3() throws IOException, URISyntaxException {
      compileAndCompare("reserve-zp-procedure-3.c");
   }

   @Test
   public void testReserveZpProcedure2() throws IOException, URISyntaxException {
      compileAndCompare("reserve-zp-procedure-2.c");
   }

   @Test
   public void testReserveZpProcedure1() throws IOException, URISyntaxException {
      compileAndCompare("reserve-zp-procedure-1.c");
   }

   @Test
   public void testWordPointerCompound() throws IOException, URISyntaxException {
      compileAndCompare("word-pointer-compound.c");
   }

   @Test
   public void testWordPointerMath() throws IOException, URISyntaxException {
      compileAndCompare("word-pointer-math.c");
   }

   @Test
   public void testWordPointerMath1() throws IOException, URISyntaxException {
      compileAndCompare("word-pointer-math-1.c");
   }

   @Test
   public void testWordPointerMath0() throws IOException, URISyntaxException {
      compileAndCompare("word-pointer-math-0.c");
   }

   @Test
   public void testWordPointerIteration() throws IOException, URISyntaxException {
      compileAndCompare("word-pointer-iteration.c");
   }

   @Test
   public void testWordPointerIteration0() throws IOException, URISyntaxException {
      compileAndCompare("word-pointer-iteration-0.c");
   }

   @Test
   public void testWordArray2() throws IOException, URISyntaxException {
      compileAndCompare("word-array-2.c");
   }

   @Test
   public void testWordArray1() throws IOException, URISyntaxException {
      compileAndCompare("word-array-1.c");
   }

   @Test
   public void testWordArray0() throws IOException, URISyntaxException {
      compileAndCompare("word-array-0.c");
   }

   @Test
   public void testSizeofStruct() throws IOException, URISyntaxException {
      compileAndCompare("sizeof-struct.c");
   }

   @Test
   public void testSizeofArrays() throws IOException, URISyntaxException {
      compileAndCompare("sizeof-arrays.c");
   }

   @Test
   public void testSizeofExpression() throws IOException, URISyntaxException {
      compileAndCompare("sizeof-expr.c");
   }

   @Test
   public void testSizeofTypes() throws IOException, URISyntaxException {
      compileAndCompare("sizeof-types.c");
   }

   @Test
   public void testCommaDeclFor() throws IOException, URISyntaxException {
      compileAndCompare("comma-decl-for.c");
   }

   @Test
   public void testCommaDecl2() throws IOException, URISyntaxException {
      compileAndCompare("comma-decl-2.c");
   }

   @Test
   public void testCommaDecl() throws IOException, URISyntaxException {
      compileAndCompare("comma-decl.c");
   }

   @Test
   public void testCommaExprFor() throws IOException, URISyntaxException {
      compileAndCompare("comma-expr-for.c");
   }

   @Test
   public void testCommaExpr2() throws IOException, URISyntaxException {
      compileAndCompare("comma-expr-2.c");
   }

   @Test
   public void testCommaExpr1() throws IOException, URISyntaxException {
      compileAndCompare("comma-expr-1.c");
   }

   @Test
   public void testForRangedNoVar() throws IOException, URISyntaxException {
      assertError("for-ranged-novar.c", "extraneous input");
   }

   @Test
   public void testForEmptyInit() throws IOException, URISyntaxException {
      compileAndCompare("for-empty-init.c");
   }

   @Test
   public void testForEmptyIncrement() throws IOException, URISyntaxException {
      compileAndCompare("for-empty-increment.c");
   }

   @Test
   public void testDivide2s() throws IOException, URISyntaxException {
      compileAndCompare("divide-2s.c");
   }

   @Test
   public void testMultiply2s() throws IOException, URISyntaxException {
      compileAndCompare("multiply-2s.c");
   }

   @Test
   public void testMultiplyNs() throws IOException, URISyntaxException {
      compileAndCompare("multiply-ns.c");
   }

   @Test
   public void testPointerCast2() throws IOException, URISyntaxException {
      compileAndCompare("pointer-cast-2.c");
   }

   @Test
   public void testPointerCast() throws IOException, URISyntaxException {
      compileAndCompare("pointer-cast.c");
   }

   // TODO: Fix literal string array initialization. https://gitlab.com/camelot/kickc/issues/297
   /*
   @Test
   public void testLiteralStringArray() throws IOException, URISyntaxException {
      compileAndCompare("literal-string-array.c");
   }
    */

   @Test
   public void testLiteralWordPointer0() throws IOException, URISyntaxException {
      compileAndCompare("literal-word-pointer-0.c");
   }

   // TODO: Fix casting literal char* to word https://gitlab.com/camelot/kickc/issues/298
   /*
   @Test
   public void testLiteralWordPointer1() throws IOException, URISyntaxException {
      compileAndCompare("literal-word-pointer-1.c");
   }
    */

   @Test
   public void testLiteralStrings() throws IOException, URISyntaxException {
      compileAndCompare("literal-strings.c");
   }

   @Test
   public void testIllegalVoidParameter() throws IOException, URISyntaxException {
      assertError("illegal-void-parameter.c", "Illegal void parameter");
   }

   @Test
   public void testIllegalUnnamedParameter() throws IOException, URISyntaxException {
      assertError("illegal-unnamed-parameter.c", "Illegal unnamed parameter");
   }

   @Test
   public void testFire() throws IOException, URISyntaxException {
      compileAndCompare("examples/fire/fire.c");
   }

   @Test
   public void testFont2x2() throws IOException, URISyntaxException {
      compileAndCompare("examples/font-2x2/font-2x2.c");
   }

   @Test
   public void testCTypes() throws IOException, URISyntaxException {
      compileAndCompare("c-types.c");
   }

   @Test
   public void testPlus0() throws IOException, URISyntaxException {
      compileAndCompare("plus-0.c");
   }

   @Test
   public void testPlasmaUnroll() throws IOException, URISyntaxException {
      compileAndCompare("examples/plasma/plasma-unroll.c");
   }

   @Test
   public void testPlasma() throws IOException, URISyntaxException {
      compileAndCompare("examples/plasma/plasma.c");
   }

   // TODO: Fix bool auto-conversion type conversion https://gitlab.com/camelot/kickc/issues/199
   /*
   @Test
   public void testBoolNotOperator3() throws IOException, URISyntaxException {
      compileAndCompare("bool-not-operator-3.c");
   }
   */

   // TODO: Fix number type conversion https://gitlab.com/camelot/kickc/issues/199
   /*
   @Test
   public void testTernary4() throws IOException, URISyntaxException {
      compileAndCompare("ternary-4.c");
   }

   @Test
   public void testBoolNotOperator1() throws IOException, URISyntaxException {
      compileAndCompare("bool-not-operator-1.c");
   }

   @Test
   public void testBoolNotOperator2() throws IOException, URISyntaxException {
      compileAndCompare("bool-not-operator-2.c");
   }
   */

   @Test
   public void testTernary3() throws IOException, URISyntaxException {
      compileAndCompare("ternary-3.c");
   }

   @Test
   public void testTernary2() throws IOException, URISyntaxException {
      compileAndCompare("ternary-2.c");
   }

   @Test
   public void testTernary1() throws IOException, URISyntaxException {
      compileAndCompare("ternary-1.c");
   }

   @Test
   public void testPointerPointer3() throws IOException, URISyntaxException {
      compileAndCompare("pointer-pointer-3.c");
   }

   @Test
   public void testPointerPointer2() throws IOException, URISyntaxException {
      compileAndCompare("pointer-pointer-2.c");
   }

   @Test
   public void testPointerPointer1() throws IOException, URISyntaxException {
      compileAndCompare("pointer-pointer-1.c");
   }

   @Test
   public void testFunctionPointerNoargCall10() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-10.c");
   }

   @Test
   public void testFunctionPointerNoargCall9() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-9.c");
   }

   @Test
   public void testFunctionPointerNoargCall8() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-8.c");
   }

   @Test
   public void testFunctionPointerNoargCall7() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-7.c");
   }

   @Test
   public void testFunctionPointerNoargCall6() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-6.c");
   }

   @Test
   public void testFunctionPointerNoargCall5() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-5.c");
   }

   @Test
   public void testFunctionPointerNoargCall4() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-4.c");
   }

   @Test
   public void testFunctionPointerNoargCall3() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-3.c");
   }

   @Test
   public void testFunctionPointerNoargCall2() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call-2.c");
   }

   @Test
   public void testFunctionPointerNoargCall() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-call.c");
   }

   @Test
   public void testFunctionPointerReturn() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-return.c");
   }

   @Test
   public void testFunctionPointerNoarg3() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-3.c");
   }

   @Test
   public void testFunctionPointerNoarg2() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg-2.c");
   }

   @Test
   public void testFunctionPointerNoarg() throws IOException, URISyntaxException {
      compileAndCompare("function-pointer-noarg.c");
   }

   @Test
   public void testComparisonRewriting() throws IOException, URISyntaxException {
      compileAndCompare("comparison-rewriting.c");
   }

   @Test
   public void testComparisonRewritingPointer() throws IOException, URISyntaxException {
      compileAndCompare("comparison-rewriting-pointer.c");
   }

   @Test
   public void testLoopBreakContinue() throws IOException, URISyntaxException {
      compileAndCompare("loop-break-continue.c");
   }

   @Test
   public void testLoopForEmptyBody() throws IOException, URISyntaxException {
      compileAndCompare("loop-for-empty-body.c");
   }

   @Test
   public void testLoopForContinue() throws IOException, URISyntaxException {
      compileAndCompare("loop-for-continue.c");
   }

   @Test
   public void testLoopWhileContinue() throws IOException, URISyntaxException {
      compileAndCompare("loop-while-continue.c");
   }

   @Test
   public void testLoopContinue() throws IOException, URISyntaxException {
      compileAndCompare("loop-continue.c");
   }

   @Test
   public void testLoopBreakNested() throws IOException, URISyntaxException {
      compileAndCompare("loop-break-nested.c");
   }

   @Test
   public void testLoopBreak() throws IOException, URISyntaxException {
      compileAndCompare("loop-break.c");
   }

   @Test
   public void testLocalScopeLoops() throws IOException, URISyntaxException {
      compileAndCompare("localscope-loops.c");
   }

   @Test
   public void testLocalScopeSimple() throws IOException, URISyntaxException {
      compileAndCompare("localscope-simple.c");
   }

   @Test
   public void testIrqLocalVarOverlap() throws IOException, URISyntaxException {
      compileAndCompare("irq-local-var-overlap-problem.c");
   }

   @Test
   public void testMultiplexerIrq() throws IOException, URISyntaxException {
      compileAndCompare("multiplexer-irq/simple-multiplexer-irq.c", 10);
   }

   @Test
   public void testIrqVolatileProblem() throws IOException, URISyntaxException {
      compileAndCompare("irq-volatile-bool-problem.c");
   }

   @Test
   public void testMusicIrq() throws IOException, URISyntaxException {
      compileAndCompare("examples/music/music_irq.c");
   }

   @Test
   public void testMusic() throws IOException, URISyntaxException {
      compileAndCompare("examples/music/music.c");
   }

   @Test
   public void testConstEarlyIdentification() throws IOException, URISyntaxException {
      compileAndCompare("const-early-identification.c");
   }

   @Test
   public void testBoolNullPointerException() throws IOException, URISyntaxException {
      compileAndCompare("bool-nullpointer-exception.c");
   }

   @Test
   public void testSignedWordMinusByte() throws IOException, URISyntaxException {
      compileAndCompare("test-signed-word-minus-byte.c");
   }

   @Test
   public void testIrqIdxProblem() throws IOException, URISyntaxException {
      compileAndCompare("irq-idx-problem.c");
   }

   @Test
   public void testInlineKickAsmClobber() throws IOException, URISyntaxException {
      compileAndCompare("inline-kasm-clobber.c");
   }


   @Test
   public void testInlineAsmClobberNone() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-clobber-none.c");
   }

   @Test
   public void testInlineAsmJsrClobber() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-jsr-clobber.c");
   }

   @Test
   public void testComplexConditionalProblem() throws IOException, URISyntaxException {
      compileAndCompare("complex-conditional-problem.c");
   }

   @Test
   public void testConstSignedPromotion() throws IOException, URISyntaxException {
      compileAndCompare("const-signed-promotion.c");
   }

   @Test
   public void testSignedIndexedSubtract() throws IOException, URISyntaxException {
      compileAndCompare("signed-indexed-subtract.c");
   }

   @Test
   public void testInlineAsmRefScoped() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-ref-scoped.c");
   }

   @Test
   public void testInlineAsmRefoutLabel() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-label.c");
   }

   @Test
   public void testInlineAsmRefoutIllegal() throws IOException, URISyntaxException {
      assertError("inline-asm-refout-illegal.c", "Inline ASM reference is not constant");
   }

   @Test
   public void testInlineAsmRefoutConst() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-refout-const.c");
   }

   @Test
   public void testInlineAsmRefoutUndef() throws IOException, URISyntaxException {
      assertError("inline-asm-refout-undef.c", "Unknown variable qwe");
   }

   @Test
   public void testConstIfProblem() throws IOException, URISyntaxException {
      compileAndCompare("const-if-problem.c");
   }

   @Test
   public void testTetrisNullPointer() throws IOException, URISyntaxException {
      compileAndCompare("tetris-npe.c");
   }

   /*
   @Test
   public void testUnrollCall() throws IOException, URISyntaxException {
      compileAndCompare("unroll-call.c");
   }
   */


   @Test
   public void testInlineKasmRefout() throws IOException, URISyntaxException {
      compileAndCompare("inline-kasm-refout.c");
   }

   @Test
   public void testInlineKasmLoop() throws IOException, URISyntaxException {
      compileAndCompare("inline-kasm-loop.c");
   }

   @Test
   public void testInlineKasmData() throws IOException, URISyntaxException {
      compileAndCompare("inline-kasm-data.c");
   }

   @Test
   public void testInlineKasmResource() throws IOException, URISyntaxException {
      compileAndCompare("inline-kasm-resource.c");
   }

   @Test
   public void testInlineAsmRefout() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-refout.c");
   }

   @Test
   public void testInlineAsmOptimized() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-optimized.c");
   }

   @Test
   public void testCastNotNeeded2() throws IOException, URISyntaxException {
      compileAndCompare("cast-not-needed-2.c");
   }

   @Test
   public void testCastNotNeeded3() throws IOException, URISyntaxException {
      compileAndCompare("cast-not-needed-3.c");
   }

   @Test
   public void testCastNotNeeded() throws IOException, URISyntaxException {
      compileAndCompare("cast-not-needed.c");
   }

   @Test
   public void testTypeMix() throws IOException, URISyntaxException {
      compileAndCompare("type-mix.c");
   }

   @Test
   public void testClobberProblem() throws IOException, URISyntaxException {
      compileAndCompare("scrollbig-clobber.c");
   }

   @Test
   public void testComparisonsSWord() throws IOException, URISyntaxException {
      compileAndCompare("test-comparisons-sword.c");
   }

   @Test
   public void testComparisonsWord() throws IOException, URISyntaxException {
      compileAndCompare("test-comparisons-word.c");
   }

   @Test
   public void testDuplicateLoopProblem() throws IOException, URISyntaxException {
      compileAndCompare("duplicate-loop-problem.c");
   }

   @Test
   public void testUseUninitialized() throws IOException, URISyntaxException {
      compileAndCompare("useuninitialized.c");
   }

   @Test
   public void testIllegalLValue2() throws IOException, URISyntaxException {
      assertError("illegallvalue2.c", "Illegal assignment Lvalue");
   }

   @Test
   public void testWordFragment1() throws IOException, URISyntaxException {
      compileAndCompare("wfragment1.c");
   }

   @Test
   public void testTravis1() throws IOException, URISyntaxException {
      compileAndCompare("travis1.c");
   }

   @Test
   public void testUninitialized() throws IOException, URISyntaxException {
      compileAndCompare("uninitialized.c");
   }

   @Test
   public void testStringConstConsolidationNoRoot() throws IOException, URISyntaxException {
      compileAndCompare("string-const-consolidation-noroot.c");
   }

   @Test
   public void testStringConstConsolidation() throws IOException, URISyntaxException {
      compileAndCompare("string-const-consolidation.c");
   }

   @Test
   public void testCommentsBlock() throws IOException, URISyntaxException {
      compileAndCompare("test-comments-block.c");
   }

   @Test
   public void testCommentsLoop() throws IOException, URISyntaxException {
      compileAndCompare("test-comments-loop.c");
   }

   @Test
   public void testCommentsSingle() throws IOException, URISyntaxException {
      compileAndCompare("test-comments-single.c");
   }

   @Test
   public void testCommentsUsage() throws IOException, URISyntaxException {
      compileAndCompare("test-comments-usage.c");
   }

   @Test
   public void testBgBlack() throws IOException, URISyntaxException {
      compileAndCompare("bgblack.c");
   }

   @Test
   public void testNoRecursionHeavy() throws IOException, URISyntaxException {
      compileAndCompare("no-recursion-heavy.c");
   }

   @Test
   public void testScrollUp() throws IOException, URISyntaxException {
      compileAndCompare("test-scroll-up.c");
   }

   @Test
   public void testRollSpriteMsb() throws IOException, URISyntaxException {
      compileAndCompare("roll-sprite-msb.c");
   }

   @Test
   public void testRollVariable() throws IOException, URISyntaxException {
      compileAndCompare("roll-variable.c");
   }

   @Test
   public void testWordsizeArrays() throws IOException, URISyntaxException {
      compileAndCompare("test-word-size-arrays.c");
   }

   @Test
   public void testRuntimeUnusedProcedure() throws IOException, URISyntaxException {
      compileAndCompare("runtime-unused-procedure.c");
   }

   //@Test
   //public void testRobozzle64() throws IOException, URISyntaxException {
   //   compileAndCompare("complex/robozzle_c64/robozzle64.c", log().verboseSSAOptimize().verboseLoopUnroll());
   //}

   //@Test
   //public void testTravisGame() throws IOException, URISyntaxException {
   //   compileAndCompare("complex/travis/game.c");
   //}

   //@Test
   //public void testBcmod() throws IOException, URISyntaxException {
   //   compileAndCompare("complex/bcmod/bcmod5h.c", log());
   //}

   //@Test
   //public void testBcmod5hb() throws IOException, URISyntaxException {
   //   compileAndCompare("complex/bcmod/bcmod5hb.c", log());
   //}

   @Test
   public void testTetrisSprites() throws IOException, URISyntaxException {
      compileAndCompare("complex/tetris/test-sprites.c");
   }

   @Test
   public void testTetris() throws IOException, URISyntaxException {
      compileAndCompare("complex/tetris/tetris.c");
   }

   @Test
   public void testConsolidateConstantProblem() throws IOException, URISyntaxException {
      compileAndCompare("consolidate-constant-problem.c");
   }

   @Test
   public void testConsolidateArrayIndexProblem() throws IOException, URISyntaxException {
      compileAndCompare("consolidate-array-index-problem.c");
   }

   @Test
   public void testScanDesireProblem() throws IOException, URISyntaxException {
      compileAndCompare("scan-desire-problem.c");
   }

   @Test
   public void testClobberAProblem() throws IOException, URISyntaxException {
      compileAndCompare("clobber-a-problem.c");
   }

   @Test
   public void testInterruptVolatileReuseProblem2() throws IOException, URISyntaxException {
      compileAndCompare("interrupt-volatile-reuse-problem2.c");
   }

   @Test
   public void testInterruptVolatileReuseProblem1() throws IOException, URISyntaxException {
      compileAndCompare("interrupt-volatile-reuse-problem1.c");
   }

   @Test
   public void testInitVolatiles() throws IOException, URISyntaxException {
      compileAndCompare("init-volatiles.c");
   }

   @Test
   public void testInterruptVolatileWrite() throws IOException, URISyntaxException {
      compileAndCompare("test-interrupt-volatile-write.c");
   }

   @Test
   public void testLongbranchInterruptProblem() throws IOException, URISyntaxException {
      compileAndCompare("longbranch-interrupt-problem.c");
   }

   @Test
   public void testVarInitProblem() throws IOException, URISyntaxException {
      compileAndCompare("var-init-problem.c");
   }

   @Test
   public void testFastMultiply8() throws IOException, URISyntaxException {
      compileAndCompare("examples/fastmultiply/fastmultiply8.c");
   }

   @Test
   public void test3DPerspective() throws IOException, URISyntaxException {
      compileAndCompare("examples/3d/perspective.c");
   }

   @Test
   public void test3D() throws IOException, URISyntaxException {
      compileAndCompare("examples/3d/3d.c");
   }

   @Test
   public void testTypeInferenceProblem() throws IOException, URISyntaxException {
      compileAndCompare("typeinference-problem.c");
   }

   @Test
   public void testRotate() throws IOException, URISyntaxException {
      compileAndCompare("examples/rotate/rotate.c");
   }

   @Test
   public void testInfLoopError() throws IOException, URISyntaxException {
      compileAndCompare("infloop-error.c");
   }

   @Test
   public void testMinFastMul16() throws IOException, URISyntaxException {
      compileAndCompare("min-fmul-16.c");
   }

   // Fix literal number type conversion (also over the bitwise NOT operator). https://gitlab.com/camelot/kickc/issues/199
   /*
   @Test
   public void testBitwiseNot1() throws IOException, URISyntaxException {
      compileAndCompare("bitwise-not-1.c");
   }
 */

   @Test
   public void testBitwiseNot() throws IOException, URISyntaxException {
      compileAndCompare("bitwise-not.c");
   }

   @Test
   public void testUnrollInfinite() throws IOException, URISyntaxException {
      assertError("unroll-infinite.c", "Loop cannot be unrolled.", false);
   }

   @Test
   public void testUnusedBlockProblem() throws IOException, URISyntaxException {
      compileAndCompare("unusedblockproblem.c");
   }

   @Test
   public void testUnrollScreenFillForDouble() throws IOException, URISyntaxException {
      compileAndCompare("unroll-screenfill-for-double.c");
   }

   @Test
   public void testUnrollScreenFillFor() throws IOException, URISyntaxException {
      compileAndCompare("unroll-screenfill-for.c");
   }

   @Test
   public void testUnrollScreenFillWhile() throws IOException, URISyntaxException {
      compileAndCompare("unroll-screenfill-while.c");
   }

   @Test
   public void testUnrollModifyVar() throws IOException, URISyntaxException {
      compileAndCompare("unroll-loop-modifyvar.c");
   }

   @Test
   public void testUnrollWhileMin() throws IOException, URISyntaxException {
      compileAndCompare("unroll-while-min.c");
   }

   @Test
   public void testUnrollForMin() throws IOException, URISyntaxException {
      compileAndCompare("unroll-for-min.c");
   }

   @Test
   public void testLoop100() throws IOException, URISyntaxException {
      compileAndCompare("loop100.c");
   }

   @Test
   public void testIrqHardwareClobberJsr() throws IOException, URISyntaxException {
      compileAndCompare("irq-hardware-clobber-jsr.c");
   }

   @Test
   public void testIrqHardwareClobber() throws IOException, URISyntaxException {
      compileAndCompare("irq-hardware-clobber.c");
   }

   @Test
   public void testIrqHardwareStack() throws IOException, URISyntaxException {
      compileAndCompare("irq-hardware-stack.c");
   }

   @Test
   public void testIrqHardware() throws IOException, URISyntaxException {
      compileAndCompare("irq-hardware.c");
   }

   @Test
   public void testIrqKernel() throws IOException, URISyntaxException {
      compileAndCompare("irq-kernel.c");
   }

   @Test
   public void testIrqKernelMinimal() throws IOException, URISyntaxException {
      compileAndCompare("irq-kernel-minimal.c");
   }

   @Test
   public void testIrqHyperscreen() throws IOException, URISyntaxException {
      compileAndCompare("examples/irq/irq-hyperscreen.c");
   }

   @Test
   public void testIrqRaster() throws IOException, URISyntaxException {
      compileAndCompare("irq-raster.c");
   }

   @Test
   public void testInterruptVolatile() throws IOException, URISyntaxException {
      compileAndCompare("test-interrupt-volatile.c");
   }

   @Test
   public void testInterrupt() throws IOException, URISyntaxException {
      compileAndCompare("test-interrupt.c");
   }

   @Test
   public void testInterruptNoType() throws IOException, URISyntaxException {
      compileAndCompare("test-interrupt-notype.c");
   }

   @Test
   public void testMultiplexer() throws IOException, URISyntaxException {
      compileAndCompare("examples/multiplexer/simple-multiplexer.c", 10);
   }

   @Test
   public void testForRangedWords() throws IOException, URISyntaxException {
      compileAndCompare("forrangedwords.c");
   }

   @Test
   public void testArrayLengthSymbolicMin() throws IOException, URISyntaxException {
      compileAndCompare("array-length-symbolic-min.c");
   }

   @Test
   public void testArrayLengthSymbolic() throws IOException, URISyntaxException {
      compileAndCompare("array-length-symbolic.c");
   }

   @Test
   public void testForRangeSymbolic() throws IOException, URISyntaxException {
      compileAndCompare("forrangesymbolic.c");
   }

   @Test
   public void testSinePlotter() throws IOException, URISyntaxException {
      compileAndCompare("examples/sinplotter/sine-plotter.c");
   }

   @Test
   public void testScrollLogo() throws IOException, URISyntaxException {
      compileAndCompare("examples/scrolllogo/scrolllogo.c");
   }

   @Test
   public void testShowLogo() throws IOException, URISyntaxException {
      compileAndCompare("examples/showlogo/showlogo.c");
   }

   @Test
   public void testKasmPc() throws IOException, URISyntaxException {
      compileAndCompare("test-kasm-pc.c");
   }

   @Test
   public void testKasm() throws IOException, URISyntaxException {
      compileAndCompare("test-kasm.c");
   }

   @Test
   public void testLineAnim() throws IOException, URISyntaxException {
      compileAndCompare("line-anim.c");
   }

   @Test
   public void testInlineFunctionLevel2() throws IOException, URISyntaxException {
      compileAndCompare("inline-function-level2.c");
   }

   @Test
   public void testInlineFunctionPrint() throws IOException, URISyntaxException {
      compileAndCompare("inline-function-print.c");
   }

   @Test
   public void testInlineFunctionIf() throws IOException, URISyntaxException {
      compileAndCompare("inline-function-if.c");
   }

   @Test
   public void testInlineFunction() throws IOException, URISyntaxException {
      compileAndCompare("inline-function.c");
   }

   @Test
   public void testInlineFunctionMin() throws IOException, URISyntaxException {
      compileAndCompare("inline-function-min.c");
   }

   @Test
   public void testAssignmentCompound() throws IOException, URISyntaxException {
      compileAndCompare("assignment-compound.c");
   }

   @Test
   public void testAssignmentChained() throws IOException, URISyntaxException {
      compileAndCompare("assignment-chained.c");
   }

   @Test
   public void testConstMultDiv() throws IOException, URISyntaxException {
      compileAndCompare("const-mult-div.c");
   }

   @Test
   public void testDoubleAssignment() throws IOException, URISyntaxException {
      compileAndCompare("double-assignment.c");
   }

   @Test
   public void testLoopNpe() throws IOException, URISyntaxException {
      assertError("loop-npe.c", "Error! Loop variable not declared");
   }

   @Test
   public void testConstWordPointer() throws IOException, URISyntaxException {
      compileAndCompare("const-word-pointer.c");
   }

   @Test
   public void testConstParam() throws IOException, URISyntaxException {
      compileAndCompare("const-param.c");
   }

   @Test
   public void testDeepNesting() throws IOException, URISyntaxException {
      compileAndCompare("deep-nesting.c");
   }

   @Test
   public void testHelloWorld() throws IOException, URISyntaxException {
      compileAndCompare("examples/helloworld/helloworld.c");
   }

   @Test
   public void testHelloWorld2() throws IOException, URISyntaxException {
      compileAndCompare("helloworld2.c");
   }

   @Test
   public void testHelloWorld2Inline() throws IOException, URISyntaxException {
      compileAndCompare("helloworld2-inline.c");
   }

   @Test
   public void testChessboard() throws IOException, URISyntaxException {
      compileAndCompare("chessboard.c");
   }

   @Test
   public void testFragmentSynth() throws IOException, URISyntaxException {
      compileAndCompare("fragment-synth.c");
   }

   @Test
   public void testConstPointer() throws IOException, URISyntaxException {
      compileAndCompare("const-pointer.c");
   }

   @Test
   public void testVarForwardProblem() throws IOException, URISyntaxException {
      compileAndCompare("var-forward-problem.c");
   }

   @Test
   public void testVarForwardProblem2() throws IOException, URISyntaxException {
      compileAndCompare("var-forward-problem2.c");
   }

   @Test
   public void testInlineString3() throws IOException, URISyntaxException {
      compileAndCompare("inline-string-3.c");
   }

   @Test
   public void testInlineString4() throws IOException, URISyntaxException {
      compileAndCompare("inline-string-4.c");
   }

   @Test
   public void testEmptyBlockError() throws IOException, URISyntaxException {
      compileAndCompare("emptyblock-error.c");
   }

   @Test
   public void testConstCondition() throws IOException, URISyntaxException {
      compileAndCompare("const-condition.c");
   }

   @Test
   public void testBoolConst() throws IOException, URISyntaxException {
      compileAndCompare("bool-const.c");
   }

   @Test
   public void testBoolIfs() throws IOException, URISyntaxException {
      compileAndCompare("bool-ifs.c");
   }

   @Test
   public void testBoolIfsMin() throws IOException, URISyntaxException {
      compileAndCompare("bool-ifs-min.c");
   }

   @Test
   public void testBoolVars() throws IOException, URISyntaxException {
      compileAndCompare("bool-vars.c");
   }

   @Test
   public void testBoolFunction() throws IOException, URISyntaxException {
      compileAndCompare("bool-function.c");
   }

   @Test
   public void testBoolPointer() throws IOException, URISyntaxException {
      compileAndCompare("bool-pointer.c");
   }

   @Test
   public void testC64DtvBlitterMin() throws IOException, URISyntaxException {
      compileAndCompare("c64dtv-blittermin.c");
   }

   @Test
   public void testC64DtvBlitterBox() throws IOException, URISyntaxException {
      compileAndCompare("c64dtv-blitter-box.c");
   }

   @Test
   public void testC64Dtv8bppChunkyStretch() throws IOException, URISyntaxException {
      compileAndCompare("c64dtv-8bppchunkystretch.c");
   }

   @Test
   public void testC64Dtv8bppCharStretch() throws IOException, URISyntaxException {
      compileAndCompare("c64dtv-8bppcharstretch.c");
   }

   @Test
   public void testInlineString2() throws IOException, URISyntaxException {
      compileAndCompare("inline-string-2.c");
   }

   @Test
   public void testLoopProblem2() throws IOException, URISyntaxException {
      compileAndCompare("loop-problem2.c");
   }

   @Test
   public void testOperatorLoHiProblem1() throws IOException, URISyntaxException {
      compileAndCompare("operator-lohi-problem-1.c");
   }

   @Test
   public void testOperatorLoHiProblem() throws IOException, URISyntaxException {
      compileAndCompare("operator-lohi-problem.c");
   }

   @Test
   public void testKeyboardGlitch() throws IOException, URISyntaxException {
      compileAndCompare("keyboard-glitch.c");
   }

   @Test
   public void testNoromCharset() throws IOException, URISyntaxException {
      compileAndCompare("norom-charset.c");
   }

   @Test
   public void testChargenAnalysis() throws IOException, URISyntaxException {
      compileAndCompare("examples/chargen/chargen-analysis.c");
   }

   @Test
   public void testKeyboardSpace() throws IOException, URISyntaxException {
      compileAndCompare("test-keyboard-space.c");
   }

   @Test
   public void testKeyboard() throws IOException, URISyntaxException {
      compileAndCompare("test-keyboard.c");
   }

   @Test
   public void testC64DtvColor() throws IOException, URISyntaxException {
      compileAndCompare("c64dtv-color.c");
   }

   @Test
   public void testCastPrecedenceProblem() throws IOException, URISyntaxException {
      compileAndCompare("cast-precedence-problem.c");
   }

   @Test
   public void testLoopProblem() throws IOException, URISyntaxException {
      compileAndCompare("loop-problem.c");
   }

   @Test
   public void testLoHiConst() throws IOException, URISyntaxException {
      compileAndCompare("test-lohiconst.c");
   }

   @Test
   public void testSinusGen16() throws IOException, URISyntaxException {
      compileAndCompare("sinusgen16.c");
   }

   @Test
   public void testSinusGen16b() throws IOException, URISyntaxException {
      compileAndCompare("sinusgen16b.c");
   }

   @Test
   public void testSinusGenScale8() throws IOException, URISyntaxException {
      compileAndCompare("sinusgenscale8.c");
   }

   @Test
   public void testSinusGen8() throws IOException, URISyntaxException {
      compileAndCompare("sinusgen8.c");
   }

   @Test
   public void testSinusGen8b() throws IOException, URISyntaxException {
      compileAndCompare("sinusgen8b.c");
   }

   @Test
   public void testLineGen() throws IOException, URISyntaxException {
      compileAndCompare("linegen.c");
   }

   @Test
   public void testLowHigh() throws IOException, URISyntaxException {
      compileAndCompare("test-lowhigh.c");
   }

   @Test
   public void testLongJump2() throws IOException, URISyntaxException {
      compileAndCompare("longjump2.c");
   }

   @Test
   public void testLongJump() throws IOException, URISyntaxException {
      compileAndCompare("longjump.c");
   }

   @Test
   public void testAddressOf3() throws IOException, URISyntaxException {
      compileAndCompare("address-of-3.c");
   }

   @Test
   public void testAddressOf2() throws IOException, URISyntaxException {
      compileAndCompare("address-of-2.c");
   }

   @Test
   public void testAddressOf1() throws IOException, URISyntaxException {
      compileAndCompare("address-of-1.c");
   }

   @Test
   public void testAddressOf0() throws IOException, URISyntaxException {
      compileAndCompare("address-of-0.c");
   }

   @Test
   public void testDivision() throws IOException, URISyntaxException {
      compileAndCompare("test-division.c");
   }

   @Test
   public void testVarExport() throws IOException, URISyntaxException {
      compileAndCompare("var-export.c");
   }

   @Test
   public void testVarRegister() throws IOException, URISyntaxException {
      compileAndCompare("var-register.c");
   }

   @Test
   public void testVarRegisterNoarg() throws IOException, URISyntaxException {
      compileAndCompare("var-register-noarg.c");
   }

   @Test
   public void testVarRegisterZp() throws IOException, URISyntaxException {
      compileAndCompare("var-register-zp.c");
   }

   @Test
   public void testVarRegisterZp3() throws IOException, URISyntaxException {
      compileAndCompare("var-register-zp-3.c");
   }

   @Test
   public void testDword() throws IOException, URISyntaxException {
      compileAndCompare("dword.c");
   }

   @Test
   public void testCastDeref() throws IOException, URISyntaxException {
      compileAndCompare("cast-deref.c");
   }

   @Test
   public void testRasterBars() throws IOException, URISyntaxException {
      compileAndCompare("examples/rasterbars/raster-bars.c");
   }

   @Test
   public void testComparisons() throws IOException, URISyntaxException {
      compileAndCompare("test-comparisons.c", 10);
   }

   @Test
   public void testMemAlignment() throws IOException, URISyntaxException {
      compileAndCompare("mem-alignment.c");
   }

   @Test
   public void testMultiply8Bit() throws IOException, URISyntaxException {
      compileAndCompare("test-multiply-8bit.c");
   }

   @Test
   public void testMultiply16Bit() throws IOException, URISyntaxException {
      compileAndCompare("test-multiply-16bit.c");
   }

   @Test
   public void testMultiply16BitConst() throws IOException, URISyntaxException {
      compileAndCompare("multiply-16bit-const.c");
   }

   @Test
   public void testArraysInitShort() throws IOException, URISyntaxException {
      compileAndCompare("arrays-init-short.c");
   }

   @Test
   public void testArraysNonstandardSyntax() throws IOException, URISyntaxException {
      assertError("arrays-nonstandard-syntax.c", "ERROR! Non-standard array declaration.");
   }

   @Test
   public void testArraysInit() throws IOException, URISyntaxException {
      compileAndCompare("arrays-init.c");
   }

   @Test
   public void testTrueInlineWords() throws IOException, URISyntaxException {
      compileAndCompare("true-inline-words.c");
   }

   @Test
   public void testIncrementInArray() throws IOException, URISyntaxException {
      compileAndCompare("incrementinarray.c");
   }

   @Test
   public void testForIncrementAssign() throws IOException, URISyntaxException {
      compileAndCompare("forincrementassign.c");
   }

   @Test
   public void testConstants() throws IOException, URISyntaxException {
      compileAndCompare("constants.c");
   }

   @Test
   public void testInlineAssignment() throws IOException, URISyntaxException {
      compileAndCompare("inline-assignment.c");
   }

   @Test
   public void testInlineDWord0() throws IOException, URISyntaxException {
      compileAndCompare("inline-dword-0.c");
   }

   @Test
   public void testInlineWord0() throws IOException, URISyntaxException {
      compileAndCompare("inline-word-0.c");
   }

   @Test
   public void testInlineWord1() throws IOException, URISyntaxException {
      compileAndCompare("inline-word-1.c");
   }

   @Test
   public void testInlineWord2() throws IOException, URISyntaxException {
      compileAndCompare("inline-word-2.c");
   }

   @Test
   public void testInlineWord() throws IOException, URISyntaxException {
      compileAndCompare("inline-word.c");
   }

   @Test
   public void testSignedWords() throws IOException, URISyntaxException {
      compileAndCompare("signed-words.c");
   }

   @Test
   public void testSinusSprites() throws IOException, URISyntaxException {
      compileAndCompare("examples/sinsprites/sinus-sprites.c");
   }

   @Test
   public void testConstantAbsMin() throws IOException, URISyntaxException {
      compileAndCompare("constabsmin.c");
   }

   @Test
   public void testBasicFloats() throws IOException, URISyntaxException {
      compileAndCompare("sinus-basic.c");
   }

   @Test
   public void testDoubleImport() throws IOException, URISyntaxException {
      compileAndCompare("double-import.c");
   }

   @Test
   public void testImporting() throws IOException, URISyntaxException {
      compileAndCompare("importing.c");
   }

   @Test
   public void testUnusedVars() throws IOException, URISyntaxException {
      compileAndCompare("unused-vars.c");
   }

   @Test
   public void testFillscreen3() throws IOException, URISyntaxException {
      compileAndCompare("fillscreen-3.c");
   }

   @Test
   public void testFillscreen2() throws IOException, URISyntaxException {
      compileAndCompare("fillscreen-2.c");
   }

   @Test
   public void testFillscreen1() throws IOException, URISyntaxException {
      compileAndCompare("fillscreen-1.c");
   }

   @Test
   public void testLiverangeCallProblem() throws IOException, URISyntaxException {
      compileAndCompare("liverange-call-problem.c");
   }

   @Test
   public void testPrintProblem() throws IOException, URISyntaxException {
      compileAndCompare("print-problem.c");
   }

   @Test
   public void testPrintMsg() throws IOException, URISyntaxException {
      compileAndCompare("printmsg.c");
   }

   @Test
   public void testUnusedMethod() throws IOException, URISyntaxException {
      compileAndCompare("unused-method.c");
   }

   @Test
   public void testInlineString() throws IOException, URISyntaxException {
      compileAndCompare("inline-string.c");
   }

   @Test
   public void testLocalString() throws IOException, URISyntaxException {
      compileAndCompare("local-string.c");
   }

   @Test
   public void testInlineArrayProblem() throws IOException, URISyntaxException {
      compileAndCompare("inlinearrayproblem.c");
   }

   @Test
   public void testImmZero() throws IOException, URISyntaxException {
      compileAndCompare("immzero.c");
   }

   @Test
   public void testWordExpr() throws IOException, URISyntaxException {
      compileAndCompare("wordexpr.c");
   }

   @Test
   public void testZpptr() throws IOException, URISyntaxException {
      compileAndCompare("zpptr.c");
   }

   @Test
   public void testCasting() throws IOException, URISyntaxException {
      compileAndCompare("casting.c");
   }

   @Test
   public void testSignedBytes() throws IOException, URISyntaxException {
      compileAndCompare("signed-bytes.c");
   }

   @Test
   public void testScrollBig() throws IOException, URISyntaxException {
      compileAndCompare("examples/scrollbig/scrollbig.c");
   }

   @Test
   public void testPtrComplex() throws IOException, URISyntaxException {
      compileAndCompare("ptr-complex.c");
   }

   @Test
   public void testIncD020() throws IOException, URISyntaxException {
      compileAndCompare("incd020.c");
   }

   @Test
   public void testOverlapAllocation2() throws IOException, URISyntaxException {
      compileAndCompare("overlap-allocation-2.c");
   }

   @Test
   public void testOverlapAllocation() throws IOException, URISyntaxException {
      compileAndCompare("overlap-allocation.c");
   }

   @Test
   public void testBitmapBresenham() throws IOException, URISyntaxException {
      compileAndCompare("examples/bresenham/bitmap-bresenham.c");
   }

   @Test
   public void testAsmClobber() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm-clobber.c");
   }

   @Test
   public void testInlineAsm() throws IOException, URISyntaxException {
      compileAndCompare("inline-asm.c");
   }

   @Test
   public void testChargen() throws IOException, URISyntaxException {
      compileAndCompare("chargen.c");
   }

   @Test
   public void testBitmapPlotter() throws IOException, URISyntaxException {
      compileAndCompare("bitmap-plotter.c");
   }

   @Test
   public void testConstIdentification() throws IOException, URISyntaxException {
      compileAndCompare("const-identification.c");
   }

   @Test
   public void testCallConstParam() throws IOException, URISyntaxException {
      compileAndCompare("callconstparam.c");
   }

   @Test
   public void testScrollClobber() throws IOException, URISyntaxException {
      compileAndCompare("scroll-clobber.c");
   }

   @Test
   public void testHalfscii() throws IOException, URISyntaxException {
      compileAndCompare("halfscii.c");
   }


   @Test
   public void testScroll() throws IOException, URISyntaxException {
      compileAndCompare("examples/scroll/scroll.c");
   }

   @Test
   public void testConstantMin() throws IOException, URISyntaxException {
      compileAndCompare("constantmin.c");
   }

   @Test
   public void testLiveRange10() throws IOException, URISyntaxException {
      compileAndCompare("liverange-10.c");
   }

   @Test
   public void testLiveRange9() throws IOException, URISyntaxException {
      compileAndCompare("liverange-9.c");
   }

   @Test
   public void testLiveRange8() throws IOException, URISyntaxException {
      compileAndCompare("liverange-8.c");
   }

   @Test
   public void testLiveRange7() throws IOException, URISyntaxException {
      compileAndCompare("liverange-7.c");
   }

   @Test
   public void testLiveRange6() throws IOException, URISyntaxException {
      compileAndCompare("liverange-6.c");
   }

   @Test
   public void testLiveRange5() throws IOException, URISyntaxException {
      compileAndCompare("liverange-5.c");
   }

   @Test
   public void testLiveRange4() throws IOException, URISyntaxException {
      compileAndCompare("liverange-4.c");
   }

   @Test
   public void testLiveRange3() throws IOException, URISyntaxException {
      compileAndCompare("liverange-3.c");
   }

   @Test
   public void testLiveRange2() throws IOException, URISyntaxException {
      compileAndCompare("liverange-2.c");
   }

   @Test
   public void testLiveRange1() throws IOException, URISyntaxException {
      compileAndCompare("liverange-1.c");
   }

   @Test
   public void testLiveRange() throws IOException, URISyntaxException {
      compileAndCompare("liverange.c");
   }

   @Test
   public void testZpParamMin() throws IOException, URISyntaxException {
      compileAndCompare("zpparammin.c");
   }

   @Test
   public void testInMemArray() throws IOException, URISyntaxException {
      compileAndCompare("inmemarray.c");
   }

   @Test
   public void testInMemConstArray() throws IOException, URISyntaxException {
      compileAndCompare("inmem-const-array.c");
   }

   @Test
   public void testInMemString() throws IOException, URISyntaxException {
      compileAndCompare("inmemstring.c");
   }

   @Test
   public void testVoronoi() throws IOException, URISyntaxException {
      compileAndCompare("voronoi.c");
   }

   @Test
   public void testFlipper() throws IOException, URISyntaxException {
      compileAndCompare("flipper-rex2.c");
   }

   @Test
   public void testBresenham() throws IOException, URISyntaxException {
      compileAndCompare("bresenham.c");
   }

   @Test
   public void testBresenhamArr() throws IOException, URISyntaxException {
      compileAndCompare("bresenhamarr.c");
   }

   @Test
   public void testIterArray() throws IOException, URISyntaxException {
      compileAndCompare("iterarray.c");
   }

   @Test
   public void testLoopMin() throws IOException, URISyntaxException {
      compileAndCompare("loopmin.c");
   }

   @Test
   public void testSumMin() throws IOException, URISyntaxException {
      compileAndCompare("summin.c");
   }

   @Test
   public void testLoopSplit() throws IOException, URISyntaxException {
      compileAndCompare("loopsplit.c");
   }

   @Test
   public void testLoopNest() throws IOException, URISyntaxException {
      compileAndCompare("loopnest.c");
   }

   @Test
   public void testLoopNest2() throws IOException, URISyntaxException {
      compileAndCompare("loopnest2.c");
   }

   @Test
   public void testLoopNest3() throws IOException, URISyntaxException {
      compileAndCompare("loopnest3.c");
   }

   @Test
   public void testFibMem() throws IOException, URISyntaxException {
      compileAndCompare("fibmem.c");
   }

   @Test
   public void testPtrTest() throws IOException, URISyntaxException {
      compileAndCompare("ptrtest.c");
   }

   @Test
   public void testPtrTestMin() throws IOException, URISyntaxException {
      compileAndCompare("ptrtestmin.c");
   }

   @Test
   public void testUseGlobal() throws IOException, URISyntaxException {
      compileAndCompare("useglobal.c");
   }

   @Test
   public void testModGlobal() throws IOException, URISyntaxException {
      compileAndCompare("modglobal.c");
   }

   @Test
   public void testModGlobalMin() throws IOException, URISyntaxException {
      compileAndCompare("modglobalmin.c");
   }

   @Test
   public void testIfMin() throws IOException, URISyntaxException {
      compileAndCompare("ifmin.c");
   }

   @Test
   public void testLoopWhileMin() throws IOException, URISyntaxException {
      compileAndCompare("loop-while-min.c");
   }

   @Test
   public void testLoopMemsetMin() throws IOException, URISyntaxException {
      compileAndCompare("loop-memset-min.c");
   }

   @Test
   public void testLoopWhileSideeffect() throws IOException, URISyntaxException {
      compileAndCompare("loop-while-sideeffect.c");
   }

   @Test
   public void testLoopForSideeffect() throws IOException, URISyntaxException {
      compileAndCompare("loop-for-sideeffect.c");
   }

   @Test
   public void testForClassicMin() throws IOException, URISyntaxException {
      compileAndCompare("forclassicmin.c");
   }

   @Test
   public void testForRangeMin() throws IOException, URISyntaxException {
      compileAndCompare("forrangemin.c");
   }

   @Test
   public void testAssignConst() throws IOException, URISyntaxException {
      assertError("assign-const.c", "const variable may not be modified");
   }

   @Test
   public void testStmtOutsideMethod() throws IOException, URISyntaxException {
      assertError("stmt-outside-method.c", "Error parsing");
   }

   @Test
   public void testUseUndeclared() throws IOException, URISyntaxException {
      assertError("useundeclared.c", "Unknown variable");
   }

   @Test
   public void testassignUndeclared() throws IOException, URISyntaxException {
      assertError("assignundeclared.c", "Unknown variable");
   }

   @Test
   public void testUseUninitialized2() throws IOException, URISyntaxException {
      assertError("useuninitialized2.c", "Variable used before being defined");
   }

   @Test
   public void testTypeMismatch() throws IOException, URISyntaxException {
      assertError("typemismatch.c", "Type mismatch");
   }

   @Test
   public void testToManyParams() throws IOException, URISyntaxException {
      assertError("tomanyparams.c", "Wrong number of parameters in call");
   }

   @Test
   public void testToFewParams() throws IOException, URISyntaxException {
      assertError("tofewparams.c", "Wrong number of parameters in call");
   }

   @Test
   public void testNoReturn() throws IOException, URISyntaxException {
      assertError("noreturn.c", "Method must end with a return statement", false);
   }

   @Test
   public void testReturnFromVoid() throws IOException, URISyntaxException {
      assertError("returnfromvoid.c", "Error! Return value from void function");
   }

   @Test
   public void testProcedureNotFound() throws IOException, URISyntaxException {
      assertError("procedurenotfound.c", "Called procedure not found");
   }

   @Test
   public void testIllegalLValue() throws IOException, URISyntaxException {
      assertError("illegallvalue.c", "LValue is illegal");
   }

   @Test
   public void testInvalidConstType() throws IOException, URISyntaxException {
      assertError("invalid-consttype.c", "Constant init-value has a non-matching type", false);
   }

   @Test
   public void testArrayUninitialized() throws IOException, URISyntaxException {
      assertError("array-uninitialized.c", "Array has no declared size.");
   }

   @Test
   public void testArrayLengthMismatch() throws IOException, URISyntaxException {
      assertError("array-length-mismatch.c", "Array length mismatch", false);
   }

   @Test
   public void testStringLengthMismatch() throws IOException, URISyntaxException {
      assertError("string-length-mismatch.c", "Array length mismatch", false);
   }

   @Test
   public void testIllegalAlignment() throws IOException, URISyntaxException {
      assertError("illegal-alignment.c", "Cannot align variable");
   }

   @Test
   public void testRegisterClobber() throws IOException, URISyntaxException {
      assertError("register-clobber.c", "register clobber problem", false);
   }

   @Test
   public void testRecursionError() throws IOException, URISyntaxException {
      assertError("recursion-error.c", "Recursion", false);
   }

   @Test
   public void testRecursionComplexError() throws IOException, URISyntaxException {
      assertError("recursion-error-complex.c", "Recursion", false);
   }

   @Test
   public void testConstPointerModifyError() throws IOException, URISyntaxException {
      assertError("const-pointer-modify.c", "Constants can not be modified");
   }

   @Test
   public void testNoMulRuntime() throws IOException, URISyntaxException {
      assertError("no-mul-runtime.c", "Runtime multiplication not supported");
   }

   @Test
   public void testNoDivRuntime() throws IOException, URISyntaxException {
      assertError("no-div-runtime.c", "Runtime division not supported");
   }

   @Test
   public void testNoModRuntime() throws IOException, URISyntaxException {
      assertError("no-mod-runtime.c", "Runtime modulo not supported");
   }

   @Test
   public void testNoInlineInterrupt() throws IOException, URISyntaxException {
      assertError("no-inlineinterrupt.c", "Interrupts cannot be inlined", false);
   }

   @Test
   public void testNoCalledInterrupt() throws IOException, URISyntaxException {
      assertError("no-calledinterrupt.c", "Interrupts cannot be called.");
   }

   @Test
   public void testNoParamInterrupt() throws IOException, URISyntaxException {
      assertError("no-paraminterrupt.c", "Interrupts cannot have parameters.", false);
   }

   @Test
   public void testNoReturnInterrupt() throws IOException, URISyntaxException {
      assertError("no-returninterrupt.c", "Interrupts cannot return anything.", false);
   }

   @Test
   public void testConditionTypeMismatch() throws IOException, URISyntaxException {
      compileAndCompare("condition-type-mismatch.c");
   }

   static AsmFragmentTemplateSynthesizer asmFragmentSynthesizer;

   @BeforeClass
   public static void setUp() {
      Path asmFragmentBaseFolder = new File("src/main/fragment/").toPath();
      Path asmFragmentCacheFolder = null;
      asmFragmentSynthesizer = new AsmFragmentTemplateSynthesizer(asmFragmentBaseFolder, TargetCpu.MOS6502X, asmFragmentCacheFolder, new CompileLog());
   }

   @AfterClass
   public static void tearDown() {
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

   private void compileAndCompare(String filename, int upliftCombinations, CompileLog log) throws IOException, URISyntaxException {
      TestPrograms tester = new TestPrograms();
      tester.testFile(filename, upliftCombinations, log);
   }

   private void testFile(String fileName, Integer upliftCombinations, CompileLog compileLog) throws IOException {
      System.out.println("Testing output for " + fileName);
      Compiler compiler = new Compiler();
      compiler.setWarnFragmentMissing(true);
      compiler.setAsmFragmentBaseFolder(new File("src/main/fragment/").toPath());
      compiler.setAsmFragmentCacheFolder(null);
      if(compileLog != null) {
         compiler.setLog(compileLog);
      }
      compiler.addIncludePath(stdIncludePath);
      compiler.addIncludePath(testPath);
      compiler.addLibraryPath(stdLibPath);
      compiler.initAsmFragmentSynthesizer(asmFragmentSynthesizer);
      if(upliftCombinations != null) {
         compiler.setUpliftCombinations(upliftCombinations);
      }
      final ArrayList<Path> files = new ArrayList<>();
      final Path filePath = Paths.get(fileName);
      files.add(filePath);
      compiler.compile(files);
      Program program = compiler.getProgram();
      compileAsm(fileName, program);
      boolean success = true;
      ReferenceHelper helper = new ReferenceHelperFolder(refPath);
      String baseFileName = Compiler.removeFileNameExtension(fileName);
      success &= helper.testOutput(baseFileName, ".asm", program.getAsm().toString(new AsmProgram.AsmPrintState(false, true, false, false), program));
      success &= helper.testOutput(baseFileName, ".sym", program.getScope().toString(program, false));
      success &= helper.testOutput(baseFileName, ".cfg", program.getGraph().toString(program));
      success &= helper.testOutput(baseFileName, ".log", program.getLog().toString());
      if(!success) {
         //System.out.println("\nCOMPILE LOG");
         //System.out.println(program.getLog().toString());
         fail("Output does not match reference!");
      }

      compiler.getAsmFragmentSynthesizer().finalize(program.getLog());
   }

   private void compileAsm(String fileName, Program program) throws IOException {
      String baseFileName = Compiler.removeFileNameExtension(fileName);
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
         asmRes = KickAssembler.main2(new String[]{asmFile.getAbsolutePath(), "-log", asmLogFile.getAbsolutePath(), "-o", asmPrgFile.getAbsolutePath(), "-vicesymbols", "-showmem", "-bytedump"});
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