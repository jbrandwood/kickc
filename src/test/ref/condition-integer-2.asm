// Tests using integer conditions in while() / for() / do..while
// This should produce 'ba ba ba' at the top of the screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldy #0
    ldx #2
  // for()
  __b1:
    cpx #0
    bne __b2
    lda #' '
    sta SCREEN,y
    iny
    lda #3
  __b4:
    sec
    sbc #1
    cmp #0
    bne __b5
    lda #' '
    sta SCREEN,y
    iny
    lda #2
  __b7:
    sta SCREEN,y
    iny
    sec
    sbc #1
    cmp #0
    bne __b7
    rts
  __b5:
    sta SCREEN,y
    iny
    jmp __b4
  __b2:
    txa
    sta SCREEN,y
    iny
    dex
    jmp __b1
}
