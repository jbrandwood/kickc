// More extensive union with C99 style designator initialization behaviour using const expressions.
  // Commodore 64 PRG executable file
.file [name="union-13.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = b1.b[0]
    lda b1
    sta SCREEN
    // }
    rts
}
.segment Data
  b1: .byte 1
  .fill 1, 0
  .fill 2, 0
