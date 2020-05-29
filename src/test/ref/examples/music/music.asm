// A simple SID music player playing music in the main loop.
// Commodore 64 Registers and Constants
// The MOS 6526 Complex Interface Adapter (CIA)
// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  // The VIC-II MOS 6567/6569
  .label VICII = $d000
  .label MUSIC = $1000
  // kickasm
  // Load the SID
  .const music = LoadSid("toiletrensdyr.sid")

// Place the SID into memory
// Play the music 
main: {
    // asm
    // Initialize the music
    jsr music.init
  // Wait for the RASTER
  __b1:
    // while (VICII->RASTER != $fd)
    lda #$fd
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    bne __b1
    // (VICII->BORDER_COLOR)++;
    inc VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // asm
    // Play the music
    jsr music.play
    // (VICII->BORDER_COLOR)--;
    dec VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    jmp __b1
}
.pc = MUSIC "MUSIC"
  .fill music.size, music.getData(i)

