// A simple SID music player playing music in the main loop.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label MUSIC = $1000
  // Load the SID
  .const music = LoadSid("toiletrensdyr.sid")

// Place the SID into memory
// Play the music 
main: {
    // Initialize the music
    jsr music.init
  // Wait for the RASTER
  __b1:
    lda #$fd
    cmp RASTER
    bne __b1
    inc BORDERCOL
    // Play the music
    jsr music.play
    dec BORDERCOL
    jmp __b1
}
.pc = MUSIC "MUSIC"
  .fill music.size, music.getData(i)

