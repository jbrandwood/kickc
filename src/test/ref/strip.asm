// Tests of strip() function from https://news.ycombinator.com/item?id=12080871
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = 2
main: {
    ldx #' '
    lda #<msg1
    sta.z strip.dest
    lda #>msg1
    sta.z strip.dest+1
    jsr strip
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #<msg1
    sta.z print.msg
    lda #>msg1
    sta.z print.msg+1
    jsr print
    ldx #'y'
    lda #<msg2
    sta.z strip.dest
    lda #>msg2
    sta.z strip.dest+1
    jsr strip
    lda #<msg2
    sta.z print.msg
    lda #>msg2
    sta.z print.msg+1
    jsr print
    rts
}
// print(byte* zeropage(4) msg)
print: {
    .label msg = 4
  __b1:
    ldy #0
    lda (msg),y
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z msg
    bne !+
    inc.z msg+1
  !:
    ldy #0
    lda (msg),y
    cmp #0
    bne __b1
    rts
}
// strip(byte* zeropage(8) p, byte register(X) c)
strip: {
    .label dest = 6
    .label p = 8
    .label p_1 = 4
    lda.z dest
    sta.z p_1
    lda.z dest+1
    sta.z p_1+1
  __b1:
    txa
    ldy #0
    cmp (p_1),y
    beq __b2
    lda (p_1),y
    sta (dest),y
    inc.z dest
    bne !+
    inc.z dest+1
  !:
  __b2:
    lda.z p_1
    clc
    adc #1
    sta.z p
    lda.z p_1+1
    adc #0
    sta.z p+1
    ldy #0
    lda (p_1),y
    cmp #0
    bne __b4
    rts
  __b4:
    lda.z p
    sta.z p_1
    lda.z p+1
    sta.z p_1+1
    jmp __b1
}
  msg1: .text "hello world!"
  .byte 0
  msg2: .text "goodbye blue sky!"
  .byte 0
