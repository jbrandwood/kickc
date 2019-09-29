.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    .label print22_at = screen+$50
    ldx #0
    ldy #0
  print21___b1:
    lda #0
    cmp hello,y
    bne print21___b2
    tax
    tay
  print22___b1:
    lda #0
    cmp hello,y
    bne print22___b2
    rts
  print22___b2:
    lda hello,y
    sta print22_at,x
    inx
    inx
    iny
    jmp print22___b1
  print21___b2:
    lda hello,y
    sta screen,x
    inx
    inx
    iny
    jmp print21___b1
    hello: .text "hello world!"
    .byte 0
}
