.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN1 = $400
  .const SCREEN2 = $500
  jsr main
main: {
    ldx #0
  b1:
    txa
    sta SCREEN1,x
    inx
    cpx #0
    bne b1
    ldx #$64
  b2:
    txa
    sta SCREEN2,x
    dex
    cpx #$ff
    bne b2
    rts
}
