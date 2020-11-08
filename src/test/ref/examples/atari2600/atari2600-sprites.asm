// Minimal Atari 2600 VCS Program using Sprites
// Source: https://atariage.com/forums/blogs/entry/11109-step-1-generate-a-stable-display/
// Atari 2600 Registers and Constants
// https://web.archive.org/web/20170215054248/http://www.atariguide.com/pdfs/Atari_2600_VCS_Domestic_Field_Service_Manual.pdf
  // Atari 2600 VCS 2K ROM in A26 executable file
.file [name="atari2600-sprites.a26", type="bin", segments="Code, Data, Vectors"]
.segmentdef Code [start=$f800,min=$f800,max=$fff9]
.segmentdef Data [startAfter="Code",max=$fff9]
.segmentdef Vectors [start=$fffa,max=$ffff]
.segment Vectors
.word __start // NMI
.word __start // RESET
.word __start // IRQ
.segment Code

  // The number of CPU cycles per scanline
  .const CYCLES_PER_SCANLINE = $4c
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_COLUP0 = 6
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_GRP0 = $1b
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_NUSIZ0 = 4
  .const OFFSET_STRUCT_MOS6532_RIOT_TIM64T = $16
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC = 2
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_HMOVE = $2a
  .const OFFSET_STRUCT_MOS6532_RIOT_INTIM = 4
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_VBLANK = 1
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_COLUBK = 9
  // The TIA WSYNC register (for access from inline ASM)
  .label TIA_WSYNC = 2
  // The TIA RESP0 register (for access from inline ASM)
  .label TIA_RESP0 = $10
  // The TIA HMP0 register (for access from inline ASM)
  .label TIA_HMP0 = $20
  // Atari TIA write registers
  .label TIA = 0
  // Atari RIOT registers
  .label RIOT = $280
  // Player 0 X position
  .label p0_xpos = $82
  // Counts frames
  .label idx = $80
  // Player 0 Y position
  .label p0_ypos = $83
  .label idx2 = $81
.segment Code
__start: {
    // p0_xpos
    lda #0
    sta.z p0_xpos
    jsr main
    rts
}
main: {
    // asm
    cld
    // TIA->COLUP0 = 0xf0
    // Player 0
    // - Color
    lda #$f0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_COLUP0
    // TIA->GRP0 = 0xaf
    // - Graphics
    lda #$af
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_GRP0
    // TIA->NUSIZ0 = 0x05
    // - Size
    lda #5
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_NUSIZ0
    lda #$39
    sta.z idx2
    lda #0
    sta.z idx
  __b2:
    // TIA->VSYNC = 2
    // Vertical Sync
    // here we generate the signal that tells the TV to move the beam to the top of
    // the screen so we can start the next frame of video.
    // The Sync Signal must be on for 3 scanlines.
    lda #2
    sta TIA
    // RIOT->TIM64T = (41*CYCLES_PER_SCANLINE)/64
    // D1=1, turns on Vertical Sync signal
    lda #$29*CYCLES_PER_SCANLINE/$40
    sta RIOT+OFFSET_STRUCT_MOS6532_RIOT_TIM64T
    // TIA->WSYNC = 0
    // Set timer to wait 41 lines
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    // Wait for Sync - halts CPU until end of 1st scanline of VSYNC
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    // wait until end of 2nd scanline of VSYNC
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    // TIA->VSYNC = 0
    // wait until end of 3rd scanline of VSYNC
    sta TIA
    // asm
    // Vertical Sprite Position Player 0 - inline ASM to achieve cycle exact code
    lda p0_xpos
    sta TIA_WSYNC
    sec
  !:
    sbc #$f
    bcs !-
    eor #7
    asl
    asl
    asl
    asl
    sta TIA_HMP0
    sta TIA_RESP0
    // p0_xpos = SINTABLE_160[idx++]
    ldy.z idx
    lda SINTABLE_160,y
    sta.z p0_xpos
    // p0_xpos = SINTABLE_160[idx++];
    inc.z idx
    // p0_ypos = SINTABLE_160[idx2++]
    ldy.z idx2
    lda SINTABLE_160,y
    sta.z p0_ypos
    // p0_ypos = SINTABLE_160[idx2++];
    inc.z idx2
    // TIA->WSYNC = 0
    // Execute horisontal movement
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    // TIA->HMOVE = 0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_HMOVE
  // Wait for the timer to run out
  __b3:
    // while(RIOT->INTIM)
    lda #0
    cmp RIOT+OFFSET_STRUCT_MOS6532_RIOT_INTIM
    bne __b4
    // TIA->VBLANK = 0
    // Screen - display logic
    // Update the registers in TIA (the video chip) in order to generate what the player sees.
    // For now we're just going to output 192 colored scanlines lines so we have something to see.
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_VBLANK
    // TIA->COLUBK = 0x0
    // D1=1, turns off Vertical Blank signal (image output on)
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_COLUBK
    tay
    ldx #1
  __b6:
    // for(char i=1;i<192;i++)
    cpx #$c0
    bcc __b7
    // TIA->WSYNC = 0
    // Start OverScan
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    // TIA->VBLANK = 2
    // Wait for SYNC (halts CPU until end of scanline)
    lda #2
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_VBLANK
    // TIA->COLUBK = 0
    // D1=1 turns image output off
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_COLUBK
    // RIOT->TIM64T = (27*CYCLES_PER_SCANLINE)/64
    // Set background color to black
    lda #$1b*CYCLES_PER_SCANLINE/$40
    sta RIOT+OFFSET_STRUCT_MOS6532_RIOT_TIM64T
  // Wait for the timer to run out
  __b13:
    // while(RIOT->INTIM)
    lda #0
    cmp RIOT+OFFSET_STRUCT_MOS6532_RIOT_INTIM
    bne __b14
    jmp __b2
  __b14:
    // TIA->WSYNC = 0
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    jmp __b13
  __b7:
    // Wait for SYNC (halts CPU until end of scanline)
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    // TIA->COLUBK = i
    stx TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_COLUBK
    // if(p0_idx)
    cpy #0
    bne __b9
    // if(p0_ypos==i)
    cpx.z p0_ypos
    bne __b10
    ldy #1
    jmp __b10
  __b1:
    ldy #0
  __b10:
    // for(char i=1;i<192;i++)
    inx
    jmp __b6
  __b9:
    // gfx = SPRITE_C[p0_idx]
    // Player 0 is active - show it
    lda SPRITE_C,y
    // TIA->GRP0 = gfx
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_GRP0
    // if(gfx==0)
    cmp #0
    beq __b1
    // p0_idx++;
    iny
    jmp __b10
  __b4:
    // TIA->WSYNC = 0
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    jmp __b3
}
.segment Data
  // Sine table
SINTABLE_160:
.fill $100, 10+round(64.5+64.5*sin(2*PI*i/256))

  // The letter C
  SPRITE_C: .byte 0, $18, $18, $18, $18, $3c, $3c, $3c, $3c, $66, $66, $66, $66, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $66, $66, $66, $66, $3c, $3c, $3c, $3c, $18, $18, $18, $18, 0
