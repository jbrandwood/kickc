.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    lda #0
    ldx #$a
  __b1:
    cpx #5+1
    bcc __b2
    stx.z $ff
    clc
    adc.z $ff
  __b2:
    dex
    cpx #0
    bne __b1
    rts
}
