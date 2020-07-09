  // lazyNES - As lazy as possible NES hardware support library for vbcc6502
 // (happily cooperates with Shiru's famitone2 replay code)
// V1.0, 'Lazycow 2020
// Ported to KickC 2020 by Jesper Gravgaard 
// Original Source VBCC aplha 2 http://www.ibaug.de/vbcc/vbcc6502_2.zip

#include "lazynes.h"
#include <nes.h>

// Tile Set (in CHR ROM)
#pragma data_seg(Tiles)
export char TILES[] = kickasm(resource "example.chr", resource "sprites.chr") {{
	.import binary "example.chr"
	.import binary "sprites.chr"
}};

// Interrupt Vectors (in PRG ROM)
#pragma data_seg(Vectors)
export void()* const VECTORS[] = { 
    // NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
    &vblank, 
    // RESET Called when the NES is reset, including when it is turned on.
    &main, 
    // IRQ Called when a BRK instruction is executed.
    0 
};

// RESET Called when the NES is reset, including when it is turned on.
void main() {
    // Initialize NES after RESET
    initNES();
    // Clear the name table
    ppuDataFill(PPU_NAME_TABLE_0, 0, 0x3c0);
    // Fill the PPU attribute table
    ppuDataFill(PPU_ATTRIBUTE_TABLE_0, 0, 0x40);    
    // move all sprites off the screen    
    for(char i=0;i!=0x40;i++)
        SPRITE_BUFFER[i].y = 0xff;
    // Enable screen rendering and vblank
    // Set sprite tileset to upper - enable vblank NMI
    PPU->PPUCTRL = 0b10001000;
    // Enable sprite and tile rendering
    PPU->PPUMASK = 0b00011110; 
    // Reset scroll
    scroll_x = scroll_y = 0;
    // Execute lazynes main code
    lnMain();
    // Infinite loop
    while(1) ;
}

// Sprite Buffer (in GAME RAM)
// Will be transferred to the PPU via DMA during vblank
#pragma data_seg(GameRam)
struct SpriteData align(0x100) SPRITE_BUFFER[0x40];

// Data (in PRG ROM)
#pragma data_seg(Data)

// Index of the next SpriteData in SPRITE_BUFFER to write to in lnAddSpr()
volatile char add_sprite_idx;

// Counts the vblanks between syncs
volatile char vblank_count;

// The current mode set by lnSync. 
//	lfBlank = 1,  activates blank mode, blanks screen and allows lnPush() calls
//	lfSplit = 2   activates split mode, NMI waits for SPR0HIT and sets registers
volatile char sync_mode;

// Signal when vblank occurs. The NMI sets this to zero. To wait for a vblank set this no non-zero and wait for it to become zero.
volatile char vblank_signal;

// Scroll x-position
volatile char scroll_x;
// Scroll y-position
volatile char scroll_y;

// Update list with data to be moved to VRAM during blank
// The data is moved by when lnSync() is called
// - The format of the update list is an array of unsigned bytes.
// - There can be 3 different commands in the update list:
//   a) addressHi, addressLo, value
//   b) addressHi|lfHor, addressLo, amountOfBytes, byte1, byte2, byte3, ...
//   c) addressHi|lfVer, addressLo, amountOfBytes, byte1, byte2, byte3, ...
// - Multiple commands can be queued in one list,
//   but there can only be one activated updatelist at a time.
// - The end of the list is marked by lfEnd! (important!)
// - It's the same format that's used in set_vram_update() of Shiru's neslib
// See https://nesdoug.com/2017/04/13/my-neslib-notes/
char * volatile vram_update_list;

// NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
interrupt(hardware_stack) void vblank() {
    // DMA transfer the entire sprite buffer to the PPU
    ppuSpriteBufferDmaTransfer(SPRITE_BUFFER);
    // Set scroll
    PPU->PPUSCROLL = scroll_x;
    PPU->PPUSCROLL = scroll_y;
    // count vblanks
    vblank_count++;
    // send vblank signal
    vblank_signal = 0;
}

   // Wait for next vblank
  // flags: 0, lfBlank or lfSplit (see below)
 // result: Amount of frames since last sync [0..31], 128 is added on NTSC
