// Tests using integer conditions in while() / for() / do..while
// This should produce 'ba ba@ ba@' at the top of the screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // while()
    .label j = 2
    ldx #0
    lda #2
  // for()
  __b1:
    // for( byte i=2;i;i--)
    cmp #0
    bne __b2
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,x
    // SCREEN[idx++] = ' ';
    inx
    lda #3
    sta.z j
  __b4:
    // while( j-- )
    ldy.z j
    dey
    lda #0
    cmp.z j
    bne __b5
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,x
    // SCREEN[idx++] = ' ';
    txa
    tay
    iny
    ldx #2
  __b7:
    // SCREEN[idx++] = k
    txa
    sta SCREEN,y
    // SCREEN[idx++] = k;
    iny
    // while(k--)
    txa
    sec
    sbc #1
    cpx #0
    bne __b8
    // }
    rts
  __b8:
    tax
    jmp __b7
  __b5:
    // SCREEN[idx++] = j
    tya
    sta SCREEN,x
    // SCREEN[idx++] = j;
    inx
    sty.z j
    jmp __b4
  __b2:
    // SCREEN[idx++] = i
    sta SCREEN,x
    // SCREEN[idx++] = i;
    inx
    // for( byte i=2;i;i--)
    sec
    sbc #1
    jmp __b1
}
