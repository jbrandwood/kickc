// Test the fast multiplication library
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
  .label print_char_cursor = 4
  .label print_line_cursor = 2
main: {
    // *BGCOL = 5
    lda #5
    sta BGCOL
    // print_cls()
    jsr print_cls
    // mulf_init()
    jsr mulf_init
    // mulf_init_asm()
    jsr mulf_init_asm
    // mulf_tables_cmp()
    jsr mulf_tables_cmp
    // mul8u_compare()
    jsr mul8u_compare
    // mul8s_compare()
    jsr mul8s_compare
    // }
    rts
}
// Perform all possible signed byte multiplications (slow and fast) and compare the results
mul8s_compare: {
    .label ms = 7
    .label mf = 9
    .label mn = $e
    .label a = $d
    .label b = 6
    lda #-$80
    sta.z a
  __b1:
    // for(signed byte a = -128; a!=-128; a++)
    lda #-$80
    cmp.z a
    bne __b2
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("signed multiply results match!")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_ln()
    jsr print_ln
    // }
    rts
  __b2:
    lda #-$80
    sta.z b
  __b3:
    // for(signed byte b = -128; b!=-128; b++)
    lda #-$80
    cmp.z b
    bne __b4
    // for(signed byte a = -128; a!=-128; a++)
    inc.z a
    jmp __b1
  __b4:
    // muls8s(a, b)
    ldx.z b
    jsr muls8s
    // ms = muls8s(a, b)
    // mulf8s(a,b)
    lda.z a
    ldx.z b
    jsr mulf8s
    // mulf8s(a,b)
    // mf = mulf8s(a,b)
    // mul8s(a,b)
    ldy.z b
    jsr mul8s
    // mn = mul8s(a,b)
    // if(ms!=mf)
    lda.z ms
    cmp.z mf
    bne !+
    lda.z ms+1
    cmp.z mf+1
    beq __b5
  !:
    ldx #0
    jmp __b6
  __b5:
    ldx #1
  __b6:
    // if(ms!=mn)
    lda.z ms
    cmp.z mn
    bne !+
    lda.z ms+1
    cmp.z mn+1
    beq __b7
  !:
    ldx #0
  __b7:
    // if(ok==0)
    cpx #0
    bne __b8
    // *BGCOL = 2
    lda #2
    sta BGCOL
    // mul8s_error(a,b, ms, mn, mf)
    ldx.z a
    jsr mul8s_error
    rts
  __b8:
    // for(signed byte b = -128; b!=-128; b++)
    inc.z b
    jmp __b3
    str: .text "signed multiply results match!"
    .byte 0
}
// mul8s_error(signed byte register(X) a, signed byte zp(6) b, signed word zp(7) ms, signed word zp($e) mn, signed word zp(9) mf)
mul8s_error: {
    .label b = 6
    .label ms = 7
    .label mn = $e
    .label mf = 9
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("signed multiply mismatch ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_s8(a)
    jsr print_s8
    // print_str("*")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_s8(b)
    ldx.z b
    jsr print_s8
    // print_str(" slow:")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_sint(ms)
    jsr print_sint
    // print_str(" / normal:")
    lda #<str3
    sta.z print_str.str
    lda #>str3
    sta.z print_str.str+1
    jsr print_str
    // print_sint(mn)
    lda.z mn
    sta.z print_sint.w
    lda.z mn+1
    sta.z print_sint.w+1
    jsr print_sint
    // print_str(" / fast:")
    lda #<str4
    sta.z print_str.str
    lda #>str4
    sta.z print_str.str+1
    jsr print_str
    // print_sint(mf)
    lda.z mf
    sta.z print_sint.w
    lda.z mf+1
    sta.z print_sint.w+1
    jsr print_sint
    // print_ln()
    jsr print_ln
    // }
    rts
    str: .text "signed multiply mismatch "
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
// Print a signed int as HEX
// print_sint(signed word zp(7) w)
print_sint: {
    .label w = 7
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
// Print a unsigned int as HEX
// print_uint(word zp(7) w)
print_uint: {
    .label w = 7
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
// Print a zero-terminated string
// print_str(byte* zp($b) str)
print_str: {
    .label str = $b
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
// Print a signed char as HEX
// print_s8(signed byte register(X) b)
print_s8: {
    // if(b<0)
    cpx #0
    bmi __b1
    // print_char(' ')
    lda #' '
    jsr print_char
  __b2:
    // print_u8((char)b)
    jsr print_u8
    // }
    rts
  __b1:
    // print_char('-')
    lda #'-'
    jsr print_char
    // b = -b
    txa
    eor #$ff
    clc
    adc #1
    tax
    jmp __b2
}
// Multiply of two signed chars to a signed int
// Fixes offsets introduced by using unsigned multiplication
// mul8s(signed byte zp($d) a, signed byte register(Y) b)
mul8s: {
    .label m = $e
    .label a = $d
    // mul8u((char)a, (char) b)
    ldx.z a
    tya
    jsr mul8u
    // mul8u((char)a, (char) b)
    // m = mul8u((char)a, (char) b)
    // if(a<0)
    lda.z a
    cmp #0
    bpl __b1
    // >m
    lda.z m+1
    // >m = (>m)-(char)b
    sty.z $ff
    sec
    sbc.z $ff
    sta.z m+1
  __b1:
    // if(b<0)
    cpy #0
    bpl __b2
    // >m
    lda.z m+1
    // >m = (>m)-(char)a
    sec
    sbc.z a
    sta.z m+1
  __b2:
    // }
    rts
}
// Perform binary multiplication of two unsigned 8-bit chars into a 16-bit unsigned int
// mul8u(byte register(X) a, byte register(A) b)
mul8u: {
    .label mb = $b
    .label res = $e
    .label return = $e
    // mb = b
    sta.z mb
    lda #0
    sta.z mb+1
    sta.z res
    sta.z res+1
  __b1:
    // while(a!=0)
    cpx #0
    bne __b2
    // }
    rts
  __b2:
    // a&1
    txa
    and #1
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
  __b3:
    // a = a>>1
    txa
    lsr
    tax
    // mb = mb<<1
    asl.z mb
    rol.z mb+1
    jmp __b1
}
// Fast multiply two signed chars to a unsigned int result
// mulf8s(signed byte register(A) a, signed byte register(X) b)
mulf8s: {
    .label return = 9
    // mulf8u_prepare((char)a)
    jsr mulf8u_prepare
    // mulf8s_prepared(b)
    stx.z mulf8s_prepared.b
    jsr mulf8s_prepared
    // }
    rts
}
// Calculate fast multiply with a prepared unsigned char to a unsigned int result
// The prepared number is set by calling mulf8s_prepare(char a)
// mulf8s_prepared(signed byte zp($12) b)
mulf8s_prepared: {
    .label memA = $fd
    .label m = 9
    .label b = $12
    // mulf8u_prepared((char) b)
    lda.z b
    jsr mulf8u_prepared
    // mulf8u_prepared((char) b)
    // m = mulf8u_prepared((char) b)
    // if(*memA<0)
    lda memA
    cmp #0
    bpl __b1
    // >m
    lda.z m+1
    // >m = (>m)-(char)b
    sec
    sbc.z b
    sta.z m+1
  __b1:
    // if(b<0)
    lda.z b
    cmp #0
    bpl __b2
    // >m
    lda.z m+1
    // >m = (>m)-(char)*memA
    sec
    sbc memA
    sta.z m+1
  __b2:
    // }
    rts
}
// Calculate fast multiply with a prepared unsigned char to a unsigned int result
// The prepared number is set by calling mulf8u_prepare(char a)
// mulf8u_prepared(byte register(A) b)
mulf8u_prepared: {
    .label resL = $fe
    .label memB = $ff
    .label return = 9
    // *memB = b
    sta memB
    // asm
    tax
    sec
  sm1:
    lda mulf_sqr1_lo,x
  sm2:
    sbc mulf_sqr2_lo,x
    sta resL
  sm3:
    lda mulf_sqr1_hi,x
  sm4:
    sbc mulf_sqr2_hi,x
    sta memB
    // return { *memB, *resL };
    lda resL
    sta.z return
    lda memB
    sta.z return+1
    // }
    rts
}
// Prepare for fast multiply with an unsigned char to a unsigned int result
// mulf8u_prepare(byte register(A) a)
mulf8u_prepare: {
    .label memA = $fd
    // *memA = a
    sta memA
    // asm
    sta mulf8u_prepared.sm1+1
    sta mulf8u_prepared.sm3+1
    eor #$ff
    sta mulf8u_prepared.sm2+1
    sta mulf8u_prepared.sm4+1
    // }
    rts
}
// Slow multiplication of signed bytes
// Perform a signed multiplication by repeated addition/subtraction
// muls8s(signed byte zp($d) a, signed byte register(X) b)
muls8s: {
    .label m = 7
    .label return = 7
    .label a = $d
    // if(a<0)
    lda.z a
    bmi __b8
    // if (a>0)
    cmp #1
    bmi __b7
    lda #<0
    sta.z m
    sta.z m+1
    tay
  __b3:
    // for(signed byte j = 0; j!=a; j++)
    cpy.z a
    bne __b4
    rts
  __b7:
    lda #<0
    sta.z return
    sta.z return+1
    // }
    rts
  __b4:
    // m = m + b
    txa
    sta.z $fe
    ora #$7f
    bmi !+
    lda #0
  !:
    sta.z $ff
    clc
    lda.z m
    adc.z $fe
    sta.z m
    lda.z m+1
    adc.z $ff
    sta.z m+1
    // for(signed byte j = 0; j!=a; j++)
    iny
    jmp __b3
  __b8:
    lda #<0
    sta.z m
    sta.z m+1
    tay
  __b5:
    // for(signed byte i = 0; i!=a; i--)
    cpy.z a
    bne __b6
    rts
  __b6:
    // m = m - b
    txa
    sta.z $fe
    ora #$7f
    bmi !+
    lda #0
  !:
    sta.z $ff
    sec
    lda.z m
    sbc.z $fe
    sta.z m
    lda.z m+1
    sbc.z $ff
    sta.z m+1
    // for(signed byte i = 0; i!=a; i--)
    dey
    jmp __b5
}
// Perform all possible byte multiplications (slow and fast) and compare the results
mul8u_compare: {
    .label ms = 7
    .label mf = 9
    .label mn = $e
    .label b = 6
    .label a = $d
    lda #0
    sta.z a
  __b1:
    lda #0
    sta.z b
  __b2:
    // muls8u(a, b)
    ldx.z b
    jsr muls8u
    // ms = muls8u(a, b)
    // mulf8u(a,b)
    lda.z a
    ldx.z b
    jsr mulf8u
    // mf = mulf8u(a,b)
    // mul8u(a,b)
    ldx.z a
    lda.z b
    jsr mul8u
    // mul8u(a,b)
    // mn = mul8u(a,b)
    // if(ms!=mf)
    lda.z ms
    cmp.z mf
    bne !+
    lda.z ms+1
    cmp.z mf+1
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
    // mul8u_error(a,b, ms, mn, mf)
    ldx.z a
    jsr mul8u_error
    // }
    rts
  __b5:
    // for(byte b: 0..255)
    inc.z b
    lda.z b
    cmp #0
    bne __b2
    // for(byte a: 0..255)
    inc.z a
    lda.z a
    cmp #0
    bne __b1
    // print_str("multiply results match!")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_ln()
    jsr print_ln
    rts
    str: .text "multiply results match!"
    .byte 0
}
// mul8u_error(byte register(X) a, byte zp(6) b, word zp(7) ms, word zp($e) mn, word zp(9) mf)
mul8u_error: {
    .label b = 6
    .label ms = 7
    .label mn = $e
    .label mf = 9
    // print_str("multiply mismatch ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_u8(a)
    jsr print_u8
    // print_str("*")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_u8(b)
    ldx.z b
    jsr print_u8
    // print_str(" slow:")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_uint(ms)
    jsr print_uint
    // print_str(" / normal:")
    lda #<str3
    sta.z print_str.str
    lda #>str3
    sta.z print_str.str+1
    jsr print_str
    // print_uint(mn)
    lda.z mn
    sta.z print_uint.w
    lda.z mn+1
    sta.z print_uint.w+1
    jsr print_uint
    // print_str(" / fast:")
    lda #<str4
    sta.z print_str.str
    lda #>str4
    sta.z print_str.str+1
    jsr print_str
    // print_uint(mf)
    lda.z mf
    sta.z print_uint.w
    lda.z mf+1
    sta.z print_uint.w+1
    jsr print_uint
    // print_ln()
    jsr print_ln
    // }
    rts
    str: .text "multiply mismatch "
    .byte 0
}
// Fast multiply two unsigned chars to a unsigned int result
// mulf8u(byte register(A) a, byte register(X) b)
mulf8u: {
    .label return = 9
    // mulf8u_prepare(a)
    jsr mulf8u_prepare
    // mulf8u_prepared(b)
    txa
    jsr mulf8u_prepared
    // mulf8u_prepared(b)
    // }
    rts
}
// Slow multiplication of unsigned bytes
// Calculate an unsigned multiplication by repeated addition
// muls8u(byte zp($d) a, byte register(X) b)
muls8u: {
    .label return = 7
    .label m = 7
    .label a = $d
    // if(a!=0)
    lda.z a
    cmp #0
    beq __b4
    lda #<0
    sta.z m
    sta.z m+1
    tay
  __b2:
    // for(byte i = 0; i!=a; i++)
    cpy.z a
    bne __b3
    rts
  __b4:
    lda #<0
    sta.z return
    sta.z return+1
    // }
    rts
  __b3:
    // m = m + b
    txa
    clc
    adc.z m
    sta.z m
    bcc !+
    inc.z m+1
  !:
    // for(byte i = 0; i!=a; i++)
    iny
    jmp __b2
}
// Compare the ASM-based mul tables with the KC-based mul tables
// Red screen on failure - green on success
mulf_tables_cmp: {
    .label asm_sqr = 7
    .label kc_sqr = $e
    lda #<mula_sqr1_lo
    sta.z asm_sqr
    lda #>mula_sqr1_lo
    sta.z asm_sqr+1
    lda #<mulf_sqr1_lo
    sta.z kc_sqr
    lda #>mulf_sqr1_lo
    sta.z kc_sqr+1
  __b1:
    // for( byte* kc_sqr=mulf_sqr1_lo; kc_sqr<mulf_sqr1_lo+512*4; kc_sqr++)
    lda.z kc_sqr+1
    cmp #>mulf_sqr1_lo+$200*4
    bcc __b2
    bne !+
    lda.z kc_sqr
    cmp #<mulf_sqr1_lo+$200*4
    bcc __b2
  !:
    // print_str("multiply tables match!")
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
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
    // }
    rts
  __b2:
    // if(*kc_sqr != *asm_sqr)
    ldy #0
    lda (kc_sqr),y
    cmp (asm_sqr),y
    beq __b4
    // *BGCOL = 2
    lda #2
    sta BGCOL
    // print_str("multiply table mismatch at ")
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_uint((word)asm_sqr)
    jsr print_uint
    // print_str(" / ")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_uint((word)kc_sqr)
    lda.z kc_sqr
    sta.z print_uint.w
    lda.z kc_sqr+1
    sta.z print_uint.w+1
    jsr print_uint
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    rts
  __b4:
    // asm_sqr++;
    inc.z asm_sqr
    bne !+
    inc.z asm_sqr+1
  !:
    // for( byte* kc_sqr=mulf_sqr1_lo; kc_sqr<mulf_sqr1_lo+512*4; kc_sqr++)
    inc.z kc_sqr
    bne !+
    inc.z kc_sqr+1
  !:
    jmp __b1
    str: .text "multiply tables match!"
    .byte 0
    str1: .text "multiply table mismatch at "
    .byte 0
    str2: .text " / "
    .byte 0
}
// Initialize the multiplication tables using ASM code from
// http://codebase64.org/doku.php?id=base:seriously_fast_multiplication
mulf_init_asm: {
    // Ensure the ASM tables are not detected as unused by the optimizer
    .label mem = $ff
    // asm
    ldx #0
    txa
    .byte $c9
  lb1:
    tya
    adc #0
  ml1:
    sta mula_sqr1_hi,x
    tay
    cmp #$40
    txa
    ror
  ml9:
    adc #0
    sta ml9+1
    inx
  ml0:
    sta mula_sqr1_lo,x
    bne lb1
    inc ml0+2
    inc ml1+2
    clc
    iny
    bne lb1
    ldx #0
    ldy #$ff
  !:
    lda mula_sqr1_hi+1,x
    sta mula_sqr2_hi+$100,x
    lda mula_sqr1_hi,x
    sta mula_sqr2_hi,y
    lda mula_sqr1_lo+1,x
    sta mula_sqr2_lo+$100,x
    lda mula_sqr1_lo,x
    sta mula_sqr2_lo,y
    dey
    inx
    bne !-
    // *mem = *mula_sqr1_lo
    lda mula_sqr1_lo
    sta mem
    // *mem = *mula_sqr1_hi
    lda mula_sqr1_hi
    sta mem
    // *mem = *mula_sqr2_lo
    lda mula_sqr2_lo
    sta mem
    // *mem = *mula_sqr2_hi
    lda mula_sqr2_hi
    sta mem
    // }
    rts
}
// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
mulf_init: {
    // x/2
    .label c = $12
    // Counter used for determining x%2==0
    .label sqr1_hi = 9
    // Fill mulf_sqr1 = f(x) = int(x*x/4): If f(x) = x*x/4 then f(x+1) = f(x) + x/2 + 1/4
    .label sqr = $e
    .label sqr1_lo = 7
    // Decrease or increase x_255 - initially we decrease
    .label sqr2_hi = $b
    .label sqr2_lo = $10
    //Start with g(0)=f(255)
    .label dir = $d
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
    .label dst = $10
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
  // ASM based multiplication tables
  // <(( x * x )/4)
  .align $100
  mula_sqr1_lo: .fill $200, 0
  // >(( x * x )/4)
  .align $100
  mula_sqr1_hi: .fill $200, 0
  // <((( x - 255) * ( x - 255 ))/4)
  .align $100
  mula_sqr2_lo: .fill $200, 0
  // >((( x - 255) * ( x - 255 ))/4)
  .align $100
  mula_sqr2_hi: .fill $200, 0
  str1: .text "*"
  .byte 0
  str2: .text " slow:"
  .byte 0
  str3: .text " / normal:"
  .byte 0
  str4: .text " / fast:"
  .byte 0