//	lfBlank = 0,  disables blank mode (if set), wait for vblank
//	lfBlank = 1,  activates blank mode, blanks screen and allows lnPush() calls
//	lfSplit = 2   activates split mode, NMI waits for SPR0HIT and sets registers
ubyte lnSync(ubyte flags) {
    // Is video output enabled (lfBlank==0)
    if(!(flags&lfBlank)) {
        // Move remaining sprites off the screen
        for(char i=add_sprite_idx;i!=0x40;i++)
            SPRITE_BUFFER[i].y = 0xff;
        // Reset add sprite index
        add_sprite_idx = 0;
        // Enable video output (if it was disabled)
        if(sync_mode&lfBlank) {
            // Set sprite tileset to upper - enable vblank NMI
            PPU->PPUCTRL = 0b10001000;
            // Enable sprite and tile rendering
            PPU->PPUMASK = 0b00011110;    
        }
    }
    
    // Wait for V-Blank signal from the NMI (if vblank is currently enabled)
    if(!(sync_mode&lfBlank)) {
        vblank_signal = 0xff;
        while(vblank_signal) ;
    }

    // Disable video output if lfBlank set
    if(flags&lfBlank) {
        // lfBlank = 1, activates blank mode, blanks screen and allows lnPush() calls
        // Disable vertical blank interrupt
        PPU->PPUCTRL = 0;
        // Disable sprite rendering
        PPU->PPUMASK = 0;
    }

    // Update the mode
    sync_mode = flags;

    // Move any pending data to the VRAM
    lnListTransfer();

    // TODO: Handle lfSplit = 2 : activates split mode, NMI waits for SPR0HIT and sets registers

    // Return number of vblank since last sync
    char res = vblank_count;
    vblank_count = 0;
    return res;
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

   // Plan a write of data into nametables, palettes, CHRRAM, etc.
   // The data will be written next time lnSync() is called.
  //  (Screen has to be visible, doesn't work in blank mode!)
 // updateList: Pointer to update list
//
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
// See https://nesdoug.com/2017/04/13/my-neslib-notes/
void lnList(void* update_list) {
    vram_update_list = update_list;
}

// Execute any planned transfer of data into nametables, palettes, CHRRAM, etc. by lnList()
void lnListTransfer() {
    if(vram_update_list) {
        // Index into the update list (assumes no more than 256 bytes)
        char idx = 0;
        for(;;) {
            char addrHi = vram_update_list[idx++];
            // Have we reached the end of the lsit
            if(addrHi==0xff) break;
            if(addrHi&lfHor) {
                // The write is horizontal
                char addrLo = vram_update_list[idx++];
                char* ppuAddr = (char*)(uword){ addrHi&0x3f, addrLo };
                char size = vram_update_list[idx++];
                ppuDataTransfer(ppuAddr, vram_update_list+idx, size);
                idx += size;
            } else if(addrHi&lfVer) {
                // The write is vertical
                char addrLo = vram_update_list[idx++];
                char* ppuAddr = (char*)(uword){ addrHi&0x3f, addrLo };
                char size = vram_update_list[idx++];
                // Set vertical mode ibit in PPUCTRL
                char ppuCtrl = PPU->PPUCTRL;
                PPU->PPUCTRL = ppuCtrl|4;
                ppuDataTransfer(ppuAddr, vram_update_list+idx, size);
                // restore PPUCTRL
                PPU->PPUCTRL = ppuCtrl;
                idx += size;
            } else {
                // The write is single-byte
                char addrLo = vram_update_list[idx++];
                char* ppuAddr = (char*)(uword){ addrHi, addrLo };
                char value = vram_update_list[idx++];
                ppuDataSet(ppuAddr, value);
            }
        }
        // Set update list to zero
        vram_update_list = 0;
    }
}



   // Scroll background
  // x: New horizotnal scrolling offset in pixels, allowed range: [0..511]
 //  y: New vertical scrolling offset in pixels, allowed range: [0..479]
//
// remarks:
// - If a SPR0HIT based splitscreen is used, the 1st call of lnScroll() sets
//   the scrolling offsets of the area above the split and the 2nd call of
//   lnScroll() sets the scrolling offsets of the area below the split.
void lnScroll(uword x, uword y) {
    scroll_x = <x;
    scroll_y = <y;
}

    // Add meta-sprite to display list
   //    p: Pointer to metasprite data
  //   x,y: Sprite coordinates
 // result: New position offset in OAM after the meta sprite has been added
// remarks:
// - The format for the metasprite data is an array of unsigned bytes.
// - Four bytes per sprite: x-offset, y-offset, tile, attributes
// - The end of the list is marked by the value 128! (important!)
// - It's the same format that's used in oam_meta_spr() from Shiru's neslib
ubyte lnAddSpr(void* p, sword x, sword y) {
    char* ptr = p; 
    while(*ptr!=128) {
        SPRITE_BUFFER[add_sprite_idx].x = (char) (x+ptr[0]);
        SPRITE_BUFFER[add_sprite_idx].y = (char) (y+ptr[1]);
        SPRITE_BUFFER[add_sprite_idx].tile = ptr[2];
        SPRITE_BUFFER[add_sprite_idx].attributes = ptr[3];
        // Temporary debug code to detect bug with vblanking in balloon.c
        if(add_sprite_idx>=6) SPRITE_BUFFER[add_sprite_idx].tile = 6;
        ptr+=4;
        add_sprite_idx++;
    }
    return add_sprite_idx*4;
}

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

// TODO: __zp volatile ubyte
// TODO: 	lnSpr0Wait,  // delay until scroll registers will be set after a SPR0HIT
// TODO: 	lnPPUCTRL,  // current value of PPUCTRL register (will be written in NMI)
// TODO: 	lnPPUMASK; // current value of PPUMASK register (will be written in NMI)
	//
	// remark: The lazyNES NMI will write the PPUCTRL and PPUMASK registers,
	//         so don't write PPUCTRL and PPUMASK directly - use these two
	//         variables insead. Their values will be written in the next NMI.
	//         Also, don't use these variables before the 1st call of lnSync()!
