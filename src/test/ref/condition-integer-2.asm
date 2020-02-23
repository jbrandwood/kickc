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
    // for( byte i=2;i;i--)
    cpx #0
    bne __b2
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,y
    // SCREEN[idx++] = ' ';
    iny
    lda #3
  __b4:
    // while( j-- )
    sec
    sbc #1
    cmp #0
    bne __b5
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,y
    // SCREEN[idx++] = ' ';
    iny
    lda #2
  __b7:
    // SCREEN[idx++] = k
    sta SCREEN,y
    // SCREEN[idx++] = k;
    iny
    // while(k--)
    sec
    sbc #1
    cmp #0
    bne __b7
    // }
    rts
  __b5:
    // SCREEN[idx++] = j
    sta SCREEN,y
    // SCREEN[idx++] = j;
    iny
    jmp __b4
  __b2:
    // SCREEN[idx++] = i
    txa
    sta SCREEN,y
    // SCREEN[idx++] = i;
    iny
    // for( byte i=2;i;i--)
    dex
    jmp __b1
}
