// Tests ATASCII encoding
  // Commodore 64 PRG executable file
.file [name="encoding-atascii.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = TEXT[13]
    lda TEXT+$d
    sta SCREEN
    // SCREEN[1] = '\n'
  .encoding "ascii"
    lda #'\$9b'
    sta SCREEN+1
    // }
    rts
}
.segment Data
  TEXT: .text @"hello, world!\$9b"
  .byte 0
