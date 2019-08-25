.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    lda #0
    ldx #$a
  b1:
    cpx #5+1
    bcc b2
    stx.z $ff
    clc
    adc.z $ff
  b2:
    dex
    cpx #0
    bne b1
    rts
}
