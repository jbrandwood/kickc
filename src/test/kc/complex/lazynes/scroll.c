// lazyNES scroll demo
  // lazyNES - As lazy as possible NES hardware support library for vbcc6502
 // (happily cooperates with Shiru's famitone2 replay code)
// V1.0, 'Lazycow 2020

// Ported to KickC 2020 by Jesper Gravgaard 
// Original Source VBCC alpha 2 http://www.ibaug.de/vbcc/vbcc6502_2.zip

#pragma target(nes)
#include "lazynes.h"

int lnMain() {
	static const ubyte bgColors[]={45,33,2};
	ubyte i;
	uword hScroll=0;
	sbyte hVel=0, hDir=1;
	lnSync(lfBlank); // blank screen to enable lnPush() usage
	lnPush(lnBackCol,3,bgColors); // set background colors
	   // draw some backgrounds
	{ //
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
	for(;;) {
		lnScroll(hScroll>>6,0); // set scrolling offsets
		hVel+=hDir;  if (hVel>64 || hVel<-64) hDir=-hDir;
		hScroll+=hVel;
		lnSync(0); 
	}
	return 0;
}
