.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    .label print22_at = screen+$50
    ldx #0
    ldy #0
  print21_b1:
    lda hello,y
    sta screen,x
    inx
    inx
    iny
    lda hello,y
    cmp #'@'
    bne print21_b1
    ldx #0
    ldy #0
  print22_b1:
    lda hello,y
    sta print22_at,x
    inx
    inx
    iny
    lda hello,y
    cmp #'@'
    bne print22_b1
    rts
    hello: .text "hello world!@"
}
