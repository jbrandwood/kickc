package dk.camelot64.kickc.test;

import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.net.URISyntaxException;

/**
 * Compile a number of source files and compare the resulting assembler with expected output
 */
public class TestProgramsThorough extends TestPrograms {
   @Test
   public void testCx16VeralibTilemap8bpp() throws IOException, URISyntaxException {
      compileAndCompare("examples/cx16/veralib/tilemap_8bpp_16_x_16.c");
   }

   @Test
   public void testCx16VeralibBitmap8bpp() throws IOException, URISyntaxException {
      compileAndCompare("examples/cx16/veralib/bitmap_8bpp_320_x_240.c");
   }

   @Test
   public void testCx16BankAddressing() throws IOException, URISyntaxException {
      compileAndCompare("examples/cx16/cx16-bankaddressing.c");
   }

   //@Test
   //public void testCx16SpaceDemo() throws IOException, URISyntaxException {
   //   compileAndCompare("examples/cx16/spacedemo/spacedemo.c");
   //}

   @Test
   public void testCx16LoadFileInBank() throws IOException, URISyntaxException {
      compileAndCompare("examples/cx16/cx16-bankload.c");
   }

   @Test
   public void testCx16VeraLayers() throws IOException, URISyntaxException {
      compileAndCompare("examples/cx16/cx16-veralayers.c");
   }

   @Test
   public void testCx16TileMap() throws IOException, URISyntaxException {
      compileAndCompare("examples/cx16/cx16-tilemap.c");
   }

   @Test
   public void testCx16Sprites() throws IOException, URISyntaxException {
      compileAndCompare("examples/cx16/cx16-sprites.c");
   }

   @Test
   public void testCx16Text() throws IOException, URISyntaxException {
      compileAndCompare("examples/cx16/cx16-text.c");
   }

   @Test
   public void test32bitRols() throws IOException, URISyntaxException {
      compileAndCompare("32bit-rols.c");
   }

   @Test
   public void testComplexBorderlinePacman() throws IOException, URISyntaxException {
      compileAndCompare("complex/borderline_pacman/pacman.c");
   }

