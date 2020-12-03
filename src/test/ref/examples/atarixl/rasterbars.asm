// Raster Bars for Atari XL / XE
  // Atari XL/XE executable XEX file with a single segment
// https://www.atarimax.com/jindroush.atari.org/afmtexe.html
.plugin "dk.camelot64.kickass.xexplugin.AtariXex"
.file [name="rasterbars.xex", type="bin", segments="XexFile"]
.segmentdef XexFile [segments="Program", modify="XexFormat", _RunAddr=main]
.segmentdef Program [segments="Code, Data"]
.segmentdef Code [start=$2000]
.segmentdef Data [startAfter="Code"]
  // 2: High Resolution Text Mode. 8 scanlines per char, 32/40/48 chars wide.  bit 7 controls inversion or blinking, based on modes in CHACTL.
  .const MODE2 = 2
  // 7:  Single color text in five colors. 16 scanlines per char, 16/20/24 chars wide.  the upper two bits are used to select the foreground color used by 1 bits, with 00-11 producing PF0-PF3.
  .const MODE7 = 7
  // Load memory scan counter (LMS operation) - Load memory scan counter with new 16-bit address. Can be combined with mode instructions by OR.
  .const LMS = $40
  // Jump and wait for Vertical Blank - suspends the display list until vertical blank and then jumps. This is usually used to terminate the display list and restart it for the next frame.
  .const JVB = $41
  // Blank 4 lines
  .const BLANK4 = $30
  // Blank 8 lines
  .const BLANK8 = $70
  .const OFFSET_STRUCT_ATARI_ANTIC_DLIST = 2
  .const OFFSET_STRUCT_ATARI_GTIA_WRITE_COLPF0 = $16
  .const OFFSET_STRUCT_ATARI_GTIA_WRITE_COLPF1 = $17
  .const OFFSET_STRUCT_ATARI_GTIA_WRITE_COLPF2 = $18
  .const OFFSET_STRUCT_ATARI_GTIA_WRITE_COLPF3 = $19
  .const OFFSET_STRUCT_ATARI_ANTIC_VCOUNT = $b
  .const OFFSET_STRUCT_ATARI_ANTIC_WSYNC = $a
  .const OFFSET_STRUCT_ATARI_GTIA_WRITE_COLBK = $1a
  // Atari GTIA write registers
  .label GTIA = $d000
  // Atari ANTIC registers
  .label ANTIC = $d400
.segment Code
main: {
    // asm
    // Disable IRQ
    sei
    // ANTIC->DMACTL = 0x21
    // Enable DMA, Narrow Playfield - ANTIC Direct Memory Access Control
    lda #$21
    sta ANTIC
    // ANTIC->DLIST  = DISPLAY_LIST
    // Set ANTIC Display List Pointer
    lda #<DISPLAY_LIST
    sta ANTIC+OFFSET_STRUCT_ATARI_ANTIC_DLIST
    lda #>DISPLAY_LIST
    sta ANTIC+OFFSET_STRUCT_ATARI_ANTIC_DLIST+1
    // GTIA->COLPF0 = 0x28
    // Set colors
    lda #$28
    sta GTIA+OFFSET_STRUCT_ATARI_GTIA_WRITE_COLPF0
    // GTIA->COLPF1 = 0x48
    lda #$48
    sta GTIA+OFFSET_STRUCT_ATARI_GTIA_WRITE_COLPF1
    // GTIA->COLPF2 = 0x80
    lda #$80
    sta GTIA+OFFSET_STRUCT_ATARI_GTIA_WRITE_COLPF2
    // GTIA->COLPF3 = 0xc8
    lda #$c8
    sta GTIA+OFFSET_STRUCT_ATARI_GTIA_WRITE_COLPF3
    ldy #0
  __b1:
    // while(ANTIC->VCOUNT!=40)
    lda #$28
    cmp ANTIC+OFFSET_STRUCT_ATARI_ANTIC_VCOUNT
    bne __b1
    // c = col++
    tya
    tax
    inx
    lda #0
  __b3:
    // for( char l=0;l<100;l++)
    cmp #$64
    bcc __b4
    // GTIA->COLBK = 0
    lda #0
    sta GTIA+OFFSET_STRUCT_ATARI_GTIA_WRITE_COLBK
    txa
    tay
    jmp __b1
  __b4:
    // ANTIC->WSYNC = c
    sty ANTIC+OFFSET_STRUCT_ATARI_ANTIC_WSYNC
    // GTIA->COLBK = c
    sty GTIA+OFFSET_STRUCT_ATARI_GTIA_WRITE_COLBK
    // c++;
    iny
    // for( char l=0;l<100;l++)
    clc
    adc #1
    jmp __b3
}
.segment Data
  // Message to show
.encoding "ascii"
  TEXT: .text @"\$28\$25\$2c\$2c\$2f\$00atari\$00\$18\$22\$29\$34\$24emonstrates\$00\$21\$2e\$34\$29\$23\$00display\$00list\$01"
  .byte 0
  // ANTIC Display List Program
  // https://en.wikipedia.org/wiki/ANTIC
  DISPLAY_LIST: .byte BLANK8, BLANK8, BLANK8, LMS|MODE7, <TEXT, >TEXT, BLANK4, MODE2, JVB, <DISPLAY_LIST, >DISPLAY_LIST
