// More extensive union with C99 style designator initialization behaviour using const expressions.
  // Commodore 64 PRG executable file
.file [name="union-12.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = data.m.f
    lda data
    sta SCREEN
    // }
    rts
}
.segment Data
  move: .byte 1, 2, 3
  data: .fill 1, 0
