// Demonstrates error with nested ternary operator
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b2:
    lda #'a'
  b4:
    sta SCREEN
    inx
    cpx #3
    bne b1
    rts
  b1:
    cpx #0
    beq b2
    cpx #1
    beq b5
    lda #'c'
    jmp b4
  b5:
    lda #'b'
    jmp b4
}
