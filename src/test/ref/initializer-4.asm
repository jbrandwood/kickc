// Demonstrates an array with a trailing comma
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
    ldy #0
  __b1:
    // SCREEN[idx++] = chars[i]
    lda chars,y
    sta SCREEN,x
    // SCREEN[idx++] = chars[i];
    inx
    // for( char i: 0..2)
    iny
    cpy #3
    bne __b1
    // }
    rts
}
  chars: .byte 1, 2, 3
