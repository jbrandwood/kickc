// lazyNES lazyhello demo

// Ported to KickC 2020 by Jesper Gravgaard 
// Original Source VBCC alpha 2 http://www.ibaug.de/vbcc/vbcc6502_2.zip

#pragma target(nes)
#include "lazynes.h"

int lnMain() {
	static const ubyte bgColors[] = { 0x02, 0x33 }; 
	static const char text[]="HELLO LAZYNES!";
	lnSync(lfBlank);                 // blank screen to enable lnPush()
	lnPush(lnBackCol, sizeof(bgColors), bgColors);   // set colors, always directly after lnSync()
	lnPush(lnNameTab0+32, sizeof(text)-1, text); // draw text in 2nd line
	lnSync(0);                    // sync with vblank, unblank screen
	return 0;
}