   @Test
   public void testComplexNew30YearsLowResolution() throws IOException, URISyntaxException {
      compileAndCompare("complex/new_30_years_low_resolution/new_30_years_low_resolution.c");
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
   public void testPrintf12() throws IOException, URISyntaxException {
      compileAndCompare("printf-12.c");
   }

   @Test
   public void testPrintf13() throws IOException, URISyntaxException {
      compileAndCompare("printf-13.c");
   }

   @Test
   public void testEightQueensRecursive() throws IOException, URISyntaxException {
      compileAndCompare("examples/eightqueens/eightqueens-recursive.c");
   }

   @Test
   public void testEightQueens() throws IOException, URISyntaxException {
      compileAndCompare("examples/eightqueens/eightqueens.c");
   }

   @Test
   public void testCpu65CE02EightQueens() throws IOException, URISyntaxException {
      compileAndCompare("cpu-65ce02-eightqueens.c");
   }

   @Test
   public void testAdventOfCode04() throws IOException, URISyntaxException {
      compileAndCompare("adventofcode/2020-04.c");
   }

   @Test
   public void testAdventOfCode03() throws IOException, URISyntaxException {
      compileAndCompare("adventofcode/2020-03.c");
   }

   @Test
   public void testAdventOfCode02() throws IOException, URISyntaxException {
      compileAndCompare("adventofcode/2020-02.c");
   }

   @Test
   public void testAdventOfCode01() throws IOException, URISyntaxException {
      compileAndCompare("adventofcode/2020-01.c");
   }

   @Test
   public void testDeepNesting() throws IOException, URISyntaxException {
      compileAndCompare("deep-nesting.c");
   }

   @Test
   public void testMultiply8Bit() throws IOException, URISyntaxException {
      compileAndCompare("test-multiply-8bit.c");
   }

   @Test
   public void testSinusGenScale8() throws IOException, URISyntaxException {
      compileAndCompare("sinusgenscale8.c");
   }

   @Test
   public void test3D() throws IOException, URISyntaxException {
      compileAndCompare("examples/c64/3d/3d.c");
   }

   @Test
   public void testAtariXlMd5() throws IOException, URISyntaxException {
      compileAndCompare("atarixl-md5.c");
   }

   @Test
   public void testMultiply16Bit() throws IOException, URISyntaxException {
      compileAndCompare("test-multiply-16bit.c");
   }

   @Test
   public void testNesConio() throws IOException, URISyntaxException {
      compileAndCompare("examples/nes/nes-conio.c");
   }

   @Test
   public void testRand1() throws IOException, URISyntaxException {
      compileAndCompare("rand-1.c");
   }

   @Test
   public void testScreenShowSpiralBuckets() throws IOException, URISyntaxException {
      compileAndCompare("screen-show-spiral-buckets.c");
   }

   @Test
   public void testPrintf2() throws IOException, URISyntaxException {
      compileAndCompare("printf-2.c");
   }

   @Test
   public void testStars1() throws IOException, URISyntaxException {
      compileAndCompare("stars-1.c");
   }

   @Test
   public void testSinusGen16b() throws IOException, URISyntaxException {
      compileAndCompare("sinusgen16b.c");
   }

   @Test
   public void testPrngXorshift() throws IOException, URISyntaxException {
      compileAndCompare("prng-xorshift.c");
   }

   @Test
   public void testPlasmaCenter() throws IOException, URISyntaxException {
      compileAndCompare("plasma-center.c");
   }

   @Test
   public void testSemiStruct2() throws IOException, URISyntaxException {
      compileAndCompare("semi-struct-2.c");
   }

   @Test
   public void testTypeSigned() throws IOException, URISyntaxException {
      compileAndCompare("type-signed.c");
   }

   @Test
   public void testDivision() throws IOException, URISyntaxException {
      compileAndCompare("test-division.c");
   }

   @Test
   public void testScrollLogo() throws IOException, URISyntaxException {
      compileAndCompare("examples/c64/scrolllogo/scrolllogo.c");
   }

   @Test
   public void testSinusGen8b() throws IOException, URISyntaxException {
      compileAndCompare("sinusgen8b.c");
   }

   @Test
   public void testStdlibStringMemChr1() throws IOException, URISyntaxException {
      compileAndCompare("stdlib-string-memchr-1.c");
   }

   @Test
   public void testAtariXlConioTest() throws IOException, URISyntaxException {
      compileAndCompare("examples/atarixl/atarixl-conio.c");
   }

   @Test
   public void testPrintf16() throws IOException, URISyntaxException {
      compileAndCompare("printf-16.c");
   }

   @Test
   public void testNoRecursionHeavy() throws IOException, URISyntaxException {
      compileAndCompare("no-recursion-heavy.c");
   }

   @Test
   public void testBitmapPlot2() throws IOException, URISyntaxException {
      compileAndCompare("bitmap-plot-2.c");
   }

   @Test
   public void testPlasmaUnroll() throws IOException, URISyntaxException {
      compileAndCompare("examples/c64/plasma/plasma-unroll.c");
   }

   @Test
   public void testPrimes1000() throws IOException, URISyntaxException {
      compileAndCompare("primes-1000.c");
   }

   @Test
   public void testBitmapPlot1() throws IOException, URISyntaxException {
      compileAndCompare("bitmap-plot-1.c");
   }

   @Test
   public void testSinePlotter() throws IOException, URISyntaxException {
      compileAndCompare("examples/c64/sinplotter/sine-plotter.c");
   }

   @Test
   public void testSinusSprites() throws IOException, URISyntaxException {
      compileAndCompare("examples/c64/sinsprites/sinus-sprites.c");
   }

   @Test
   public void testConioNachtScreen() throws IOException, URISyntaxException {
      compileAndCompare("examples/conio/nacht-screen.c");
   }

   @Test
   public void testScreenShowSpiral() throws IOException, URISyntaxException {
      compileAndCompare("screen-show-spiral.c");
   }

   @Test
   public void testCircleChars() throws IOException, URISyntaxException {
      compileAndCompare("circlechars.c");
   }

   @Test
   public void testPrintfSpeed() throws IOException, URISyntaxException {
      compileAndCompare("printf-speed.c");
   }

   @Test
   public void testRotate() throws IOException, URISyntaxException {
      compileAndCompare("examples/c64/rotate/rotate.c");
   }

   @Test
   public void testXMega65Logo() throws IOException, URISyntaxException {
      compileAndCompare("complex/xmega65/xmega65logo.c");
   }

   @Test
   public void testPlasma() throws IOException, URISyntaxException {
      compileAndCompare("examples/c64/plasma/plasma.c");
   }

   @Test
   public void testPaulNelsenSandbox() throws IOException, URISyntaxException {
      compileAndCompare("sandbox.c");
   }

   @Test
   public void testScreenCenterDistance() throws IOException, URISyntaxException {
      compileAndCompare("screen-center-distance.c");
   }

   @Test
   public void testNesDemo() throws IOException, URISyntaxException {
      compileAndCompare("examples/nes/nes-demo.c");
   }

   @Test
   public void testCordicAtan2Ref() throws IOException, URISyntaxException {
      compileAndCompare("cordic-atan2-16-ref.c");
   }

   @Test
   public void testSieve() throws IOException, URISyntaxException {
      compileAndCompare("sieve.c");
   }

   @Test
   public void testAtoi() throws IOException, URISyntaxException {
      compileAndCompare("atoi-1.c");
   }

   @Test
   public void testTextbox() throws IOException, URISyntaxException {
      compileAndCompare("textbox.c");
   }

   @Test
   public void testSinusGen8() throws IOException, URISyntaxException {
      compileAndCompare("sinusgen8.c");
   }

   @Test
   public void testScreenCenterAngle() throws IOException, URISyntaxException {
      compileAndCompare("screen-center-angle.c");
   }

   @Test
   public void testFastMultiply127() throws IOException, URISyntaxException {
      compileAndCompare("fastmultiply-127.c");
   }

   @Test
   public void testComparisons() throws IOException, URISyntaxException {
      compileAndCompare("test-comparisons.c", 10);
   }

   @Test
   public void testChargenAnalysis() throws IOException, URISyntaxException {
      compileAndCompare("examples/c64/chargen/chargen-analysis.c");
   }

   @Test
   public void testLineAnim() throws IOException, URISyntaxException {
      compileAndCompare("line-anim.c");
   }













}