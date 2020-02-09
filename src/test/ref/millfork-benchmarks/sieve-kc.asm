.pc = $801 "Basic"
:BasicUpstart(__b1)
.pc = $80d "Program"
  .const COUNT = $4000
  .const SQRT_COUNT = $80
  .label last_time = 6
  .label rand_seed = 8
  .label print_line_cursor = 2
  .label print_char_cursor = 4
  .label Ticks = $a
  .label Ticks_1 = $c
__b1:
  lda #<0
  sta.z last_time
  sta.z last_time+1
  sta.z rand_seed
  sta.z rand_seed+1
  jsr main
  rts
main: {
    jsr start
    jsr round
    jsr round
    jsr round
    jsr round
    jsr round
    jsr round
    jsr round
    jsr round
    jsr round
    jsr round
    jsr end
    rts
}
end: {
    lda.z last_time
    sta.z Ticks
    lda.z last_time+1
    sta.z Ticks+1
    jsr start
    lda.z last_time
    sec
    sbc.z Ticks
    sta.z last_time
    lda.z last_time+1
    sbc.z Ticks+1
    sta.z last_time+1
    lda.z last_time
    sta.z Ticks_1
    lda.z last_time+1
    sta.z Ticks_1+1
    jsr print_word
    jsr print_ln
    rts
}
// Print a newline
print_ln: {
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
  __b1:
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    rts
}
// Print a word as HEX
// print_word(word zp($c) w)
print_word: {
    .label w = $c
    lda.z w+1
    tax
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    jsr print_byte
    lda.z w
    tax
    jsr print_byte
    rts
}
// Print a byte as HEX
// print_byte(byte register(X) b)
print_byte: {
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    jsr print_char
    lda #$f
    axs #0
    lda print_hextab,x
    jsr print_char
    rts
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    rts
}
start: {
    .label LAST_TIME = last_time
    jsr $ffde
    sta LAST_TIME
    stx LAST_TIME+1
    lda #<$194a
    sta.z rand_seed
    lda #>$194a
    sta.z rand_seed+1
    rts
}
round: {
    .label p = 2
    .label S = 4
    lda #<Sieve
    sta.z p
    lda #>Sieve
    sta.z p+1
  __b1:
    lda.z p+1
    cmp #>Sieve+COUNT
    bcc __b2
    bne !+
    lda.z p
    cmp #<Sieve+COUNT
    bcc __b2
  !:
    ldx #2
  __b3:
    cpx #SQRT_COUNT
    bcc __b4
    rts
  __b4:
    lda Sieve,x
    cmp #0
    bne __b5
    txa
    asl
    clc
    adc #<Sieve
    sta.z S
    lda #>Sieve
    adc #0
    sta.z S+1
  __b6:
    lda.z S+1
    cmp #>Sieve+COUNT
    bcc __b7
    bne !+
    lda.z S
    cmp #<Sieve+COUNT
    bcc __b7
  !:
  __b5:
    inx
    jmp __b3
  __b7:
    lda #1
    ldy #0
    sta (S),y
    txa
    clc
    adc.z S
    sta.z S
    bcc !+
    inc.z S+1
  !:
    jmp __b6
  __b2:
    lda #0
    tay
    sta (p),y
    inc.z p
    bne !+
    inc.z p+1
  !:
    jmp __b1
}
  print_hextab: .text "0123456789abcdef"
  .align $100
  Sieve: .fill COUNT, 0
