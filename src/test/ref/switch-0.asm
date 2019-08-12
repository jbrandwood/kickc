// Tests simple switch()-statement
// Expected output 'd1444d'
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b5:
    lda #'d'
    sta SCREEN,x
  b6:
    inx
    cpx #6
    bne b1
    rts
  b1:
    // A simple case with a break
    cpx #1
    beq b2
    // A case with no body
    cpx #2
    beq b3
    // A case with fall-through
    cpx #3
    beq b3
    cpx #4
    beq b4
    jmp b5
  b4:
    lda #'4'
    sta SCREEN,x
    jmp b6
  b3:
    lda #'3'
    sta SCREEN,x
    jmp b4
  b2:
    lda #'1'
    sta SCREEN,x
    jmp b6
}
