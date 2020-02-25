// Tests using integer conditions in ternary operator
// This should produce '++0++' at the top of the screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
    ldy #-2
  __b1:
    // i?'+':'0'
    cpy #0
    bne __b2
    lda #'0'
    jmp __b3
  __b2:
    lda #'+'
  __b3:
    // SCREEN[idx++] = j
    sta SCREEN,x
    // SCREEN[idx++] = j;
    inx
    // for( signed byte i: -2..2)
    iny
    cpy #3
    bne __b1
    // }
    rts
}
