// lazyNES balloon demo
  // lazyNES - As lazy as possible NES hardware support library for vbcc6502
 // (happily cooperates with Shiru's famitone2 replay code)
// V1.0, 'Lazycow 2020

// Ported to KickC 2020 by Jesper Gravgaard 
// Original Source VBCC alpha 2 http://www.ibaug.de/vbcc/vbcc6502_2.zip

#pragma target(nes)
#pragma emulator("java -jar c:/c64/Nintaco/Nintaco.jar")
#include "lazynes.h"

int lnMain() {
	static const ubyte bgColors[]={2,33}; 
	static const ubyte sprPal0[]={33};
	static const ubyte balloonData[]={
		0,0,0,0,  // balloon is build out of 6 sprites, 4 bytes define a sprite
		8,0,1,0, // x-offset, y-offset, tile, palette + flags
		0,8,2,0,
		8,8,3,0,
		0,16,4,0,
		8,16,5,0,
		128 // end of list marker (important!)
	};

	sword x=0, y=0;

	// To avoid glitches, always write color palettes immediately after lnSync()!
	lnSync(lfBlank);                // blank screen to enable lnPush() usage
	lnSync(lfBlank);               // blank screen to enable lnPush() usage
	lnPush(lnBackCol,2,bgColors); // set colors, always directly after lnSync()!
	lnPush(lnSprPal0,1,sprPal0); // set sprite colors

	while(1) {
		ubyte j=lnGetPad(1); // query 1st joypad
		if (0==j) { // automatic movement?
			x+=1;  if (x>=240) x=0;
			y+=1;  if (y>=240) y=0;
		} 
		if (j&lfL) x-=1; else if (j&lfR) x+=1;  // move left/right?
		if (j&lfU) y-=1; else if (j&lfD) y+=1; // move up/down?
		lnAddSpr(balloonData,x,y); // add meta sprite to display list
		lnSync(0);                // sync with vblank
	}

	return 0;
}
