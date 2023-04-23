// Minimal union with C99 style designator initialization behaviour.
  // Commodore 64 PRG executable file
.file [name="union-9.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = data.b
    lda data
    sta SCREEN
    // }
    rts
}
.segment Data
  data: .word $4d2
