.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  jsr main
main: {
    ldx #0
    ldy #0
  b1:
    lda TXT,y
    sta SCREEN,x
    iny
    cpy #8
    bne b2
    ldy #0
  b2:
    inx
    cpx #$65
    bne b1
    rts
}
  TXT: .byte 3, 1, $d, 5, $c, $f, $14, $20
