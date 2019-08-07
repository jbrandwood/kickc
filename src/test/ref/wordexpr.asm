// Expressions based on bytes but resulting in words are as words - eg. b = b + 40*8;
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label b = 2
    ldx #0
    txa
    sta.z b
    sta.z b+1
  b1:
    clc
    lda.z b
    adc #<$28*8
    sta.z b
    lda.z b+1
    adc #>$28*8
    sta.z b+1
    inx
    cpx #$b
    bne b1
    rts
}
