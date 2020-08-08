// Hello World for Atari XL / XE
// XEX file format https://www.atarimax.com/jindroush.atari.org/afmtexe.html
// Minimal Hello World https://atariage.com/forums/topic/229742-help-with-hello-world-in-mads/
// Display Lists atariarchives.org/mapping/appendix8.php
  // Atari XL/XE XEX file minimal file
// https://www.atarimax.com/jindroush.atari.org/afmtexe.html
.file [name="helloxl.xex", type="bin", segments="XexFile"]
.segmentdef XexFile
.segment XexFile
// Binary File Header
.byte $ff, $ff
// Program segment [start address, end address, data]
.word ProgramStart, ProgramEnd-1
.segmentout [ segments="Program" ]
// RunAd - Run Address Segment [start address, end address, data]
.word $02e0, $02e1
.word main
.segmentdef Program [segments="ProgramStart, Code, Data, ProgramEnd"]
.segmentdef ProgramStart [start=$2000]
.segment ProgramStart
ProgramStart:
.segmentdef Code [startAfter="ProgramStart"]
.segmentdef Data [startAfter="Code"]
.segmentdef ProgramEnd [startAfter="Data"]
.segment ProgramEnd
ProgramEnd:

  // OS Shadow ANTIC Direct Memory Access Control ($D400)
  .label SDMCTL = $22f
  // OS Shadow ANTIC Display List Pointer ($D402)
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
.encoding "ascii"
  TEXT: .text @"\$28\$25\$2c\$2c\$2f\$00atari\$00\$18\$22\$29\$34\$24emonstrates\$00\$21\$2e\$34\$29\$23\$00display\$00list"
  .byte 0
  // ANTIC Display List Program
  // https://en.wikipedia.org/wiki/ANTIC
  DISPLAY_LIST: .byte $70, $70, $70, $47, <TEXT, >TEXT, $70, 2, $41, <DISPLAY_LIST, >DISPLAY_LIST
