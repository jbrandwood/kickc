// Test declarations without body
  // Commodore 64 PRG executable file
.file [name="cstyle-decl-function.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
// Definition of main()
main: {
    // sum('a', 2)
    lda #2
    ldx #'a'
    jsr sum
    // sum('a', 2)
    // SCREEN[0] = sum('a', 2)
    sta SCREEN
    // sum('a', 12)
    lda #$c
    ldx #'a'
    jsr sum
    // sum('a', 12)
    // SCREEN[1] = sum('a', 12)
    sta SCREEN+1
    // }
    rts
}
// Definition of sum()
// sum(byte register(X) a, byte register(A) b)
sum: {
    // a+b
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
