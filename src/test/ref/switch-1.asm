// Tests simple switch()-statement - including a continue statement for the enclosing loop
// Expected output 'a1aa1a' (numbers should be inverted)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    cpx #1
    beq __b2
    cpx #4
    beq __b2
    // No case for 0 & 5
    lda #'a'
    sta SCREEN,x
  __b5:
    inx
    cpx #6
    bne __b1
    rts
  __b2:
    lda #'1'
    sta SCREEN,x
    // Invert the screen character
    lda #$80
    ora SCREEN,x
    sta SCREEN,x
    jmp __b5
}
