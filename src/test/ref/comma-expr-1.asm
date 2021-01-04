// Tests simple comma-expression (in parenthesis)
  // Commodore 64 PRG executable file
.file [name="comma-expr-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const b = 3
    .const c = b+1
    .label SCREEN = $400
    // SCREEN[1,0] = c
    lda #c
    sta SCREEN
    // }
    rts
}
