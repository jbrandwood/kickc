.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    .label print22_at = screen+$50
    ldx #0
    ldy #0
  print21___b1:
    // for(byte i=0; msg[i]; i++)
    lda #0
    cmp hello,y
    bne print21___b2
    tax
    tay
  print22___b1:
    // for(byte i=0; msg[i]; i++)
    lda #0
    cmp hello,y
    bne print22___b2
    // }
    rts
  print22___b2:
    // at[j] = msg[i]
    lda hello,y
    sta print22_at,x
    // j += 2
    inx
    inx
    // for(byte i=0; msg[i]; i++)
    iny
    jmp print22___b1
  print21___b2:
    // at[j] = msg[i]
    lda hello,y
    sta screen,x
    // j += 2
    inx
    inx
    // for(byte i=0; msg[i]; i++)
    iny
    jmp print21___b1
    hello: .text "hello world!"
    .byte 0
}
