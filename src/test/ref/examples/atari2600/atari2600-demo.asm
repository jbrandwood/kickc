// Minimal Atari 2600 VCS Program
// Source: https://atariage.com/forums/blogs/entry/11109-step-1-generate-a-stable-display/
// Atari 2600 Registers and Constants
// https://web.archive.org/web/20170215054248/http://www.atariguide.com/pdfs/Atari_2600_VCS_Domestic_Field_Service_Manual.pdf
  // Atari 2600 VCS 2K ROM in A26 executable file
.file [name="atari2600-demo.a26", type="bin", segments="Code, Data, Vectors"]
.segmentdef Code [start=$f800,min=$f800,max=$fff9]
.segmentdef Data [startAfter="Code",max=$fff9]
.segmentdef Vectors [start=$fffa,max=$ffff]
.segment Vectors
.word main // NMI
.word main // RESET
.word main // IRQ
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_PF0 = $d
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_PF1 = $e
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_PF2 = $f
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_COLUPF = 8
  .const OFFSET_STRUCT_MOS6532_RIOT_TIM64T = $16
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC = 2
  .const OFFSET_STRUCT_MOS6532_RIOT_INTIM = 4
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_VBLANK = 1
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_COLUBK = 9
  .const OFFSET_STRUCT_ATARI_TIA_WRITE_HMOVE = $2a
  // Atari TIA write registers
  .label TIA = 0
  // Atari RIOT registers
  .label RIOT = $280
  // Counts frames
  .label idx = $80
.segment Code
main: {
    // TIA->PF0 = 0b10100000
    lda #$a0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_PF0
    // TIA->PF1 = 0b01010101
    lda #$55
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_PF1
    // TIA->PF2 = 0b10101010
    lda #$aa
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_PF2
    // TIA->COLUPF = 0x55
    lda #$55
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_COLUPF
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
    // RIOT->TIM64T = (41*76)/64
    // D1=1, turns on Vertical Sync signal
    lda #$29*$4c/$40
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
  // Wait for the timer to run out
  __b3:
    // while(RIOT->INTIM)
    lda RIOT+OFFSET_STRUCT_MOS6532_RIOT_INTIM
    cmp #0
    bne __b4
    // TIA->VBLANK = 0
    // Screen - display logic
    // Update the registers in TIA (the video chip) in order to generate what the player sees.
    // For now we're just going to output 192 colored scanlines lines so we have something to see.
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_VBLANK
    // char c = SINTABLE[idx++]
    // D1=1, turns off Vertical Blank signal (image output on)
    ldy.z idx
    ldx SINTABLE,y
    inc.z idx
    tay
  __b6:
    // for(char i=0;i<192;i++)
    cpy #$c0
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
    // RIOT->TIM64T = (27*76)/64
    // Set background color to black
    lda #$1b*$4c/$40
    sta RIOT+OFFSET_STRUCT_MOS6532_RIOT_TIM64T
  // Wait for the timer to run out
  __b9:
    // while(RIOT->INTIM)
    lda RIOT+OFFSET_STRUCT_MOS6532_RIOT_INTIM
    cmp #0
    bne __b10
    jmp __b2
  __b10:
    // TIA->WSYNC = 0
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    jmp __b9
  __b7:
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    // TIA->COLUBK = c
    // Wait for SYNC (halts CPU until end of scanline)
    stx TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_COLUBK
    // TIA->PF0 = c
    // Set background color
    stx TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_PF0
    // TIA->PF1 = c
    stx TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_PF1
    // TIA->PF2 = c
    stx TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_PF2
    // TIA->HMOVE = c
    stx TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_HMOVE
    // c++;
    inx
    // for(char i=0;i<192;i++)
    iny
    jmp __b6
  __b4:
    // TIA->WSYNC = 0
    lda #0
    sta TIA+OFFSET_STRUCT_ATARI_TIA_WRITE_WSYNC
    jmp __b3
}
.segment Data
// Sine table
SINTABLE:
.fill $100, round(127.5+127.5*sin(2*PI*i/256))

