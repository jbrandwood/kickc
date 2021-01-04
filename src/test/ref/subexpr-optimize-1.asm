// A sub-expression that should not be optimized (+1 to a pointer)
  // Commodore 64 PRG executable file
.file [name="subexpr-optimize-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // SCREEN[i] = SCREEN[i+1]
    lda SCREEN+1,x
    sta SCREEN,x
    // (SCREEN+40)[i] = (SCREEN+40)[i+1]
    lda SCREEN+$28+1,x
    sta SCREEN+$28,x
    // (SCREEN+80)[i] = (SCREEN+80)[i+1]
    lda SCREEN+$50+1,x
    sta SCREEN+$50,x
    // (SCREEN+120)[i] = (SCREEN+120)[i+1]
    lda SCREEN+$78+1,x
    sta SCREEN+$78,x
    // for(byte i: 0..38)
    inx
    cpx #$27
    bne __b1
    // }
    rts
}
