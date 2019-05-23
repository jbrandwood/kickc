// Demonstrates error with nested ternary operator
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b1:
    cpx #0
    beq b2
    cpx #1
    beq b4
    lda #'c'
    jmp b3
  b4:
    lda #'b'
    jmp b3
  b2:
    lda #'a'
  b3:
    sta SCREEN
    inx
    cpx #3
    bne b1
    rts
}
