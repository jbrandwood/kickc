// Tests using integer conditions in ternary operator
// This should produce '++0++' at the top of the screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
    ldy #-2
  b1:
    cpy #0
    bne b2
    lda #'0'
    jmp b3
  b2:
    lda #'+'
  b3:
    sta SCREEN,x
    inx
    iny
    cpy #3
    bne b1
    rts
}
