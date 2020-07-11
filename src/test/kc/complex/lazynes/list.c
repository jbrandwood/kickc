// lazyNES lnlist demo
  // lazyNES - As lazy as possible NES hardware support library for vbcc6502
// V1.0, 'Lazycow 2020

// Ported to KickC 2020 by Jesper Gravgaard 
// Original Source VBCC alpha 2 http://www.ibaug.de/vbcc/vbcc6502_2.zip

#pragma target(nes)
#pragma emulator("java -jar c:/c64/Nintaco/Nintaco.jar")
#include "lazynes.h"

#pragma data_seg(GameRam)
ubyte list[64];
#pragma data_seg(Data)

void lnMain() {
    // Set-up an update list in the lnList() format
	uword offset1 = lnNameTab0+96+4; 
	uword offset2 = lnNameTab0+96+2; 
	uword offset3 = lnNameTab0+160+2; 
	list[0]=(ubyte)(offset1>>8)|lfHor;  // PPU address hi - horizontal
    list[1]=(ubyte)offset1;            	// PPU address lo
    list[2]=3;                     		// Size
    list[3] = 'R';                 		// Data
    list[4] = 'X';                 		// Data
    list[5] = '0';                 		// Data
	list[6]=(ubyte)(offset2>>8);     	// PPU address hi - single
    list[7]=(ubyte)offset2;            	// PPU address lo
    list[8]='X';                     	// Size
	list[9]=(ubyte)(offset3>>8)|lfVer;  // PPU address hi - vertical
    list[10]=(ubyte)offset3;            // PPU address lo
    list[11]=3;                     	// Size
    list[12] = 'R';                 	// Data
    list[13] = 'X';                 	// Data
    list[14] = '0';                 	// Data
    list[15] = lfEnd;               	// End transfer

	static const ubyte bgColors[]={45,33,2};
	static const char text[]="HELLO LAZYNES!";

	lnSync(lfBlank); // blank screen to enable lnPush() usage
	lnPush(lnBackCol,3,bgColors); // set background colors
	lnPush(lnNameTab0+32,14,text); // draw text in 2nd line

	for (;;) {
		// Update the list with dynamic values
		list[5] = ((list[5]+1)&7)+'0';
		list[8] = ((list[8]+1)&7)+'0';
		list[14] = ((list[14]+1)&7)+'0';
		lnList(list); // Send the list
		lnSync(0); // sync with vblank
	}

}
