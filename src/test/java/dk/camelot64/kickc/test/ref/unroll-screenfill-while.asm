.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label SCREEN = $400
    ldx #0
  b3:
    txa
    sta SCREEN+0*$28,x
    txa
    sta SCREEN+(0+1)*$28,x
    txa
    sta SCREEN+(0+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1)*$28,x
    txa
    sta SCREEN+(0+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1)*$28,x
    inx
    cpx #$28
    bne b3
    rts
}
