.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    lda #<screen
    sta.z print2.at
    lda #>screen
    sta.z print2.at+1
    jsr print2
    lda #<screen+$50
    sta.z print2.at
    lda #>screen+$50
    sta.z print2.at+1
    jsr print2
    rts
    hello: .text "hello world!"
    .byte 0
}
// print2(byte* zeropage(2) at)
print2: {
    .label at = 2
    ldy #0
    ldx #0
  __b1:
    lda main.hello,x
    cmp #0
    bne __b2
    rts
  __b2:
    lda main.hello,x
    sta (at),y
    iny
    iny
    inx
    jmp __b1
}
