.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    lda #<screen
    sta print2.at
    lda #>screen
    sta print2.at+1
    jsr print2
    lda #<screen+$50
    sta print2.at
    lda #>screen+$50
    sta print2.at+1
    jsr print2
    rts
    hello: .text "hello world!@"
}
// print2(byte* zeropage(2) at)
print2: {
    .label at = 2
    ldy #0
    ldx #0
  b1:
    lda main.hello,x
    cmp #'@'
    bne b2
    rts
  b2:
    lda main.hello,x
    sta (at),y
    iny
    iny
    inx
    jmp b1
}
