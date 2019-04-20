// Tests of strip() function from https://news.ycombinator.com/item?id=12080871
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = 4
main: {
    ldx #' '
    lda #<msg1
    sta strip.dest
    lda #>msg1
    sta strip.dest+1
    jsr strip
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    lda #<msg1
    sta print.msg
    lda #>msg1
    sta print.msg+1
    jsr print
    ldx #'y'
    lda #<msg2
    sta strip.dest
    lda #>msg2
    sta strip.dest+1
    jsr strip
    lda #<msg2
    sta print.msg
    lda #>msg2
    sta print.msg+1
    jsr print
    rts
}
// print(byte* zeropage(2) msg)
print: {
    .label msg = 2
  b1:
    ldy #0
    lda (msg),y
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inc msg
    bne !+
    inc msg+1
  !:
    ldy #0
    lda (msg),y
    cmp #0
    bne b1
    rts
}
// strip(byte* zeropage(8) p, byte register(X) c)
strip: {
    .label dest = 6
    .label p = 8
    .label p_4 = 2
    .label p_7 = 2
    .label p_8 = 2
    lda dest
    sta p_7
    lda dest+1
    sta p_7+1
  b1:
    txa
    ldy #0
    cmp (p_4),y
    beq b2
    lda (p_4),y
    sta (dest),y
    inc dest
    bne !+
    inc dest+1
  !:
  b2:
    lda p_4
    clc
    adc #1
    sta p
    lda p_4+1
    adc #0
    sta p+1
    ldy #0
    lda (p_4),y
    cmp #0
    bne b4
    rts
  b4:
    lda p
    sta p_8
    lda p+1
    sta p_8+1
    jmp b1
}
  msg1: .text "hello world!@"
  msg2: .text "goodbye blue sky!@"
