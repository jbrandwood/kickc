// Test that the compiler optimizes when the same parameter value is passed into a function in all calls
  // Commodore 64 PRG executable file
.file [name="const-param.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label reverse = $80
    .label screen = $400
    // sum(reverse, 'c')
    lda #'c'
    jsr sum
    // sum(reverse, 'c')
    // screen[0] = sum(reverse, 'c')
    sta screen
    // sum(reverse, 'm')
    lda #'m'
    jsr sum
    // sum(reverse, 'm')
    // screen[1] = sum(reverse, 'm')
    sta screen+1
    // sum(reverse, 'l')
    lda #'l'
    jsr sum
    // sum(reverse, 'l')
    // screen[2] = sum(reverse, 'l')
    sta screen+2
    // }
    rts
}
// __register(A) char sum(char a, __register(A) char b)
sum: {
    // a+b
    clc
    adc #main.reverse
    // }
    rts
}
