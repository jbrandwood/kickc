// Tests comma-separated declarations inside for()
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    lda #'g'
    ldx #0
  b2:
    sta SCREEN,x
    inx
    clc
    adc #1
    cpx #$a
    bcc b2
    rts
}
