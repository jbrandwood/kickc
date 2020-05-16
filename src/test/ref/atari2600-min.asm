// Minimal Atari 2600 VCS Program
  // Atari 2600 VCS 4K ROM
.file [name="atari2600-min.prg", type="bin", segments="Code, Vectors"]
.segmentdef Code [start=$f800,min=$f800,max=$fff9]
.segmentdef Data [start=$80,max=$ff, virtual]
.segmentdef Vectors [start=$fffa,max=$ffff]
.segment Vectors
.word main // NMI
.word main // RESET
.word main // IRQ
.segment Code

  .label VSYNC = 0
  .label VBLANK = 1
  .label WSYNC = 2
  .label BACKGROUND_COLOR = 9
.segment Code
main: {
    lda #0
    sta col
  __b2:
    // *WSYNC = 2
    // Vertical Sync
    // here we generate the signal that tells the TV to move the beam to the top of
    // the screen so we can start the next frame of video.
    // The Sync Signal must be on for 3 scanlines.
    lda #2
    sta WSYNC
    // *VSYNC = 2
    // Wait for SYNC (halts CPU until end of scanline)
    sta VSYNC
    // *WSYNC = 2
    // Accumulator D1=1, turns on Vertical Sync signal
    sta WSYNC
    // Wait for Sync - halts CPU until end of 1st scanline of VSYNC
    sta WSYNC
    // *WSYNC = 0
    // wait until end of 2nd scanline of VSYNC
    lda #0
    sta WSYNC
    // *VSYNC = 0
    // wait until end of 3rd scanline of VSYNC
    sta VSYNC
    tax
  // Vertical Blank - game logic
  // Since we don't have any yet, just delay 
  __b3:
    // for(char i=0;i<37;i++)
    cpx #$25
    bcc __b4
    // *VBLANK = 0
    // Screen - display logic
    // Update the registers in TIA (the video chip) in order to generate what the player sees.  
    // For now we're just going to output 192 colored scanlines lines so we have something to see.
    lda #0
    sta VBLANK
    // c = col++
    // D1=1, turns off Vertical Blank signal (image output on)
    ldx col
    inc col
    tay
  __b6:
    // for(char i=0;i<192;i++)
    cpy #$c0
    bcc __b7
    // *WSYNC = 0
    // Overscan - game logic
    // Since we don't have any yet, just delay 
    lda #0
    sta WSYNC
    // *VBLANK = 2
    // Wait for SYNC (halts CPU until end of scanline)
    lda #2
    sta VBLANK
    // *BACKGROUND_COLOR = 0
    // // D1=1 turns image output off
    lda #0
    sta BACKGROUND_COLOR
    tax
  __b9:
    // for(char i=0;i<07;i++)
    cpx #7
    bcc __b10
    jmp __b2
  __b10:
    // *WSYNC = 0
    lda #0
    sta WSYNC
    // for(char i=0;i<07;i++)
    inx
    jmp __b9
  __b7:
    // *WSYNC = 0
    lda #0
    sta WSYNC
    // *BACKGROUND_COLOR = c++
    // Wait for SYNC (halts CPU until end of scanline)
    stx BACKGROUND_COLOR
    // *BACKGROUND_COLOR = c++;
    inx
    // for(char i=0;i<192;i++)
    iny
    jmp __b6
  __b4:
    // *WSYNC = 0
    lda #0
    sta WSYNC
    // for(char i=0;i<37;i++)
    inx
    jmp __b3
}
.segment Data
  col: .byte 0
