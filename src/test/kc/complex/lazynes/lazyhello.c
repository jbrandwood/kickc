// lazyNES lazyhello demo
  // lazyNES - As lazy as possible NES hardware support library for vbcc6502
 // (happily cooperates with Shiru's famitone2 replay code)
// V1.0, 'Lazycow 2020

// Ported to KickC 2020 by Jesper Gravgaard 
// Original Source VBCC alpha 2 http://www.ibaug.de/vbcc/vbcc6502_2.zip

#pragma target(nes)
#pragma emulator("java -jar c:/c64/Nintaco/Nintaco.jar")

#include "lazynes.h"

int lnMain() {
	static const ubyte bgColors[] = { 0x02, 0x33 }; 
	static const char text[]="HELLO LAZYNES!";
	lnSync(lfBlank);                 // blank screen to enable lnPush()
	lnPush(lnBackCol, sizeof(bgColors), bgColors);   // set colors, always directly after lnSync()
	lnPush(lnNameTab0+32, sizeof(text)-1, text); // draw text in 2nd line
	while(1)
		lnSync(0);                    // sync with vblank, unblank screen
	return 0;
}
