// Clobber problem in next_char return value
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label nxt = 2
main: {
    .label SCREEN = $400
    ldx #0
    lda #<TEXT
    sta.z nxt
    lda #>TEXT
    sta.z nxt+1
  __b1:
    // next_char()
    jsr next_char
    tya
    // SCREEN[i] = next_char()
    sta SCREEN,x
    // for( byte i: 0..255)
    inx
    cpx #0
    bne __b1
    // }
    rts
}
// Find the next char of the text
next_char: {
    // c = *nxt
    ldy #0
    lda (nxt),y
    tay
    // if(c==0)
    cpy #0
    bne __b1
    // c = *nxt
    ldy TEXT
    lda #<TEXT
    sta.z nxt
    lda #>TEXT
    sta.z nxt+1
  __b1:
    // nxt++;
    inc.z nxt
    bne !+
    inc.z nxt+1
  !:
    // }
    rts
}
  TEXT: .text "cml "
  .byte 0
