// lazyNES print demo (using lnlist)
  // lazyNES - As lazy as possible NES hardware support library for vbcc6502
 // (happily cooperates with Shiru's famitone2 replay code)
// V1.0, 'Lazycow 2020

// Ported to KickC 2020 by Jesper Gravgaard 
// Original Source VBCC alpha 2 http://www.ibaug.de/vbcc/vbcc6502_2.zip

#pragma target(nes)
#pragma emulator("java -jar c:/c64/Nintaco/Nintaco.jar")
#include "lazynes.h"

// A string in RAM
#pragma data_seg(GameRam)
ubyte b[14];

// A string in ROM
#pragma data_seg(Data)
ubyte b_init[]={0,0,10,'B','U','B','B','L','E','S',':',0,0,lfEnd};

 // print some text in the static area using lnList
void Print(uword offset, ubyte value) {
	b[0]=(ubyte)(offset>>8)|lfHor;  b[1]=(ubyte)offset;  b[11]=b[12]='0';
	while (value>=10) { ++b[11];  value-=10; }
	while (value>=1)  { ++b[12];  value-=1; }
	lnList(b);
}

int lnMain() {
	static const ubyte bgColors[]={45,33,2};
	ubyte objects=17;
	uword tics=0;
	lnSync(lfBlank); // blank screen to enable lnPush() usage
	lnPush(lnBackCol,3,bgColors); // set background colors
	
	// Copy string from ROM to RAM
	for(char i=0;i<sizeof(b_init);i++)
		b[i] = b_init[i];

	static const char text[]="HELLO LAZYNES!";
	lnPush(lnNameTab0+32, sizeof(text)-1, text); // draw text in 2nd line

	for(;;) {
		// update the number to display
		tics+=1;  
		if (tics>8) {
			tics=0;
			objects = (objects+1)&0x3f;
		}
		// display a number
		Print(lnNameTab0+64,objects+1);		
		lnSync(0); // sync with vblank		
	}
	return 0;
}
