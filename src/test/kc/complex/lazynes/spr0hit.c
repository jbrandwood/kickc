// lazyNES spite 0 hit demo. Demonstrates sprite 0 raster NMI with different scroll values
  // lazyNES - As lazy as possible NES hardware support library for vbcc6502
 // (happily cooperates with Shiru's famitone2 replay code)
// V1.0, 'Lazycow 2020

// Ported to KickC 2020 by Jesper Gravgaard 
// Original Source VBCC alpha 2 http://www.ibaug.de/vbcc/vbcc6502_2.zip

#pragma target(nes)
#pragma emulator("java -jar c:/c64/Nintaco/Nintaco.jar")
#include "lazynes.h"


int lnMain() {

	static const ubyte bgColors[]={45,33,2};
	static const ubyte bubblesPal[]={ 0, 37,22,5, 0, 42,26,10, 0, 33,18,3 };
	static const ubyte bubbles[]={ // x-offset, y-offset, tile, palette+flags
		0,0,7,0,  8,0,9,0,  128, // 16x16, red,   offset 0
		0,0,7,1,  8,0,9,1,  128, // 16x16, green, offset 9
		0,0,7,2,  8,0,9,2,  128, // 16x16, blue,  offest 18
		0,4,11,0,128, // 8x8, red,   offset 27 
		0,4,11,1,128, // 8x8, green, offset 32
		0,4,10,2,128, // 8x8, blue,  offset 37
	},
	bubbleTab[]={0,27,9,32,18,37}; // start offsets in bubbles[]

	static const ubyte bubble0[] = { 0,4,10,2,128 }; // x-offset, y-offset, tile, palette+flags

	ubyte i;
	uword hScroll=0;
	sbyte hVel=0, hDir=1;

	lnSync(lfBlank); // blank screen to enable lnPush() usage
	lnPush(lnBackCol,3,bgColors); // set background colors
	lnPush(lnSprPal0,3,&bubblesPal[1]); // set sprite colors
	lnPush(lnSprPal1,3,&bubblesPal[5]);
	lnPush(lnSprPal2,3,&bubblesPal[9]);
	//TODO: lnPPUCTRL|=32; // Select 8x16 sprites; has to be set after calling lnSync()!
	
	{
		static const ubyte g1[]={1}, g2[]={2,3,4,5}, g3[]={6,7,8,9};
		ubyte x;
		// draw a line
		i=2;  for (x=0;x<32;x+=1) lnPush(lnNameTab0+((uword)i<<5)+x,1,g1);
		// draw some diamond shapes
		for (i=8;i<=24;i+=4) for (x=0;x<4;x+=1) {
			lnPush(lnNameTab0+((uword)i<<5)+12+x*4,4,g2);
			lnPush(lnNameTab0+32+((uword)i<<5)+12+x*4,4,g3);
		}
	}

	while(1) {
		lnScroll(0,0); // reset scrolling offsets of area above split
		//lnScroll(hScroll>>6,32); // set scrolling offsets of area below split
		hVel+=hDir;  if (hVel>64 || hVel<-64) hDir=-hDir;
		hScroll+=hVel;
		
		// add 1st sprite (SPR0) at a fixed position on top of background blocks
		// mandatory for the SPR0HIT check later with lnSync(lfSplit)
		lnAddSpr(&bubbles[bubbleTab[5]],16,16);
		//TODO: lnSpr0Wait=55; // delay the set of scrolling registers a bit
		
		lnSync(lfSplit); // sync with vblank, activate SPR0HIT splitscreen
	}

	return 0;
}
