// Tests subtracting bytes from signed words
  // Commodore 64 PRG executable file
.file [name="signed-word-minus-byte-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    .label w1 = 2
    ldx #0
    lda #<$4d2
    sta.z w1
    lda #>$4d2
    sta.z w1+1
  __b1:
    // w1 = w1 - 41
    lda.z w1
    sec
    sbc #$29
    sta.z w1
    lda.z w1+1
    sbc #>$29
    sta.z w1+1
    // screen[i] = w1
    txa
    asl
    tay
    lda.z w1
    sta screen,y
    lda.z w1+1
    sta screen+1,y
    // for( byte i: 0..10 )
    inx
    cpx #$b
    bne __b1
    // }
    rts
}
