// Tests simple switch()-statement - including a continue statement for the enclosing loop
// Expected output 'a1aa1a' (numbers should be inverted)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b3:
    // No case for 0 & 5
    lda #'a'
    sta SCREEN,x
  b5:
    inx
    cpx #6
    bne b1
    rts
  b1:
    cpx #1
    beq b2
    cpx #4
    beq b2
    jmp b3
  b2:
    lda #'1'
    sta SCREEN,x
    // Invert the screen character
    lda #$80
    ora SCREEN,x
    sta SCREEN,x
    jmp b5
}
