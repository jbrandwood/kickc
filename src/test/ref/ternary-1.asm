// Tests the ternary operator
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b2:
    lda #'a'
  b3:
    sta SCREEN,x
    inx
    cpx #$a
    bne b1
    rts
  b1:
    cpx #5
    bcc b2
    lda #'b'
    jmp b3
}
