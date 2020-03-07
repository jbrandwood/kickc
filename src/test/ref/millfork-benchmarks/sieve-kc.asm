.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .const COUNT = $4000
  .const SQRT_COUNT = $80
  .label last_time = 6
  .label print_line_cursor = 2
  .label print_char_cursor = 4
  .label Ticks = 8
  .label Ticks_1 = $a
__bbegin:
  // last_time
  lda #<0
  sta.z last_time
  sta.z last_time+1
  jsr main
  rts
main: {
    // start()
    jsr start
    // round()
    jsr round
    // round()
    jsr round
    // round()
    jsr round
    // round()
    jsr round
    // round()
    jsr round
    // round()
    jsr round
    // round()
    jsr round
    // round()
    jsr round
    // round()
    jsr round
    // round()
    jsr round
    // end()
    jsr end
    // }
    rts
}
end: {
    // Ticks = last_time
    lda.z last_time
    sta.z Ticks
    lda.z last_time+1
    sta.z Ticks+1
    // start()
    jsr start
    // last_time -= Ticks
    lda.z last_time
    sec
    sbc.z Ticks
    sta.z last_time
    lda.z last_time+1
    sbc.z Ticks+1
    sta.z last_time+1
    // Ticks = last_time
    lda.z last_time
    sta.z Ticks_1
    lda.z last_time+1
    sta.z Ticks_1+1
    // print_word(Ticks)
    jsr print_word
    // print_ln()
    jsr print_ln
    // }
    rts
}
// Print a newline
print_ln: {
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
  __b1:
    // print_line_cursor + $28
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    // while (print_line_cursor<print_char_cursor)
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    // }
    rts
}
// Print a word as HEX
// print_word(word zp($a) w)
print_word: {
    .label w = $a
    // print_byte(>w)
    lda.z w+1
    tax
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    jsr print_byte
    // print_byte(<w)
    lda.z w
    tax
    jsr print_byte
    // }
    rts
}
// Print a byte as HEX
// print_byte(byte register(X) b)
print_byte: {
    // b>>4
    txa
    lsr
    lsr
    lsr
    lsr
    // print_char(print_hextab[b>>4])
    tay
    lda print_hextab,y
  // Table of hexadecimal digits
    jsr print_char
    // b&$f
    lda #$f
    axs #0
    // print_char(print_hextab[b&$f])
    lda print_hextab,x
    jsr print_char
    // }
    rts
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    // *(print_char_cursor++) = ch
    ldy #0
    sta (print_char_cursor),y
    // *(print_char_cursor++) = ch;
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    // }
    rts
}
start: {
    .label LAST_TIME = last_time
    // asm
    jsr $ffde
    sta LAST_TIME
    stx LAST_TIME+1
    // }
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
    // for(char* p=Sieve;p<Sieve+COUNT;++p)
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
    // while (I < SQRT_COUNT)
    cpx #SQRT_COUNT
    bcc __b4
    // }
    rts
  __b4:
    // if (Sieve[I] == 0)
    lda Sieve,x
    cmp #0
    bne __b5
    // I<<1
    txa
    asl
    // S = Sieve + I<<1
    clc
    adc #<Sieve
    sta.z S
    lda #>Sieve
    adc #0
    sta.z S+1
  __b6:
    // while (S < Sieve + COUNT)
    lda.z S+1
    cmp #>Sieve+COUNT
    bcc __b7
    bne !+
    lda.z S
    cmp #<Sieve+COUNT
    bcc __b7
  !:
  __b5:
    // ++I;
    inx
    jmp __b3
  __b7:
    // *S = 1
    lda #1
    ldy #0
    sta (S),y
    // S += I
    txa
    clc
    adc.z S
    sta.z S
    bcc !+
    inc.z S+1
  !:
    jmp __b6
  __b2:
    // *p = 0
    lda #0
    tay
    sta (p),y
    // for(char* p=Sieve;p<Sieve+COUNT;++p)
    inc.z p
    bne !+
    inc.z p+1
  !:
    jmp __b1
}
  print_hextab: .text "0123456789abcdef"
  .align $100
  Sieve: .fill COUNT, 0
