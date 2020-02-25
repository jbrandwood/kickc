// TEst inlining a slightly complex print function (containing a loop)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    .label print2_at = screen+2*$28
    ldx #0
    ldy #0
  print1___b1:
    // for(byte i=0; msg[i]; i++)
    lda #0
    cmp hello,y
    bne print1___b2
    tax
    tay
  print2___b1:
    // for(byte i=0; msg[i]; i++)
    lda #0
    cmp hello,y
    bne print2___b2
    // }
    rts
  print2___b2:
    // at[j] = msg[i]
    lda hello,y
    sta print2_at,x
    // j += 2
    inx
    inx
    // for(byte i=0; msg[i]; i++)
    iny
    jmp print2___b1
  print1___b2:
    // at[j] = msg[i]
    lda hello,y
    sta screen,x
    // j += 2
    inx
    inx
    // for(byte i=0; msg[i]; i++)
    iny
    jmp print1___b1
    hello: .text "hello world!"
    .byte 0
}
