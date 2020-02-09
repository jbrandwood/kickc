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
    txa
    sta SCREEN,x
    txa
    asl
    sta.z __16
    sta SCREEN+1*$28,x
    txa
    clc
    adc.z __16
    sta SCREEN+2*$28,x
    txa
    asl
    asl
    sta.z __18
    sta SCREEN+3*$28,x
    txa
    clc
    adc.z __18
    sta SCREEN+4*$28,x
    txa
    clc
    adc.z __16
    asl
    sta SCREEN+5*$28,x
    txa
    clc
    adc.z __16
    asl
    stx.z $ff
    clc
    adc.z $ff
    sta SCREEN+6*$28,x
    txa
    asl
    asl
    asl
    sta SCREEN+7*$28,x
    stx.z $ff
    clc
    adc.z $ff
    sta SCREEN+8*$28,x
    txa
    clc
    adc.z __18
    asl
    sta SCREEN+9*$28,x
    txa
    clc
    adc.z __18
    asl
    stx.z $ff
    clc
    adc.z $ff
    sta SCREEN+$a*$28,x
    txa
    clc
    adc.z __16
    asl
    asl
    sta SCREEN+$b*$28,x
    txa
    clc
    adc.z __16
    asl
    asl
    stx.z $ff
    clc
    adc.z $ff
    sta SCREEN+$c*$28,x
    txa
    clc
    adc.z __16
    asl
    stx.z $ff
    clc
    adc.z $ff
    asl
    sta SCREEN+$d*$28,x
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
    sta SCREEN+$e*$28,x
    inx
    cpx #$12
    beq !__b1+
    jmp __b1
  !__b1:
    rts
}
