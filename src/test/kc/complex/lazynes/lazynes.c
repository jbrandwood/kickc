  // lazyNES - As lazy as possible NES hardware support library for vbcc6502
 // (happily cooperates with Shiru's famitone2 replay code)
// V1.0, 'Lazycow 2020
// Ported to KickC 2020 by Jesper Gravgaard 
// Original Source VBCC aplha 2 http://www.ibaug.de/vbcc/vbcc6502_2.zip

#include "lazynes.h"
#include <nes.h>

   // Wait for next vblank
  // flags: 0, lfBlank or lfSplit (see below)
 // result: Amount of frames since last sync [0..31], 128 is added on NTSC
//
ubyte lnSync(ubyte flags) {
    // Enable video output if lfBlank not set
    if(!(flags&lfBlank))
        enableVideoOutput();    
    // Wait for V-Blank
    waitForVBlank();
    // Disable video output if lfBlank set
    if(flags&lfBlank)
        // lfBlank = 1, activates blank mode, blanks screen and allows lnPush() calls
        disableVideoOutput();

    // TODO: Handle lfSplit = 2 : activates split mode, NMI waits for SPR0HIT and sets registers
   // TODO: Count frames
    return 0;
}

     // Write data into nametables, palettes, CHRRAM, etc.
    //  (System must be in blank mode!)
   // o: Destination address offset in vram
  //  a: Amount of bytes that should be written
 //   p: Pointer to data
//
void lnPush(uword o, ubyte a, void* s) {
    ppuDataTransfer(o, s, a);
}

   // Write data into nametables, palettes, CHRRAM, etc.
  //  (Screen has to be visible, doesn't work in blank mode!)
 // updateList: Pointer to update list
//
// TODO: void lnList(void* updateList);
// TODO:   enum { lfHor=64, lfVer=128, lfEnd=255 };

	// remarks:
	// - The format of the update list is an array of unsigned bytes.
	// - There can be 3 different commands in the update list:
	//   a) addressHi, addressLo, value
	//   b) addressHi|lfHor, addressLo, amountOfBytes, byte1, byte2, byte3, ...
	//   c) addressHi|lfVer, addressLo, amountOfBytes, byte1, byte2, byte3, ...
	// - Multiple commands can be queued in one list,
	//   but there can only be one activated updatelist at a time.
	// - The end of the list is marked by lfEnd! (important!)
	// - It's the same format that's used in set_vram_update() of Shiru's neslib


   // Scroll background
  // x: New horizotnal scrolling offset in pixels, allowed range: [0..511]
 //  y: New vertical scrolling offset in pixels, allowed range: [0..479]
//
// TODO: void lnScroll(uword x, uword y);
	//
	// remarks:
	// - If a SPR0HIT based splitscreen is used, the 1st call of lnScroll() sets
	//   the scrolling offsets of the area above the split and the 2nd call of
	//   lnScroll() sets the scrolling offsets of the area below the split.


    // Add meta-sprite to display list
   //    p: Pointer to metasprite data
  //   x,y: Sprite coordinates
 // result: New position offset in OAM after the meta sprite has been added
//
// TODO: ubyte lnAddSpr(void* p, sword x, sword y);
	//
	// remarks:
	// - The format for the metasprite data is an array of unsigned bytes.
	// - Four bytes per sprite: x-offset, y-offset, tile, attributes
	// - The end of the list is marked by the value 128! (important!)
	// - It's the same format that's used in oam_meta_spr() from Shiru's neslib


   // Query joypad state
  //  port: Joypad port (1 or 2)
 // result: Set of joypad flags (see below)
//
ubyte lnGetPad(ubyte port) {
    return readJoy1();
}

  //
 // advanced usage
//

__zp volatile ubyte
	lnSpr0Wait,  // delay until scroll registers will be set after a SPR0HIT
	lnPPUCTRL,  // current value of PPUCTRL register (will be written in NMI)
	lnPPUMASK; // current value of PPUMASK register (will be written in NMI)
	//
	// remark: The lazyNES NMI will write the PPUCTRL and PPUMASK registers,
	//         so don't write PPUCTRL and PPUMASK directly - use these two
	//         variables insead. Their values will be written in the next NMI.
	//         Also, don't use these variables before the 1st call of lnSync()!
