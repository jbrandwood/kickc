.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  jsr main
main: {
    lda #0
  b1:
    tax
    sta SCREEN,x
    clc
    adc #2
    cmp #$28
    bcc b1
    rts
}
