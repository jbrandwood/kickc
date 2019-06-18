// Check that multiplication by constants is converted to shift/add
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label _31 = 2
    .label _33 = 3
    ldx #0
  b1:
    txa
    sta SCREEN,x
    txa
    asl
    sta _31
    sta SCREEN+1*$28,x
    txa
    clc
    adc _31
    sta SCREEN+2*$28,x
    txa
    asl
    asl
    sta _33
    sta SCREEN+3*$28,x
    txa
    clc
    adc _33
    sta SCREEN+4*$28,x
    txa
    clc
    adc _31
    asl
    sta SCREEN+5*$28,x
    txa
    clc
    adc _31
    asl
    stx $ff
    clc
    adc $ff
    sta SCREEN+6*$28,x
    txa
    asl
    asl
    asl
    sta SCREEN+7*$28,x
    stx $ff
    clc
    adc $ff
    sta SCREEN+8*$28,x
    txa
    clc
    adc _33
    asl
    sta SCREEN+9*$28,x
    txa
    clc
    adc _33
    asl
    stx $ff
    clc
    adc $ff
    sta SCREEN+$a*$28,x
    txa
    clc
    adc _31
    asl
    asl
    sta SCREEN+$b*$28,x
    txa
    clc
    adc _31
    asl
    asl
    stx $ff
    clc
    adc $ff
    sta SCREEN+$c*$28,x
    txa
    clc
    adc _31
    asl
    stx $ff
    clc
    adc $ff
    asl
    sta SCREEN+$d*$28,x
    txa
    clc
    adc _31
    asl
    stx $ff
    clc
    adc $ff
    asl
    stx $ff
    clc
    adc $ff
    sta SCREEN+$e*$28,x
    inx
    cpx #$12
    beq !b1+
    jmp b1
  !b1:
    rts
}
