.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    .label print22_at = screen+$50
    ldx #0
    ldy #0
  print21_b1:
    lda #'@'
    cmp hello,y
    bne print21_b2
    ldx #0
    ldy #0
  print22_b1:
    lda #'@'
    cmp hello,y
    bne print22_b2
    rts
  print22_b2:
    lda hello,y
    sta print22_at,x
    inx
    inx
    iny
    jmp print22_b1
  print21_b2:
    lda hello,y
    sta screen,x
    inx
    inx
    iny
    jmp print21_b1
    hello: .text "hello world!"
    .byte 0
}
