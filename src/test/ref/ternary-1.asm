// Tests the ternary operator
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    cpx #5
    bcc __b2
    lda #'b'
    jmp __b3
  __b2:
    lda #'a'
  __b3:
    sta SCREEN,x
    inx
    cpx #$a
    bne __b1
    rts
}
