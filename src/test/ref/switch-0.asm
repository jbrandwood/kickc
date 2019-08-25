// Tests simple switch()-statement
// Expected output 'd1444d'
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b1:
    cpx #1
    beq b2
    cpx #2
    beq b3
    // A case with no body
    cpx #3
    beq b3
    cpx #4
    beq b4
    // No case for 0 & 5
    lda #'d'
    sta SCREEN,x
  b6:
    inx
    cpx #6
    bne b1
    rts
  b4:
    lda #'4'
    sta SCREEN,x
    jmp b6
  b3:
    // A case with fall-through
    lda #'3'
    sta SCREEN,x
    jmp b4
  b2:
    // A simple case with a break
    lda #'1'
    sta SCREEN,x
    jmp b6
}
