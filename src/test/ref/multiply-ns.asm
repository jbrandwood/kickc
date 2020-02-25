// Check that multiplication by constants is converted to shift/add
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label __16 = 2
    .label __18 = 3
    ldx #0
  __b1:
    // (SCREEN+0*40)[i] = i*1
    txa
    sta SCREEN,x
    // i*2
    txa
    asl
    sta.z __16
    // (SCREEN+1*40)[i] = i*2
    sta SCREEN+1*$28,x
    // i*3
    txa
    clc
    adc.z __16
    // (SCREEN+2*40)[i] = i*3
    sta SCREEN+2*$28,x
    // i*4
    txa
    asl
    asl
    sta.z __18
    // (SCREEN+3*40)[i] = i*4
    sta SCREEN+3*$28,x
    // i*5
    txa
    clc
    adc.z __18
    // (SCREEN+4*40)[i] = i*5
    sta SCREEN+4*$28,x
    // i*6
    txa
    clc
    adc.z __16
    asl
    // (SCREEN+5*40)[i] = i*6
    sta SCREEN+5*$28,x
    // i*7
    txa
    clc
    adc.z __16
    asl
    stx.z $ff
    clc
    adc.z $ff
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
    txa
    clc
    adc.z __18
    asl
    // (SCREEN+9*40)[i] = i*10
    sta SCREEN+9*$28,x
    // i*11
    txa
    clc
    adc.z __18
    asl
    stx.z $ff
    clc
    adc.z $ff
    // (SCREEN+10*40)[i] = i*11
    sta SCREEN+$a*$28,x
    // i*12
    txa
    clc
    adc.z __16
    asl
    asl
    // (SCREEN+11*40)[i] = i*12
    sta SCREEN+$b*$28,x
    // i*13
    txa
    clc
    adc.z __16
    asl
    asl
    stx.z $ff
    clc
    adc.z $ff
    // (SCREEN+12*40)[i] = i*13
    sta SCREEN+$c*$28,x
    // i*14
    txa
    clc
    adc.z __16
    asl
    stx.z $ff
    clc
    adc.z $ff
    asl
    // (SCREEN+13*40)[i] = i*14
    sta SCREEN+$d*$28,x
    // i*15
    txa
    clc
    adc.z __16
    asl
    stx.z $ff
    clc
    adc.z $ff
    asl
    stx.z $ff
    clc
    adc.z $ff
    // (SCREEN+14*40)[i] = i*15
    sta SCREEN+$e*$28,x
    // for(byte i: 0..17)
    inx
    cpx #$12
    beq !__b1+
    jmp __b1
  !__b1:
    // }
    rts
}
