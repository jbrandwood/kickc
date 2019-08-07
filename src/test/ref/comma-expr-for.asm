// Tests comma-expressions in for()-statement
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    lda #'g'
    ldx #0
  b1:
    cpx #$a
    bcc b2
    rts
  b2:
    sta SCREEN,x
    inx
    clc
    adc #1
    jmp b1
}
