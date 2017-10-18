  .const SCREEN = $400
  TXT: .byte 3, 1, $d, 5, $c, $f, $14, $20
  jsr main
main: {
    ldx #0
    ldy #0
  b1:
    lda TXT,y
    sta SCREEN,x
    iny
    cpy #8
    bne b6
    ldy #0
  b2:
    inx
    cpx #$65
    bne b1
    rts
  b6:
    jmp b2
}
