// A simple loop results in NullPointerException during loop analysis
  // Commodore 64 PRG executable file
.file [name="loop-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // *SCREEN = '0'
    lda #'0'
    sta SCREEN
    // d()
    jsr d
    // b()
    jsr b
    // }
    rts
}
d: {
    // (*SCREEN)++;
    inc SCREEN
    // }
    rts
}
b: {
    ldx #0
  __b1:
    // d()
    jsr d
    // for( byte i: 0..3)
    inx
    cpx #4
    bne __b1
    // }
    rts
}
