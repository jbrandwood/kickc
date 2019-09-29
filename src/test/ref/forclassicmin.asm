// Minimal classic for() loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    cpx #$64
    bne __b2
    rts
  __b2:
    txa
    sta SCREEN,x
    inx
    jmp __b1
}
