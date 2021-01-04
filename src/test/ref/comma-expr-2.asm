// Tests simple comma-expressions (without parenthesis)
  // Commodore 64 PRG executable file
.file [name="comma-expr-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const c = 1+3
    .label SCREEN = $400
    // SCREEN[1,0] = c
    lda #c
    sta SCREEN
    // }
    rts
}
