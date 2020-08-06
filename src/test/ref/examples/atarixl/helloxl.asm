// Hello World for Atari XL / XE
// XEX file format https://www.atarimax.com/jindroush.atari.org/afmtexe.html
// Minimal Hello World https://atariage.com/forums/topic/229742-help-with-hello-world-in-mads/
// Display Lists atariarchives.org/mapping/appendix8.php
  // Atari XL/XE minimal XEX file
// https://www.atarimax.com/jindroush.atari.org/afmtexe.html
.file [name="helloxl.xex", type="bin", segments="XexFile"]
.segmentdef Program [segments="ProgramStart, Code, Data, ProgramEnd"]
.segmentdef ProgramStart [start=$2000]
.segmentdef Code [startAfter="ProgramStart"]
.segmentdef Data [startAfter="Code"]
.segmentdef ProgramEnd [startAfter="Data"]
.segment ProgramStart
ProgramStart:
.segment ProgramEnd
ProgramEnd:
.segmentdef XexFile
.segment XexFile
// Binary File Header
.byte $ff, $ff
// Program segment [start address, end address, data]
.word ProgramStart, ProgramEnd
.segmentout [ segments="Program" ]
// RunAd - Run Address Segment [start address, end address, data]
.word $02e0, $02e1
.word main 
  // OS Shadow ANTIC Direct Memory Access Control
  .label SDMCTL = $22f
  // OS Shadow ANTIC Display List Pointer
  .label SDLST = $230
.segment Code
main: {
    // *SDMCTL = 0x21
    // Enable DMA, Narrow Playfield into Shadow ANTIC Direct Memory Access Control
    lda #$21
    sta SDMCTL
    // *SDLST = DISPLAY_LIST
    // Set Shadow ANTIC Display List Pointer
    lda #<DISPLAY_LIST
    sta SDLST
    lda #>DISPLAY_LIST
    sta SDLST+1
  __b1:
  // Loop forever
    jmp __b1
}
.segment Data
  // Message to show
  // Encoding: atari_internal
  TEXT: .byte 'h'|$20, 'e'|$20, 'l'|$20, 'l'|$20, 'o'|$20, 0, 'x'|$60, 't'|$60, 0, 'w'|$20, 'o'|$20, 'r'|$20, 'l'|$20, 'd'|$20, $41, 0, 0, 0, 0
  // ANTIC Display List Program
  // https://en.wikipedia.org/wiki/ANTIC
  DISPLAY_LIST: .byte $70, $70, $70, $47, <TEXT, >TEXT, $41, <DISPLAY_LIST, >DISPLAY_LIST
