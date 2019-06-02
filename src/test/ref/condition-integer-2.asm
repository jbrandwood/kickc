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
  b1:
    txa
    sta SCREEN,y
    iny
    dex
    cpx #0
    bne b1
    lda #' '
    sta SCREEN,y
    iny
    lda #3
  b3:
    sec
    sbc #1
    cmp #0
    bne b4
    lda #' '
    sta SCREEN,y
    iny
    lda #2
  b6:
    sta SCREEN,y
    iny
    sec
    sbc #1
    cmp #0
    bne b6
    rts
  b4:
    sta SCREEN,y
    iny
    jmp b3
}
