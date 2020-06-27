.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label SCREEN2 = $400+$28
main: {
    .label i = 2
    lda #0
    sta.z i
  __b1:
    // sum(i,i+1,i+2)
    lda.z i
    clc
    adc #1
    ldx.z i
    inx
    inx
    ldy.z i
    jsr sum
    // SCREEN[i] = sum(i,i+1,i+2)
    ldy.z i
    sta SCREEN,y
    // sum2(i,i+1,i+2)
    tya
    clc
    adc #1
    ldx.z i
    inx
    inx
    jsr sum2
    // SCREEN2[i] = sum2(i,i+1,i+2)
    ldy.z i
    sta SCREEN2,y
    // for(byte i : 0..10)
    inc.z i
    lda #$b
    cmp.z i
    bne __b1
    // }
    rts
}
// sum(byte register(Y) a, byte register(A) b, byte register(X) c)
sum: {
    // a+b
    sty.z $ff
    clc
    adc.z $ff
    // a+b+c
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
// sum2(byte register(Y) a, byte register(A) b, byte register(X) c)
sum2: {
    // a+b
    sty.z $ff
    clc
    adc.z $ff
    // a+b+c
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
