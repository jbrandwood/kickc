// Procedure Declaration
  // Commodore 64 PRG executable file
.file [name="procedure-declare-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // f('a')
    lda #'a'
    jsr f
    // f('a')
    // SCREEN[0] = f('a')
    sta SCREEN
    // f('b')
    lda #'b'
    jsr f
    // f('b')
    // SCREEN[1] = f('b')
    sta SCREEN+1
    // }
    rts
}
// f(byte register(A) a)
f: {
    // a+1
    clc
    adc #1
    // }
    rts
}
