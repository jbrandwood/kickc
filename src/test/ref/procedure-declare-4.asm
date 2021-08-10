// Procedure Declaration - a procedure with paramters&return declared multiple times & defined
  // Commodore 64 PRG executable file
.file [name="procedure-declare-4.prg", type="prg", segments="Program"]
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
// Calculate sum of two integers plus 1
// __register(A) char sum(__register(X) char q, __register(A) char w)
sum: {
    // q+w
    stx.z $ff
    clc
    adc.z $ff
    // q+w+1
    clc
    adc #1
    // }
    rts
}
