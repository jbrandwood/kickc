.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
  jsr main
main: {
    .label print22_at = screen+$50
    ldx #0
    ldy #0
  print21_b1:
    lda print21_msg,y
    sta screen,x
    inx
    inx
    iny
    lda print21_msg,y
    cmp #'@'
    bne print21_b1
    ldx #0
    ldy #0
  print22_b1:
    lda print21_msg,y
    sta print22_at,x
    inx
    inx
    iny
    lda print21_msg,y
    cmp #'@'
    bne print22_b1
    rts
    print21_msg: .text "hello world!@"
}
