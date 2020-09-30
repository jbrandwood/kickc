// Check that multiplication by constants is converted to shift/add
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label __21 = 2
    .label __46 = 3
    ldx #0
  __b1:
    // (SCREEN+0*40)[i] = i*1
    txa
    sta SCREEN,x
    // i*2
    txa
    asl
    // (SCREEN+1*40)[i] = i*2
    sta SCREEN+1*$28,x
    // i*3
    stx.z $ff
    clc
    adc.z $ff
    sta.z __21
    // (SCREEN+2*40)[i] = i*3
    sta SCREEN+2*$28,x
    // i*4
    txa
    asl
    asl
    // (SCREEN+3*40)[i] = i*4
    sta SCREEN+3*$28,x
    // i*5
    stx.z $ff
    clc
    adc.z $ff
    tay
    // (SCREEN+4*40)[i] = i*5
    tya
    sta SCREEN+4*$28,x
    // i*6
    lda.z __21
    asl
    // (SCREEN+5*40)[i] = i*6
    sta SCREEN+5*$28,x
    // i*7
    stx.z $ff
    clc
    adc.z $ff
    sta.z __46
    // (SCREEN+6*40)[i] = i*7
    sta SCREEN+6*$28,x
    // i*8
    txa
    asl
    asl
    asl
    // (SCREEN+7*40)[i] = i*8
    sta SCREEN+7*$28,x
    // i*9
    stx.z $ff
    clc
    adc.z $ff
    // (SCREEN+8*40)[i] = i*9
    sta SCREEN+8*$28,x
    // i*10
    tya
    asl
    // (SCREEN+9*40)[i] = i*10
    sta SCREEN+9*$28,x
    // i*11
    stx.z $ff
    clc
    adc.z $ff
    // (SCREEN+10*40)[i] = i*11
    sta SCREEN+$a*$28,x
    // i*12
    lda.z __21
    asl
    asl
    // (SCREEN+11*40)[i] = i*12
    sta SCREEN+$b*$28,x
    // i*13
    stx.z $ff
    clc
    adc.z $ff
    // (SCREEN+12*40)[i] = i*13
    sta SCREEN+$c*$28,x
    // i*14
    lda.z __46
    asl
    // (SCREEN+13*40)[i] = i*14
    sta SCREEN+$d*$28,x
    // i*15
    stx.z $ff
    clc
    adc.z $ff
    // (SCREEN+14*40)[i] = i*15
    sta SCREEN+$e*$28,x
    // for(byte i: 0..17)
    inx
    cpx #$12
    bne __b1
    // }
    rts
}
