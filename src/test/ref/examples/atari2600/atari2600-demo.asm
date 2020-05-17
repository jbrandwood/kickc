// Demonstration Atari 2600 VCS Program
// Source: https://atariage.com/forums/blogs/entry/11109-step-1-generate-a-stable-display/
  // Atari 2600 VCS 4K ROM
.file [name="atari2600-demo.a26", type="bin", segments="Code, Data, Vectors"]
.segmentdef Code [start=$f800,min=$f800,max=$fff9]
.segmentdef Data [startAfter="Code",max=$fff9]
.segmentdef Vars [start=$80,max=$ff, virtual]
.segmentdef Vectors [start=$fffa,max=$ffff]
.segment Vectors
.word main // NMI
.word main // RESET
.word main // IRQ
.segment Code

  .const OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC = 2
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_VBLANK = 1
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_COLUBK = 9
  // Atari TIA write registers
  .label TIA = 0
.segment Code
main: {
    lda #0
    sta idx
  __b2:
    // TIA->VSYNC = 2
    // Vertical Sync
    // here we generate the signal that tells the TV to move the beam to the top of
    // the screen so we can start the next frame of video.
    // The Sync Signal must be on for 3 scanlines.
    lda #2
    sta TIA
    // TIA->WSYNC = 0
    // Accumulator D1=1, turns on Vertical Sync signal
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    // Wait for Sync - halts CPU until end of 1st scanline of VSYNC
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    // wait until end of 2nd scanline of VSYNC
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    // TIA->VSYNC = 0
    // wait until end of 3rd scanline of VSYNC
    sta TIA
    tax
  // Vertical Blank - game logic
  // Since we don't have any yet, just delay 
  __b3:
    // for(char i=0;i<37;i++)
    cpx #$25
    bcc __b4
    // TIA->VBLANK = 0
    // Screen - display logic
    // Update the registers in TIA (the video chip) in order to generate what the player sees.  
    // For now we're just going to output 192 colored scanlines lines so we have something to see.
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_VBLANK
    // c = SINTABLE[idx++]
    // D1=1, turns off Vertical Blank signal (image output on)
    ldy idx
    ldx SINTABLE,y
    inc idx
    tay
  __b6:
    // for(char i=0;i<192;i++)
    cpy #$c0
    bcc __b7
    // TIA->WSYNC = 0
    // Overscan - game logic
    // Since we don't have any yet, just delay 
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    // TIA->VBLANK = 2
    // Wait for SYNC (halts CPU until end of scanline)
    lda #2
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_VBLANK
    // TIA->COLUBK = 0
    // // D1=1 turns image output off
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_COLUBK
    tax
  __b9:
    // for(char i=0;i<30;i++)
    cpx #$1e
    bcc __b10
    jmp __b2
  __b10:
    // TIA->WSYNC = 0
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    // for(char i=0;i<30;i++)
    inx
    jmp __b9
  __b7:
    // TIA->WSYNC = 0
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    // TIA->COLUBK = c++
    // Wait for SYNC (halts CPU until end of scanline)
    stx TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_COLUBK
    // TIA->COLUBK = c++;
    inx
    // for(char i=0;i<192;i++)
    iny
    jmp __b6
  __b4:
    // TIA->WSYNC = 0
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    // for(char i=0;i<37;i++)
    inx
    jmp __b3
}
.segment Data
  .align $100
SINTABLE:
.fill $100, round(127.5+127.5*sin(2*PI*i/256))

.segment Vars
  idx: .byte 0
