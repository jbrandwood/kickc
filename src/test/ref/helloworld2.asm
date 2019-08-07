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
    .label j = 4
    .label at = 2
    lda #0
    sta.z j
    tax
  b1:
    txa
    tay
    lda #0
    cmp main.hello,y
    bne b2
    rts
  b2:
    lda main.hello,x
    ldy.z j
    sta (at),y
    tya
    clc
    adc #2
    sta.z j
    inx
    jmp b1
}
