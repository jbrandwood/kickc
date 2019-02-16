.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
//  Expressions based on bytes but resulting in words are as words - eg. b = b + 40*8;
main: {
    .label b = 2
    ldx #0
    txa
    sta b
    sta b+1
  b1:
    clc
    lda b
    adc #<$28*8
    sta b
    lda b+1
    adc #>$28*8
    sta b+1
    inx
    cpx #$b
    bne b1
    rts
}
