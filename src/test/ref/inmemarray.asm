.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
    ldy #0
  __b1:
    // SCREEN[i] = TXT[j]
    lda TXT,y
    sta SCREEN,x
    // if(++j==8)
    iny
    cpy #8
    bne __b2
    ldy #0
  __b2:
    // for(byte i : 0..100)
    inx
    cpx #$65
    bne __b1
    // }
    rts
}
  TXT: .byte 3, 1, $d, 5, $c, $f, $14, $20
