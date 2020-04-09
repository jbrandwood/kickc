// Test legal definition of multiple local variables with the same name
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
// And a little code using them
main: {
    .label c = 2
    lda #0
    sta.z c
    tay
  __b1:
    ldx #0
  __b2:
    // SCREEN[idx++] = '*'
    lda #'*'
    sta SCREEN,y
    // SCREEN[idx++] = '*';
    iny
    // for( char c: 0..10)
    inx
    cpx #$b
    bne __b2
    inc.z c
    lda #$b
    cmp.z c
    bne __b1
    // }
    rts
}
