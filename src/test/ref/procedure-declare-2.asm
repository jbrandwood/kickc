// Procedure Declaration - a procedure with paramters&return defined without declaration
  // Commodore 64 PRG executable file
.file [name="procedure-declare-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // sum('a', 1)
    lda #1
    ldx #'a'
    jsr sum
    // sum('a', 1)
    // SCREEN[0] = sum('a', 1)
    sta SCREEN
    // sum('b', 2)
    lda #2
    ldx #'b'
    jsr sum
    // sum('b', 2)
    // SCREEN[1] = sum('b', 2)
    sta SCREEN+1
    // }
    rts
}
// sum(byte register(X) a, byte register(A) b)
sum: {
    // a+b
    stx.z $ff
    clc
    adc.z $ff
    // a+b+1
    clc
    adc #1
    // }
    rts
}
