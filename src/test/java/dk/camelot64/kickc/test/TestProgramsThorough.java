package dk.camelot64.kickc.test;

import org.junit.jupiter.api.Test;

import java.io.IOException;

/**
 * Compile a number of source files and compare the resulting assembler with expected output
 */
public class TestProgramsThorough extends TestPrograms {

//   @Test
//   public void testComplexCeleste() throws IOException {
//      compileAndCompare("complex/celeste/celeste.c", log());
//   }

//   @Test
//   public void testComplexSwinkiblues() throws IOException {
//      compileAndCompare("complex/swinkiblues_4/loader.c");
//   }

   @Test
   public void testCx16VeralibTilemap8bpp8() throws IOException {
      compileAndCompare("examples/cx16/veralib/tilemap_8bpp_8_x_8.c");
   }

   @Test
   public void testCx16VeralibTilemap8bpp16() throws IOException {
      compileAndCompare("examples/cx16/veralib/tilemap_8bpp_16_x_16.c");
   }

   @Test
   public void testCx16VeralibBitmap8bpp() throws IOException {
      compileAndCompare("examples/cx16/veralib/bitmap_8bpp_320_x_240.c");
   }

   @Test
   public void testCx16BankAddressing() throws IOException {
      compileAndCompare("examples/cx16/cx16-bankaddressing.c");
   }

   //@Test
   //public void testCx16SpaceDemo() throws IOException {
   //   compileAndCompare("examples/cx16/spacedemo/spacedemo.c");
   //}

   @Test
   public void testCx16LoadFileInBank() throws IOException {
      compileAndCompare("examples/cx16/cx16-bankload.c");
   }

   @Test
   public void testCx16VeraLayers() throws IOException {
      compileAndCompare("examples/cx16/cx16-veralayers.c");
   }

   @Test
   public void testCx16TileMap() throws IOException {
      compileAndCompare("examples/cx16/cx16-tilemap.c");
   }

   @Test
   public void testCx16Sprites() throws IOException {
      compileAndCompare("examples/cx16/cx16-sprites.c");
   }

   @Test
   public void testCx16Text() throws IOException {
      compileAndCompare("examples/cx16/cx16-text.c");
   }

   @Test
   public void test32bitRols() throws IOException {
      compileAndCompare("32bit-rols.c");
   }

   @Test
   public void testComplexBorderlinePacman() throws IOException {
      compileAndCompare("complex/borderline_pacman/pacman.c");
   }

   @Test
   public void testComplexNew30YearsLowResolution() throws IOException {
      compileAndCompare("complex/new_30_years_low_resolution/new_30_years_low_resolution.c");
   }

   @Test
   public void testC64DtvGfxExplorer() throws IOException {
      compileAndCompare("c64dtv-gfxexplorer.c",  20);
   }

   @Test
   public void testC64DtvGfxModes() throws IOException {
      compileAndCompare("c64dtv-gfxmodes.c", 20);
   }

   @Test
   public void testPrintf12() throws IOException {
      compileAndCompare("printf-12.c");
   }

   @Test
   public void testPrintf13() throws IOException {
      compileAndCompare("printf-13.c");
   }

   @Test
   public void testEightQueensRecursive() throws IOException {
      compileAndCompare("examples/eightqueens/eightqueens-recursive.c");
   }

   @Test
   public void testEightQueens() throws IOException {
      compileAndCompare("examples/eightqueens/eightqueens.c");
   }

   @Test
   public void testCpu65CE02EightQueens() throws IOException {
      compileAndCompare("cpu-65ce02-eightqueens.c");
   }

   @Test
   public void testAdventOfCode04() throws IOException {
      compileAndCompare("adventofcode/2020-04.c");
   }

   @Test
   public void testAdventOfCode03() throws IOException {
      compileAndCompare("adventofcode/2020-03.c");
   }

   @Test
   public void testAdventOfCode02() throws IOException {
      compileAndCompare("adventofcode/2020-02.c");
   }

   @Test
   public void testAdventOfCode01() throws IOException {
      compileAndCompare("adventofcode/2020-01.c");
   }

   @Test
   public void testDeepNesting() throws IOException {
      compileAndCompare("deep-nesting.c");
   }

   @Test
   public void testMultiply8Bit() throws IOException {
      compileAndCompare("test-multiply-8bit.c");
   }

   @Test
   public void testSinusGenScale8() throws IOException {
      compileAndCompare("sinusgenscale8.c");
   }

   @Test
   public void test3D() throws IOException {
      compileAndCompare("examples/c64/3d/3d.c");
   }

   @Test
   public void testAtariXlMd5() throws IOException {
      compileAndCompare("atarixl-md5.c");
   }

   @Test
   public void testMultiply16Bit() throws IOException {
      compileAndCompare("test-multiply-16bit.c");
   }

   @Test
   public void testNesConio() throws IOException {
      compileAndCompare("examples/nes/nes-conio.c");
   }

   @Test
   public void testRand1() throws IOException {
      compileAndCompare("rand-1.c");
   }

