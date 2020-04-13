// Test the fast multiplication library
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
  .label print_char_cursor = 8
  .label print_line_cursor = 2
main: {
    // *BGCOL = 5
    lda #5
    sta BGCOL
    // print_cls()
    jsr print_cls
    // mulf_init()
    jsr mulf_init
    // mul16u_compare()
    jsr mul16u_compare
    // mul16s_compare()
    jsr mul16s_compare
    // }
    rts
}
// Perform many possible word multiplications (slow and fast) and compare the results
mul16s_compare: {
    .label a = $16
    .label b = $18
    .label ms = 4
    .label mn = $e
    .label mf = $a
    .label i = $1a
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #0
    sta.z i
    lda #<-$7fff
    sta.z b
    lda #>-$7fff
    sta.z b+1
    lda #<-$7fff
    sta.z a
    lda #>-$7fff
    sta.z a+1
  __b1:
    // print_str(".")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    ldy #0
  __b2:
    // a=a+3371
    clc
    lda.z a
    adc #<$d2b
    sta.z a
    lda.z a+1
    adc #>$d2b
    sta.z a+1
    // b=b+4093
    clc
    lda.z b
    adc #<$ffd
    sta.z b
    lda.z b+1
    adc #>$ffd
    sta.z b+1
    // muls16s(a, b)
    jsr muls16s
    // ms = muls16s(a, b)
    // mul16s(a,b)
    jsr mul16s
    // mn = mul16s(a,b)
    // mulf16s(a,b)
    jsr mulf16s
    // mf = mulf16s(a,b)
    // if(ms!=mf)
    lda.z ms
    cmp.z mf
    bne !+
    lda.z ms+1
    cmp.z mf+1
    bne !+
    lda.z ms+2
    cmp.z mf+2
    bne !+
    lda.z ms+3
    cmp.z mf+3
    beq __b6
  !:
    ldx #0
    jmp __b3
  __b6:
    ldx #1
  __b3:
    // if(ms!=mn)
    lda.z ms
    cmp.z mn
    bne !+
    lda.z ms+1
    cmp.z mn+1
    bne !+
    lda.z ms+2
    cmp.z mn+2
    bne !+
    lda.z ms+3
    cmp.z mn+3
    beq __b4
  !:
    ldx #0
  __b4:
    // if(ok==0)
    cpx #0
    bne __b5
    // *BGCOL = 2
    lda #2
    sta BGCOL
    // mul16s_error(a,b, ms, mn, mf)
    jsr mul16s_error
    // }
    rts
  __b5:
    // for(byte j: 0..15)
    iny
    cpy #$10
    bne __b2
    // for(byte i: 0..15)
    inc.z i
    lda #$10
    cmp.z i
    beq !__b1+
    jmp __b1
  !__b1:
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("signed word multiply results match!")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_ln()
    jsr print_ln
    rts
    str1: .text "signed word multiply results match!"
    .byte 0
}
// Print a newline
print_ln: {
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
// Print a zero-terminated string
// print_str(byte* zp($22) str)
print_str: {
    .label str = $22
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // *(print_char_cursor++) = *(str++)
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    // *(print_char_cursor++) = *(str++);
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// mul16s_error(signed word zp($16) a, signed word zp($18) b, signed dword zp(4) ms, signed dword zp($e) mn, signed dword zp($a) mf)
mul16s_error: {
    .label a = $16
    .label b = $18
    .label ms = 4
    .label mn = $e
    .label mf = $a
    // print_str("signed word multiply mismatch ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_sint(a)
    jsr print_sint
    // print_str("*")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_sint(b)
    lda.z b
    sta.z print_sint.w
    lda.z b+1
    sta.z print_sint.w+1
    jsr print_sint
    // print_str(" slow:")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_slong(ms)
    jsr print_slong
    // print_str(" / normal:")
    lda #<str3
    sta.z print_str.str
    lda #>str3
    sta.z print_str.str+1
    jsr print_str
    // print_slong(mn)
    lda.z mn
    sta.z print_slong.dw
    lda.z mn+1
    sta.z print_slong.dw+1
    lda.z mn+2
    sta.z print_slong.dw+2
    lda.z mn+3
    sta.z print_slong.dw+3
    jsr print_slong
    // print_str(" / fast:")
    lda #<str4
    sta.z print_str.str
    lda #>str4
    sta.z print_str.str+1
    jsr print_str
    // print_slong(mf)
    lda.z mf
    sta.z print_slong.dw
    lda.z mf+1
    sta.z print_slong.dw+1
    lda.z mf+2
    sta.z print_slong.dw+2
    lda.z mf+3
    sta.z print_slong.dw+3
    jsr print_slong
    // print_ln()
    jsr print_ln
    // }
    rts
    str: .text "signed word multiply mismatch "
    .byte 0
}
// Print a signed long as HEX
// print_slong(signed dword zp(4) dw)
print_slong: {
    .label dw = 4
    // if(dw<0)
    lda.z dw+3
    bmi __b1
    // print_char(' ')
    lda #' '
    jsr print_char
  __b2:
    // print_ulong((unsigned long)dw)
    jsr print_ulong
    // }
    rts
  __b1:
    // print_char('-')
    lda #'-'
    jsr print_char
    // dw = -dw
    sec
    lda.z dw
    eor #$ff
    adc #0
    sta.z dw
    lda.z dw+1
    eor #$ff
    adc #0
    sta.z dw+1
    lda.z dw+2
    eor #$ff
    adc #0
    sta.z dw+2
    lda.z dw+3
    eor #$ff
    adc #0
    sta.z dw+3
    jmp __b2
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
// Print a unsigned long as HEX
// print_ulong(dword zp(4) dw)
print_ulong: {
    .label dw = 4
    // print_uint(>dw)
    lda.z dw+2
    sta.z print_uint.w
    lda.z dw+3
    sta.z print_uint.w+1
    jsr print_uint
    // print_uint(<dw)
    lda.z dw
    sta.z print_uint.w
    lda.z dw+1
    sta.z print_uint.w+1
    jsr print_uint
    // }
    rts
}
// Print a unsigned int as HEX
// print_uint(word zp($16) w)
print_uint: {
    .label w = $16
    // print_u8(>w)
    ldx.z w+1
    jsr print_u8
    // print_u8(<w)
    ldx.z w
    jsr print_u8
    // }
    rts
}
// Print a char as HEX
// print_u8(byte register(X) b)
print_u8: {
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
// Print a signed int as HEX
// print_sint(signed word zp($16) w)
print_sint: {
    .label w = $16
    // if(w<0)
    lda.z w+1
    bmi __b1
    // print_char(' ')
    lda #' '
    jsr print_char
  __b2:
    // print_uint((unsigned int)w)
    jsr print_uint
    // }
    rts
  __b1:
    // print_char('-')
    lda #'-'
    jsr print_char
    // w = -w
    sec
    lda #0
    sbc.z w
    sta.z w
    lda #0
    sbc.z w+1
    sta.z w+1
    jmp __b2
}
// Fast multiply two signed ints to a signed double unsigned int result
// Fixes offsets introduced by using unsigned multiplication
// mulf16s(signed word zp($16) a, signed word zp($18) b)
mulf16s: {
    .label __9 = $1c
    .label __13 = $1e
    .label __16 = $1c
    .label __17 = $1e
    .label m = $a
    .label return = $a
    .label a = $16
    .label b = $18
    // mulf16u((unsigned int)a, (unsigned int)b)
    lda.z a
    sta.z mulf16u.a
    lda.z a+1
    sta.z mulf16u.a+1
    lda.z b
    sta.z mulf16u.b
    lda.z b+1
    sta.z mulf16u.b+1
    jsr mulf16u
    // mulf16u((unsigned int)a, (unsigned int)b)
    // m = mulf16u((unsigned int)a, (unsigned int)b)
    // if(a<0)
    lda.z a+1
    bpl __b1
    // >m
    lda.z m+2
    sta.z __9
    lda.z m+3
    sta.z __9+1
    // >m = (>m)-(unsigned int)b
    lda.z __16
    sec
    sbc.z b
    sta.z __16
    lda.z __16+1
    sbc.z b+1
    sta.z __16+1
    lda.z __16
    sta.z m+2
    lda.z __16+1
    sta.z m+3
  __b1:
    // if(b<0)
    lda.z b+1
    bpl __b2
    // >m
    lda.z m+2
    sta.z __13
    lda.z m+3
    sta.z __13+1
    // >m = (>m)-(unsigned int)a
    lda.z __17
    sec
    sbc.z a
    sta.z __17
    lda.z __17+1
    sbc.z a+1
    sta.z __17+1
    lda.z __17
    sta.z m+2
    lda.z __17+1
    sta.z m+3
  __b2:
    // (signed long)m
    // }
    rts
}
// Fast multiply two unsigned ints to a double unsigned int result
// Done in assembler to utilize fast addition A+X
// mulf16u(word zp($1c) a, word zp($1e) b)
mulf16u: {
    .label memA = $f8
    .label memB = $fa
    .label memR = $fc
    .label return = $a
    .label a = $1c
    .label b = $1e
    // *memA = a
    lda.z a
    sta memA
    lda.z a+1
    sta memA+1
    // *memB = b
    lda.z b
    sta memB
    lda.z b+1
    sta memB+1
    // asm
    lda memA
    sta sm1a+1
    sta sm3a+1
    sta sm5a+1
    sta sm7a+1
    eor #$ff
    sta sm2a+1
    sta sm4a+1
    sta sm6a+1
    sta sm8a+1
    lda memA+1
    sta sm1b+1
    sta sm3b+1
    sta sm5b+1
    sta sm7b+1
    eor #$ff
    sta sm2b+1
    sta sm4b+1
    sta sm6b+1
    sta sm8b+1
    ldx memB
    sec
  sm1a:
    lda mulf_sqr1_lo,x
  sm2a:
    sbc mulf_sqr2_lo,x
    sta memR+0
  sm3a:
    lda mulf_sqr1_hi,x
  sm4a:
    sbc mulf_sqr2_hi,x
    sta _AA+1
    sec
  sm1b:
    lda mulf_sqr1_lo,x
  sm2b:
    sbc mulf_sqr2_lo,x
    sta _cc+1
  sm3b:
    lda mulf_sqr1_hi,x
  sm4b:
    sbc mulf_sqr2_hi,x
    sta _CC+1
    ldx memB+1
    sec
  sm5a:
    lda mulf_sqr1_lo,x
  sm6a:
    sbc mulf_sqr2_lo,x
    sta _bb+1
  sm7a:
    lda mulf_sqr1_hi,x
  sm8a:
    sbc mulf_sqr2_hi,x
    sta _BB+1
    sec
  sm5b:
    lda mulf_sqr1_lo,x
  sm6b:
    sbc mulf_sqr2_lo,x
    sta _dd+1
  sm7b:
    lda mulf_sqr1_hi,x
  sm8b:
    sbc mulf_sqr2_hi,x
    sta memR+3
    clc
  _AA:
    lda #0
  _bb:
    adc #0
    sta memR+1
  _BB:
    lda #0
  _CC:
    adc #0
    sta memR+2
    bcc !+
    inc memR+3
    clc
  !:
  _cc:
    lda #0
    adc memR+1
    sta memR+1
  _dd:
    lda #0
    adc memR+2
    sta memR+2
    bcc !+
    inc memR+3
  !:
    // return *memR;
    lda memR
    sta.z return
    lda memR+1
    sta.z return+1
    lda memR+2
    sta.z return+2
    lda memR+3
    sta.z return+3
    // }
    rts
}
// Multiply of two signed ints to a signed long
// Fixes offsets introduced by using unsigned multiplication
// mul16s(signed word zp($16) a, signed word zp($18) b)
mul16s: {
    .label __9 = $20
    .label __13 = $22
    .label __16 = $20
    .label __17 = $22
    .label m = $e
    .label return = $e
    .label a = $16
    .label b = $18
    // mul16u((unsigned int)a, (unsigned int) b)
    lda.z a
    sta.z mul16u.a
    lda.z a+1
    sta.z mul16u.a+1
    lda.z b
    sta.z mul16u.b
    lda.z b+1
    sta.z mul16u.b+1
    jsr mul16u
    // mul16u((unsigned int)a, (unsigned int) b)
    // m = mul16u((unsigned int)a, (unsigned int) b)
    // if(a<0)
    lda.z a+1
    bpl __b1
    // >m
    lda.z m+2
    sta.z __9
    lda.z m+3
    sta.z __9+1
    // >m = (>m)-(unsigned int)b
    lda.z __16
    sec
    sbc.z b
    sta.z __16
    lda.z __16+1
    sbc.z b+1
    sta.z __16+1
    lda.z __16
    sta.z m+2
    lda.z __16+1
    sta.z m+3
  __b1:
    // if(b<0)
    lda.z b+1
    bpl __b2
    // >m
    lda.z m+2
    sta.z __13
    lda.z m+3
    sta.z __13+1
    // >m = (>m)-(unsigned int)a
    lda.z __17
    sec
    sbc.z a
    sta.z __17
    lda.z __17+1
    sbc.z a+1
    sta.z __17+1
    lda.z __17
    sta.z m+2
    lda.z __17+1
    sta.z m+3
  __b2:
    // (signed long)m
    // }
    rts
}
// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned long
// mul16u(word zp($22) a, word zp($1e) b)
mul16u: {
    .label mb = $12
    .label a = $22
    .label res = $e
    .label b = $1e
    .label return = $e
    // mb = b
    lda.z b
    sta.z mb
    lda.z b+1
    sta.z mb+1
    lda #0
    sta.z mb+2
    sta.z mb+3
    sta.z res
    sta.z res+1
    lda #<0>>$10
    sta.z res+2
    lda #>0>>$10
    sta.z res+3
  __b1:
    // while(a!=0)
    lda.z a
    bne __b2
    lda.z a+1
    bne __b2
    // }
    rts
  __b2:
    // a&1
    lda #1
    and.z a
    // if( (a&1) != 0)
    cmp #0
    beq __b3
    // res = res + mb
    lda.z res
    clc
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
    lda.z res+2
    adc.z mb+2
    sta.z res+2
    lda.z res+3
    adc.z mb+3
    sta.z res+3
  __b3:
    // a = a>>1
    lsr.z a+1
    ror.z a
    // mb = mb<<1
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    jmp __b1
}
// Slow multiplication of signed words
// Perform a signed multiplication by repeated addition/subtraction
// muls16s(signed word zp($16) a, signed word zp($18) b)
muls16s: {
    .label m = 4
    .label j = $1c
    .label return = 4
    .label i = $1e
    .label a = $16
    .label b = $18
    // if(a<0)
    lda.z a+1
    bmi __b8
    // if (a>0)
    bmi __b7
    bne !+
    lda.z a
    beq __b7
  !:
    lda #<0
    sta.z m
    sta.z m+1
    lda #<0>>$10
    sta.z m+2
    lda #>0>>$10
    sta.z m+3
    lda #<0
    sta.z j
    sta.z j+1
  __b3:
    // for(signed word j = 0; j!=a; j++)
    lda.z j+1
    cmp.z a+1
    bne __b4
    lda.z j
    cmp.z a
    bne __b4
    rts
  __b7:
    lda #<0
    sta.z return
    sta.z return+1
    lda #<0>>$10
    sta.z return+2
    lda #>0>>$10
    sta.z return+3
    // }
    rts
  __b4:
    // m = m + b
    lda.z b+1
    ora #$7f
    bmi !+
    lda #0
  !:
    sta.z $ff
    lda.z m
    clc
    adc.z b
    sta.z m
    lda.z m+1
    adc.z b+1
    sta.z m+1
    lda.z m+2
    adc.z $ff
    sta.z m+2
    lda.z m+3
    adc.z $ff
    sta.z m+3
    // for(signed word j = 0; j!=a; j++)
    inc.z j
    bne !+
    inc.z j+1
  !:
    jmp __b3
  __b8:
    lda #<0
    sta.z m
    sta.z m+1
    lda #<0>>$10
    sta.z m+2
    lda #>0>>$10
    sta.z m+3
    lda #<0
    sta.z i
    sta.z i+1
  __b5:
    // for(signed word i = 0; i!=a; i--)
    lda.z i+1
    cmp.z a+1
    bne __b6
    lda.z i
    cmp.z a
    bne __b6
    rts
  __b6:
    // m = m - b
    lda.z b+1
    ora #$7f
    bmi !+
    lda #0
  !:
    sta.z $ff
    sec
    lda.z m
    sbc.z b
    sta.z m
    lda.z m+1
    sbc.z b+1
    sta.z m+1
    lda.z m+2
    sbc.z $ff
    sta.z m+2
    lda.z m+3
    sbc.z $ff
    sta.z m+3
    // for(signed word i = 0; i!=a; i--)
    lda.z i
    bne !+
    dec.z i+1
  !:
    dec.z i
    jmp __b5
}
// Perform many possible word multiplications (slow and fast) and compare the results
mul16u_compare: {
    .label a = $1c
    .label b = $1e
    .label ms = 4
    .label mn = $e
    .label mf = $a
    .label i = $1a
    lda #0
    sta.z i
    sta.z b
    sta.z b+1
    sta.z a
    sta.z a+1
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
  __b1:
    // print_str(".")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    ldy #0
  __b2:
    // a=a+3371
    clc
    lda.z a
    adc #<$d2b
    sta.z a
    lda.z a+1
    adc #>$d2b
    sta.z a+1
    // b=b+4093
    clc
    lda.z b
    adc #<$ffd
    sta.z b
    lda.z b+1
    adc #>$ffd
    sta.z b+1
    // muls16u(a, b)
    jsr muls16u
    // ms = muls16u(a, b)
    // mul16u(a,b)
    lda.z a
    sta.z mul16u.a
    lda.z a+1
    sta.z mul16u.a+1
    jsr mul16u
    // mul16u(a,b)
    // mn = mul16u(a,b)
    // mulf16u(a,b)
    jsr mulf16u
    // mulf16u(a,b)
    // mf = mulf16u(a,b)
    // if(ms!=mf)
    lda.z ms
    cmp.z mf
    bne !+
    lda.z ms+1
    cmp.z mf+1
    bne !+
    lda.z ms+2
    cmp.z mf+2
    bne !+
    lda.z ms+3
    cmp.z mf+3
    beq __b6
  !:
    ldx #0
    jmp __b3
  __b6:
    ldx #1
  __b3:
    // if(ms!=mn)
    lda.z ms
    cmp.z mn
    bne !+
    lda.z ms+1
    cmp.z mn+1
    bne !+
    lda.z ms+2
    cmp.z mn+2
    bne !+
    lda.z ms+3
    cmp.z mn+3
    beq __b4
  !:
    ldx #0
  __b4:
    // if(ok==0)
    cpx #0
    bne __b5
    // *BGCOL = 2
    lda #2
    sta BGCOL
    // mul16u_error(a,b, ms, mn, mf)
    lda.z a
    sta.z mul16u_error.a
    lda.z a+1
    sta.z mul16u_error.a+1
    jsr mul16u_error
    // }
    rts
  __b5:
    // for(byte j: 0..15)
    iny
    cpy #$10
    bne __b2
    // for(byte i: 0..15)
    inc.z i
    lda #$10
    cmp.z i
    beq !__b1+
    jmp __b1
  !__b1:
    // print_ln()
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("word multiply results match!")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_ln()
    jsr print_ln
    rts
    str1: .text "word multiply results match!"
    .byte 0
}
// mul16u_error(word zp($16) a, word zp($1e) b, dword zp(4) ms, dword zp($e) mn, dword zp($a) mf)
mul16u_error: {
    .label a = $16
    .label b = $1e
    .label ms = 4
    .label mn = $e
    .label mf = $a
    // print_str("multiply mismatch ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_uint(a)
    jsr print_uint
    // print_str("*")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_uint(b)
    lda.z b
    sta.z print_uint.w
    lda.z b+1
    sta.z print_uint.w+1
    jsr print_uint
    // print_str(" slow:")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_ulong(ms)
    jsr print_ulong
    // print_str(" / normal:")
    lda #<str3
    sta.z print_str.str
    lda #>str3
    sta.z print_str.str+1
    jsr print_str
    // print_ulong(mn)
    lda.z mn
    sta.z print_ulong.dw
    lda.z mn+1
    sta.z print_ulong.dw+1
    lda.z mn+2
    sta.z print_ulong.dw+2
    lda.z mn+3
    sta.z print_ulong.dw+3
    jsr print_ulong
    // print_str(" / fast:")
    lda #<str4
    sta.z print_str.str
    lda #>str4
    sta.z print_str.str+1
    jsr print_str
    // print_ulong(mf)
    lda.z mf
    sta.z print_ulong.dw
    lda.z mf+1
    sta.z print_ulong.dw+1
    lda.z mf+2
    sta.z print_ulong.dw+2
    lda.z mf+3
    sta.z print_ulong.dw+3
    jsr print_ulong
    // print_ln()
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    jsr print_ln
    // }
    rts
    str: .text "multiply mismatch "
    .byte 0
}
// Slow multiplication of unsigned words
// Calculate an unsigned multiplication by repeated addition
// muls16u(word zp($1c) a, word zp($1e) b)
muls16u: {
    .label return = 4
    .label m = 4
    .label i = $16
    .label a = $1c
    .label b = $1e
    // if(a!=0)
    lda.z a
    bne !+
    lda.z a+1
    beq __b4
  !:
    lda #<0
    sta.z m
    sta.z m+1
    lda #<0>>$10
    sta.z m+2
    lda #>0>>$10
    sta.z m+3
    lda #<0
    sta.z i
    sta.z i+1
  __b2:
    // for(word i = 0; i!=a; i++)
    lda.z i+1
    cmp.z a+1
    bne __b3
    lda.z i
    cmp.z a
    bne __b3
    rts
  __b4:
    lda #<0
    sta.z return
    sta.z return+1
    lda #<0>>$10
    sta.z return+2
    lda #>0>>$10
    sta.z return+3
    // }
    rts
  __b3:
    // m = m + b
    lda.z m
    clc
    adc.z b
    sta.z m
    lda.z m+1
    adc.z b+1
    sta.z m+1
    lda.z m+2
    adc #0
    sta.z m+2
    lda.z m+3
    adc #0
    sta.z m+3
    // for(word i = 0; i!=a; i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b2
}
// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
mulf_init: {
    // x/2
    .label c = $1a
    // Counter used for determining x%2==0
    .label sqr1_hi = $22
    // Fill mulf_sqr1 = f(x) = int(x*x/4): If f(x) = x*x/4 then f(x+1) = f(x) + x/2 + 1/4
    .label sqr = $20
    .label sqr1_lo = $18
    // Decrease or increase x_255 - initially we decrease
    .label sqr2_hi = $1e
    .label sqr2_lo = $1c
    //Start with g(0)=f(255)
    .label dir = $1b
    ldx #0
    lda #<mulf_sqr1_hi+1
    sta.z sqr1_hi
    lda #>mulf_sqr1_hi+1
    sta.z sqr1_hi+1
    txa
    sta.z sqr
    sta.z sqr+1
    sta.z c
    lda #<mulf_sqr1_lo+1
    sta.z sqr1_lo
    lda #>mulf_sqr1_lo+1
    sta.z sqr1_lo+1
  __b1:
    // for(char* sqr1_lo = mulf_sqr1_lo+1; sqr1_lo!=mulf_sqr1_lo+512; sqr1_lo++)
    lda.z sqr1_lo+1
    cmp #>mulf_sqr1_lo+$200
    bne __b2
    lda.z sqr1_lo
    cmp #<mulf_sqr1_lo+$200
    bne __b2
    lda #$ff
    sta.z dir
    lda #<mulf_sqr2_hi
    sta.z sqr2_hi
    lda #>mulf_sqr2_hi
    sta.z sqr2_hi+1
    ldx #-1
    lda #<mulf_sqr2_lo
    sta.z sqr2_lo
    lda #>mulf_sqr2_lo
    sta.z sqr2_lo+1
  __b5:
    // for(char* sqr2_lo = mulf_sqr2_lo; sqr2_lo!=mulf_sqr2_lo+511; sqr2_lo++)
    lda.z sqr2_lo+1
    cmp #>mulf_sqr2_lo+$1ff
    bne __b6
    lda.z sqr2_lo
    cmp #<mulf_sqr2_lo+$1ff
    bne __b6
    // *(mulf_sqr2_lo+511) = *(mulf_sqr1_lo+256)
    // Set the very last value g(511) = f(256)
    lda mulf_sqr1_lo+$100
    sta mulf_sqr2_lo+$1ff
    // *(mulf_sqr2_hi+511) = *(mulf_sqr1_hi+256)
    lda mulf_sqr1_hi+$100
    sta mulf_sqr2_hi+$1ff
    // }
    rts
  __b6:
    // *sqr2_lo = mulf_sqr1_lo[x_255]
    lda mulf_sqr1_lo,x
    ldy #0
    sta (sqr2_lo),y
    // *sqr2_hi++ = mulf_sqr1_hi[x_255]
    lda mulf_sqr1_hi,x
    sta (sqr2_hi),y
    // *sqr2_hi++ = mulf_sqr1_hi[x_255];
    inc.z sqr2_hi
    bne !+
    inc.z sqr2_hi+1
  !:
    // x_255 = x_255 + dir
    txa
    clc
    adc.z dir
    tax
    // if(x_255==0)
    cpx #0
    bne __b8
    lda #1
    sta.z dir
  __b8:
    // for(char* sqr2_lo = mulf_sqr2_lo; sqr2_lo!=mulf_sqr2_lo+511; sqr2_lo++)
    inc.z sqr2_lo
    bne !+
    inc.z sqr2_lo+1
  !:
    jmp __b5
  __b2:
    // if((++c&1)==0)
    inc.z c
    // ++c&1
    lda #1
    and.z c
    // if((++c&1)==0)
    cmp #0
    bne __b3
    // x_2++;
    inx
    // sqr++;
    inc.z sqr
    bne !+
    inc.z sqr+1
  !:
  __b3:
    // <sqr
    lda.z sqr
    // *sqr1_lo = <sqr
    ldy #0
    sta (sqr1_lo),y
    // >sqr
    lda.z sqr+1
    // *sqr1_hi++ = >sqr
    sta (sqr1_hi),y
    // *sqr1_hi++ = >sqr;
    inc.z sqr1_hi
    bne !+
    inc.z sqr1_hi+1
  !:
    // sqr = sqr + x_2
    txa
    clc
    adc.z sqr
    sta.z sqr
    bcc !+
    inc.z sqr+1
  !:
    // for(char* sqr1_lo = mulf_sqr1_lo+1; sqr1_lo!=mulf_sqr1_lo+512; sqr1_lo++)
    inc.z sqr1_lo
    bne !+
    inc.z sqr1_lo+1
  !:
    jmp __b1
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = $400
    .label end = str+num
    .label dst = $22
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
  print_hextab: .text "0123456789abcdef"
  // mulf_sqr tables will contain f(x)=int(x*x/4) and g(x) = f(x-255).
  // <f(x) = <(( x * x )/4)
  .align $100
  mulf_sqr1_lo: .fill $200, 0
  // >f(x) = >(( x * x )/4)
  .align $100
  mulf_sqr1_hi: .fill $200, 0
  // <g(x) =  <((( x - 255) * ( x - 255 ))/4)
  .align $100
  mulf_sqr2_lo: .fill $200, 0
  // >g(x) = >((( x - 255) * ( x - 255 ))/4)
  .align $100
  mulf_sqr2_hi: .fill $200, 0
  str: .text "."
  .byte 0
  str1: .text "*"
  .byte 0
  str2: .text " slow:"
  .byte 0
  str3: .text " / normal:"
  .byte 0
  str4: .text " / fast:"
  .byte 0
