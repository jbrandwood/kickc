.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
//  Fills the screen using an unrolled inner ranged for()-loop
main: {
    .label SCREEN = $400
    ldx #0
  b2:
    txa
    sta SCREEN,x
    txa
    sta SCREEN+1*$28,x
    txa
    sta SCREEN+2*$28,x
    txa
    sta SCREEN+3*$28,x
    txa
    sta SCREEN+4*$28,x
    txa
    sta SCREEN+5*$28,x
    txa
    sta SCREEN+6*$28,x
    txa
    sta SCREEN+7*$28,x
    txa
    sta SCREEN+8*$28,x
    txa
    sta SCREEN+9*$28,x
    txa
    sta SCREEN+$a*$28,x
    txa
    sta SCREEN+$b*$28,x
    txa
    sta SCREEN+$c*$28,x
    txa
    sta SCREEN+$d*$28,x
    txa
    sta SCREEN+$e*$28,x
    txa
    sta SCREEN+$f*$28,x
    txa
    sta SCREEN+$10*$28,x
    txa
    sta SCREEN+$11*$28,x
    txa
    sta SCREEN+$12*$28,x
    txa
    sta SCREEN+$13*$28,x
    txa
    sta SCREEN+$14*$28,x
    txa
    sta SCREEN+$15*$28,x
    txa
    sta SCREEN+$16*$28,x
    txa
    sta SCREEN+$17*$28,x
    txa
    sta SCREEN+$18*$28,x
    inx
    cpx #$28
    bne b2
    rts
}
