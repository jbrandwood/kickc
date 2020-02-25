.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    // print2(screen, hello)
    lda #<screen
    sta.z print2.at
    lda #>screen
    sta.z print2.at+1
    jsr print2
    // print2(screen+80, hello)
    lda #<screen+$50
    sta.z print2.at
    lda #>screen+$50
    sta.z print2.at+1
    jsr print2
    // }
    rts
    hello: .text "hello world!"
    .byte 0
}
// print2(byte* zp(2) at)
print2: {
    .label at = 2
    ldy #0
    ldx #0
  __b1:
    // for(byte i=0; msg[i]; i++)
    lda main.hello,x
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // at[j] = msg[i]
    lda main.hello,x
    sta (at),y
    // j += 2
    iny
    iny
    // for(byte i=0; msg[i]; i++)
    inx
    jmp __b1
}
