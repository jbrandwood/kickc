// Illustrates problem with negating a constant negative number
// KickAsm requires parenthesis for double negation to work
  // Commodore 64 PRG executable file
.file [name="problem-negate-const.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // printneg(-4)
    jsr printneg
    // }
    rts
}
printneg: {
    // SCREEN[0] = c
    lda #-(-4)
    sta SCREEN
    // }
    rts
}
