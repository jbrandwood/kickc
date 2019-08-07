.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    .label s1 = 2
    .label s3 = 3
    lda #2
    ldy #1
    jsr sum
    sta.z s1
    lda #4
    ldy #3
    jsr sum
    tax
    lda #$d
    ldy #9
    jsr sum
    sta.z s3
    txa
    clc
    adc.z s1
    clc
    adc.z s3
    sta screen
    rts
}
// sum(byte register(Y) a, byte register(A) b)
sum: {
    sty.z $ff
    clc
    adc.z $ff
    rts
}
