// Expressions based on bytes but resulting in words are as words - eg. b = b + 40*8;
  // Commodore 64 PRG executable file
.file [name="wordexpr.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label b = 2
    ldx #0
    txa
    sta.z b
    sta.z b+1
  __b1:
    // b = b + 40*8
    clc
    lda.z b
    adc #<$28*8
    sta.z b
    lda.z b+1
    adc #>$28*8
    sta.z b+1
    // for(byte i : 0..10)
    inx
    cpx #$b
    bne __b1
    // }
    rts
}