   @Test
   public void testScreenShowSpiralBuckets() throws IOException {
      compileAndCompare("screen-show-spiral-buckets.c");
   }

   @Test
   public void testPrintf2() throws IOException {
      compileAndCompare("printf-2.c");
   }

   @Test
   public void testStars1() throws IOException {
      compileAndCompare("stars-1.c");
   }

   @Test
   public void testSinusGen16b() throws IOException {
      compileAndCompare("sinusgen16b.c");
   }

   @Test
   public void testPrngXorshift() throws IOException {
      compileAndCompare("prng-xorshift.c");
   }

   @Test
   public void testPlasmaCenter() throws IOException {
      compileAndCompare("plasma-center.c");
   }

   @Test
   public void testSemiStruct2() throws IOException {
      compileAndCompare("semi-struct-2.c");
   }

   @Test
   public void testTypeSigned() throws IOException {
      compileAndCompare("type-signed.c");
   }

   @Test
   public void testDivision() throws IOException {
      compileAndCompare("test-division.c");
   }

   @Test
   public void testScrollLogo() throws IOException {
      compileAndCompare("examples/c64/scrolllogo/scrolllogo.c");
   }

   @Test
   public void testSinusGen8b() throws IOException {
      compileAndCompare("sinusgen8b.c");
   }

   @Test
   public void testStdlibStringMemChr1() throws IOException {
      compileAndCompare("stdlib-string-memchr-1.c");
   }

   @Test
   public void testAtariXlConioTest() throws IOException {
      compileAndCompare("examples/atarixl/atarixl-conio.c");
   }

   @Test
   public void testPrintf16() throws IOException {
      compileAndCompare("printf-16.c");
   }

   @Test
   public void testNoRecursionHeavy() throws IOException {
      compileAndCompare("no-recursion-heavy.c");
   }

   @Test
   public void testBitmapPlot2() throws IOException {
      compileAndCompare("bitmap-plot-2.c");
   }

   @Test
   public void testPlasmaUnroll() throws IOException {
      compileAndCompare("examples/c64/plasma/plasma-unroll.c");
   }

   @Test
   public void testPrimes1000() throws IOException {
      compileAndCompare("primes-1000.c");
   }

   @Test
   public void testBitmapPlot1() throws IOException {
      compileAndCompare("bitmap-plot-1.c");
   }

   @Test
   public void testSinePlotter() throws IOException {
      compileAndCompare("examples/c64/sinplotter/sine-plotter.c");
   }

   @Test
   public void testSinusSprites() throws IOException {
      compileAndCompare("examples/c64/sinsprites/sinus-sprites.c");
   }

   @Test
   public void testConioNachtScreen() throws IOException {
      compileAndCompare("examples/conio/nacht-screen.c");
   }

   @Test
   public void testScreenShowSpiral() throws IOException {
      compileAndCompare("screen-show-spiral.c");
   }

   @Test
   public void testCircleChars() throws IOException {
      compileAndCompare("circlechars.c");
   }

   @Test
   public void testPrintfSpeed() throws IOException {
      compileAndCompare("printf-speed.c");
   }

   @Test
   public void testRotate() throws IOException {
      compileAndCompare("examples/c64/rotate/rotate.c");
   }

   @Test
   public void testXMega65Logo() throws IOException {
      compileAndCompare("complex/xmega65/xmega65logo.c");
   }

   @Test
   public void testPlasma() throws IOException {
      compileAndCompare("examples/c64/plasma/plasma.c");
   }

   @Test
   public void testPaulNelsenSandbox() throws IOException {
      compileAndCompare("sandbox.c");
   }

   @Test
   public void testScreenCenterDistance() throws IOException {
      compileAndCompare("screen-center-distance.c");
   }

   @Test
   public void testNesDemo() throws IOException {
      compileAndCompare("examples/nes/nes-demo.c");
   }

   @Test
   public void testCordicAtan2Ref() throws IOException {
      compileAndCompare("cordic-atan2-16-ref.c");
   }

   @Test
   public void testSieve() throws IOException {
      compileAndCompare("sieve.c");
   }

   @Test
   public void testAtoi() throws IOException {
      compileAndCompare("atoi-1.c");
   }

   @Test
   public void testTextbox() throws IOException {
      compileAndCompare("textbox.c");
   }

   @Test
   public void testSinusGen8() throws IOException {
      compileAndCompare("sinusgen8.c");
   }

   @Test
   public void testScreenCenterAngle() throws IOException {
      compileAndCompare("screen-center-angle.c");
   }

   @Test
   public void testFastMultiply127() throws IOException {
      compileAndCompare("fastmultiply-127.c");
   }

   @Test
   public void testComparisons() throws IOException {
      compileAndCompare("test-comparisons.c", 10);
   }

   @Test
   public void testChargenAnalysis() throws IOException {
      compileAndCompare("examples/c64/chargen/chargen-analysis.c");
   }

   @Test
   public void testLineAnim() throws IOException {
      compileAndCompare("line-anim.c");
   }













}