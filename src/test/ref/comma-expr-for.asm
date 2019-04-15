// Tests comma-expressions in for()-statement
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
    lda #'g'
  b1:
    sta SCREEN,x
    inx
    clc
    adc #1
    cpx #$a
    bcc b1
    rts
}
