// Demonstrates error with nested ternary operator
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    cpx #0
    beq b1
    cpx #1
    beq __b4
    lda #'c'
    jmp __b3
  __b4:
    lda #'b'
    jmp __b3
  b1:
    lda #'a'
  __b3:
    sta SCREEN
    inx
    cpx #3
    bne __b1
    rts
}
