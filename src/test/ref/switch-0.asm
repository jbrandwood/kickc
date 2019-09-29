// Tests simple switch()-statement
// Expected output 'd1444d'
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    cpx #1
    beq __b2
    cpx #2
    beq __b3
    // A case with no body
    cpx #3
    beq __b3
    cpx #4
    beq __b4
    // No case for 0 & 5
    lda #'d'
    sta SCREEN,x
  __b6:
    inx
    cpx #6
    bne __b1
    rts
  __b4:
    lda #'4'
    sta SCREEN,x
    jmp __b6
  __b3:
    // A case with fall-through
    lda #'3'
    sta SCREEN,x
    jmp __b4
  __b2:
    // A simple case with a break
    lda #'1'
    sta SCREEN,x
    jmp __b6
}
