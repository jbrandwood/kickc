// Tests using integer conditions in while() / for() / do..while
// This should produce 'ba ba ba' at the top of the screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldy #0
    ldx #2
  b2:
    txa
    sta SCREEN,y
    iny
    dex
  // for()
    cpx #0
    bne b2
    lda #' '
    sta SCREEN,y
    iny
    lda #3
  b4:
    sec
    sbc #1
    cmp #0
    bne b5
    lda #' '
    sta SCREEN,y
    iny
    lda #2
  b7:
    sta SCREEN,y
    iny
    sec
    sbc #1
    cmp #0
    bne b7
    rts
  b5:
    sta SCREEN,y
    iny
    jmp b4
}
