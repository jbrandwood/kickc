.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    txa
    sta SCREEN,x
    txa
    sta SCREEN+$50,x
    inx
    cpx #$28
    bne __b1
    rts
}
