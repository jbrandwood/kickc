.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    lda #0
    ldx #$a
  b3:
    stx $ff
    clc
    adc $ff
  b2:
    dex
    cpx #0
    bne b1
    rts
  b1:
    cpx #5+1
    bcc b2
    jmp b3
}
