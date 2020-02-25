.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    .label s1 = 2
    .label s3 = 3
    // sum(1,2)
    lda #2
    ldy #1
    jsr sum
    // sum(1,2)
    // s1=sum(1,2)
    sta.z s1
    // sum(3,4)
    lda #4
    ldy #3
    jsr sum
    // sum(3,4)
    // s2=sum(3,4)
    tax
    // sum(9,13)
    lda #$d
    ldy #9
    jsr sum
    // sum(9,13)
    // s3=sum(9,13)
    sta.z s3
    // s1+s2
    txa
    clc
    adc.z s1
    // s4=s1+s2+s3
    clc
    adc.z s3
    // *screen = s4
    sta screen
    // }
    rts
}
// sum(byte register(Y) a, byte register(A) b)
sum: {
    // a+b
    sty.z $ff
    clc
    adc.z $ff
    // }
    rts
}
