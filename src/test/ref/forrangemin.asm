// Minimal range based for() loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN1 = $400
  .label SCREEN2 = $500
main: {
    ldx #0
  __b1:
    txa
    sta SCREEN1,x
    inx
    cpx #0
    bne __b1
    ldx #$64
  __b2:
    txa
    sta SCREEN2,x
    dex
    cpx #$ff
    bne __b2
    rts
}
