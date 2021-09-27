/// @file
/// Simple binary division implementation
///
/// Follows the C99 standard by truncating toward zero on negative results.
/// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
  // Commodore 64 PRG executable file
.file [name="sandbox.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label zp1 = $61
  // #define zp1 *(byte *)0x61 -- allows "zp1" vs "*zp1" below -- not supported --  https://gitlab.com/camelot/kickc/issues/169
  .label zp2 = $62
  .label TIMEHI = $a1
  .label TIMELO = $a2
  .label VICBANK = $d018
.segment Code
main: {
    .label __3 = $17
    .label __10 = $17
    .label __14 = $17
    .label __15 = 4
    .label __16 = $17
    .label __17 = 2
    .label v = $a
    // test performance of 'div16u(10)'
    // test performance of 'div10'
    .label u = $15
    // *VICBANK = 23
    lda #$17
    sta VICBANK
    // *zp1 = 0
    lda #0
    sta zp1
    sta.z v
    sta.z v+1
    lda #<$6e85
    sta.z u
    lda #>$6e85
    sta.z u+1
  __b1:
    // for (*zp1 = 0; *zp1 < 10; ++*zp1)
    lda zp1
    cmp #$a
    bcc __b2
    // *zp1 = 0
    lda #0
    sta zp1
    lda #<$6e85
    sta.z u
    lda #>$6e85
    sta.z u+1
  __b7:
    // for (*zp1 = 0; *zp1 < 10; ++*zp1)
    lda zp1
    cmp #$a
    bcc __b8
    // }
    rts
  __b8:
    // *TIMEHI = 0
    lda #0
    sta TIMEHI
    // *TIMELO = 0
    sta TIMELO
    // *zp2 = 0
    sta zp2
  __b9:
    // for (*zp2 = 0; *zp2 < 200; ++*zp2)
    lda zp2
    cmp #$c8
    bcc __b10
    // (word)*TIMEHI << 8
    lda TIMEHI
    sta.z __16
    lda #0
    sta.z __16+1
    lda.z __10
    sta.z __10+1
    lda #0
    sta.z __10
    // ((word)*TIMEHI << 8) + (word)*TIMELO
    lda TIMELO
    sta.z __17
    lda #0
    sta.z __17+1
    // myprintf(strTemp, "200 DIV10 : %5d,%4d IN %04d FRAMESm", u, v, ((word)*TIMEHI << 8) + (word)*TIMELO)
    clc
    lda.z myprintf.w3
    adc.z __17
    sta.z myprintf.w3
    lda.z myprintf.w3+1
    adc.z __17+1
    sta.z myprintf.w3+1
    lda #<str1
    sta.z myprintf.str
    lda #>str1
    sta.z myprintf.str+1
    jsr myprintf
    // Print()
    jsr Print
    // u -= 1234
    lda.z u
    sec
    sbc #<$4d2
    sta.z u
    lda.z u+1
    sbc #>$4d2
    sta.z u+1
    // for (*zp1 = 0; *zp1 < 10; ++*zp1)
    inc zp1
    jmp __b7
  __b10:
    // div10(u)
    jsr div10
    // v = div10(u)
    // for (*zp2 = 0; *zp2 < 200; ++*zp2)
    inc zp2
    jmp __b9
  __b2:
    // *TIMEHI = 0
    lda #0
    sta TIMEHI
    // *TIMELO = 0
    sta TIMELO
    // *zp2 = 0
    sta zp2
  __b4:
    // for (*zp2 = 0; *zp2 < 200; ++*zp2)
    lda zp2
    cmp #$c8
    bcc __b5
    // (word)*TIMEHI << 8
    lda TIMEHI
    sta.z __14
    lda #0
    sta.z __14+1
    lda.z __3
    sta.z __3+1
    lda #0
    sta.z __3
    // ((word)*TIMEHI << 8) + (word)*TIMELO
    lda TIMELO
    sta.z __15
    lda #0
    sta.z __15+1
    // myprintf(strTemp, "200 DIV16U: %5d,%4d IN %04d FRAMESm", u, v, ((word)*TIMEHI << 8) + (word)*TIMELO)
    clc
    lda.z myprintf.w3
    adc.z __15
    sta.z myprintf.w3
    lda.z myprintf.w3+1
    adc.z __15+1
    sta.z myprintf.w3+1
  // lower case letters in string literal are placed in string as 0x01-0x1A, should be 0x61-0x7A
  // -- as a side-effect of above issue, we can use "m" for carriage return.  The normal way is the escape code "\r" but that is not supported --
    lda #<str
    sta.z myprintf.str
    lda #>str
    sta.z myprintf.str+1
    jsr myprintf
    // Print()
    jsr Print
    // u -= 1234
    lda.z u
    sec
    sbc #<$4d2
    sta.z u
    lda.z u+1
    sbc #>$4d2
    sta.z u+1
    // for (*zp1 = 0; *zp1 < 10; ++*zp1)
    inc zp1
    jmp __b1
  __b5:
    // div16u(u, 10)
    jsr div16u
    // v = div16u(u, 10)
    // for (*zp2 = 0; *zp2 < 200; ++*zp2)
    inc zp2
    jmp __b4
  .segment Data
    str: .text "200 DIV16U: %5d,%4d IN %04d FRAMESm"
    .byte 0
    str1: .text "200 DIV10 : %5d,%4d IN %04d FRAMESm"
    .byte 0
}
.segment Code
// char myprintf(char *dst, __zp(8) char *str, __zp($15) unsigned int w1, __zp($a) unsigned int w2, __zp($17) unsigned int w3)
myprintf: {
    .label str = 8
    .label bDigits = $f
    .label bLen = $e
    // formats
    .label b = $10
    .label bArg = $11
    .label w1 = $15
    .label w2 = $a
    .label w3 = $17
    .label w = $c
    .label bFormat = $12
    .label bTrailing = $14
    .label bLeadZero = $13
    lda #0
    sta.z bLeadZero
    sta.z bDigits
    sta.z bTrailing
    sta.z w
    sta.z w+1
    sta.z bArg
    sta.z bLen
    sta.z bFormat
  __b1:
    // for (; *str != 0; ++str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // dst[bLen] = 0
    tya
    ldy.z bLen
    sta strTemp,y
    // }
    rts
  __b2:
    // b = *str
    ldy #0
    lda (str),y
    tax
    // if (bFormat != 0)
    lda.z bFormat
    bne !__b4+
    jmp __b4
  !__b4:
    // if (b == '0')
    cpx #'0'
    bne __b5
    lda #1
    sta.z bLeadZero
  __b32:
    // for (; *str != 0; ++str)
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
  __b5:
    // if (b >= '1' && b <= '9')
    cpx #'1'
    bcc __b6
    cpx #'9'
    bcs !__b28+
    jmp __b28
  !__b28:
    bne !__b28+
    jmp __b28
  !__b28:
  __b6:
    // if (b == '-')
    cpx #'-'
    bne __b7
    lda #1
    sta.z bTrailing
    jmp __b32
  __b7:
    // if (b == 'c')
    cpx #'c'
    bne !__b8+
    jmp __b8
  !__b8:
    // if (b == 'd')
    cpx #'d'
    beq __b9
    // if (b == 'x' || b == 'X')
    cpx #'x'
    beq __b31
    cpx #'X'
    beq __b31
  __b3:
    lda #0
    sta.z bFormat
    jmp __b32
  __b31:
    // (byte)w >> 4
    lda.z w
    lsr
    lsr
    lsr
    lsr
    // b = ((byte)w >> 4) & 0xF
    ldx #$f
    axs #0
    // b < 10 ? '0' : 0x57
    cpx #$a
    bcc __b10
    lda #$57
    jmp __b11
  __b10:
    // b < 10 ? '0' : 0x57
    lda #'0'
  __b11:
    // (b < 10 ? '0' : 0x57) + b
    stx.z $ff
    clc
    adc.z $ff
    // dst[bLen++] = (b < 10 ? '0' : 0x57) + b
    ldy.z bLen
    sta strTemp,y
    // dst[bLen++] = (b < 10 ? '0' : 0x57) + b;
    iny
    // (byte)w & 0xF
    lda.z w
    // b = (byte)w & 0xF
    ldx #$f
    axs #0
    // b < 10 ? '0' : 0x57
    cpx #$a
    bcc __b12
    lda #$57
    jmp __b13
  __b12:
    // b < 10 ? '0' : 0x57
    lda #'0'
  __b13:
    // (b < 10 ? '0' : 0x57) + b
    stx.z $ff
    clc
    adc.z $ff
    // dst[bLen++] = (b < 10 ? '0' : 0x57) + b
    sta strTemp,y
    // dst[bLen++] = (b < 10 ? '0' : 0x57) + b;
    iny
    sty.z bLen
    jmp __b3
  __b9:
    // utoa(w, buf6)
    lda.z w
    sta.z utoa.value
    lda.z w+1
    sta.z utoa.value+1
    jsr utoa
    lda #1
    sta.z b
  __b14:
    // while(buf6[b] != 0)
    ldy.z b
    lda buf6,y
    cmp #0
    bne __b15
    // if (bTrailing == 0 && bDigits > b)
    lda.z bTrailing
    bne __b17
    tya
    cmp.z bDigits
    bcs __b17
  __b18:
    // for (; bDigits > b; --bDigits)
    lda.z b
    cmp.z bDigits
    bcc __b19
  __b17:
    ldx #0
  __b22:
    // for (digit = 0; digit < b; ++digit)
    cpx.z b
    bcc __b23
    // if (bTrailing != 0 && bDigits > b)
    lda.z bTrailing
    beq __b3
    lda.z b
    cmp.z bDigits
    bcs __b3
  __b25:
    // for (; bDigits > b; --bDigits)
    lda.z b
    cmp.z bDigits
    bcc __b26
    jmp __b3
  __b26:
    // dst[bLen++] = ' '
    lda #' '
    ldy.z bLen
    sta strTemp,y
    // dst[bLen++] = ' ';
    inc.z bLen
    // for (; bDigits > b; --bDigits)
    dec.z bDigits
    jmp __b25
  __b23:
    // dst[bLen++] = buf6[digit]
    lda buf6,x
    ldy.z bLen
    sta strTemp,y
    // dst[bLen++] = buf6[digit];
    inc.z bLen
    // for (digit = 0; digit < b; ++digit)
    inx
    jmp __b22
  __b19:
    // (bLeadZero == 0) ? ' ' : '0'
    lda.z bLeadZero
    beq __b20
    lda #'0'
    jmp __b21
  __b20:
    // (bLeadZero == 0) ? ' ' : '0'
    lda #' '
  __b21:
    // dst[bLen++] = (bLeadZero == 0) ? ' ' : '0'
    ldy.z bLen
    sta strTemp,y
    // dst[bLen++] = (bLeadZero == 0) ? ' ' : '0';
    inc.z bLen
    // for (; bDigits > b; --bDigits)
    dec.z bDigits
    jmp __b18
  __b15:
    // ++b;
    inc.z b
    jmp __b14
  __b8:
    // dst[bLen++] = (byte)w
    // "switch" is the normal way -- not supported -- https://gitlab.com/camelot/kickc/issues/170
    ldy.z bLen
    lda.z w
    sta strTemp,y
    // dst[bLen++] = (byte)w;
    inc.z bLen
    jmp __b3
  __b28:
    // bDigits = b - '0'
    txa
    axs #'0'
    stx.z bDigits
    jmp __b32
  __b4:
    // if (b == '%')
    cpx #'%'
    bne __b33
    // if (bArg == 0)
    // default format
    //w = (bArg == 0) ? w1 : ((bArg == 1) ? w2 : w3); -- "?" is the normal way, but error "sequence does not contain all blocks" -- https://gitlab.com/camelot/kickc/issues/185 [FIXED]
    lda.z bArg
    beq __b34
    // if (bArg == 1)
    lda #1
    cmp.z bArg
    beq __b35
    lda.z w3
    sta.z w
    lda.z w3+1
    sta.z w+1
  __b36:
    // ++bArg;
    inc.z bArg
    lda #0
    sta.z bLeadZero
    lda #1
    sta.z bDigits
    lda #0
    sta.z bTrailing
    lda #1
    sta.z bFormat
    jmp __b32
  __b35:
    lda.z w2
    sta.z w
    lda.z w2+1
    sta.z w+1
    jmp __b36
  __b34:
    lda.z w1
    sta.z w
    lda.z w1+1
    sta.z w+1
    jmp __b36
  __b33:
    // if (b >= 0x41 && b <= 0x5A)
    cpx #$41
    bcc __b37
    cpx #$5a+1
    bcs __b37
    // b += 0x20
    txa
    axs #-[$20]
  __b37:
    // dst[bLen++] = b
    // swap 0x41 / 0x61 when in lower case mode
    ldy.z bLen
    txa
    sta strTemp,y
    // dst[bLen++] = b;
    inc.z bLen
    jmp __b32
  .segment Data
    buf6: .fill 6, 0
}
.segment Code
Print: {
    // asm
    // can this assembly be placed in a separate file and call it from the C code here?
    ldy #0
  loop:
    lda strTemp,y
    beq done
    jsr $ffd2
    iny
    jmp loop
  done:
    // }
    rts
}
// __zp($a) unsigned int div10(__zp(6) unsigned int val)
div10: {
    .label __0 = 6
    .label __2 = 8
    .label __3 = $c
    .label __4 = $a
    .label val = 6
    .label val_1 = 8
    .label val_2 = $c
    .label val_3 = $a
    .label return = $a
    .label val_4 = $15
    // val >> 1
    lda.z val_4+1
    lsr
    sta.z __0+1
    lda.z val_4
    ror
    sta.z __0
    // val = (val >> 1) + 1
    inc.z val
    bne !+
    inc.z val+1
  !:
    // val << 1
    lda.z val
    asl
    sta.z __2
    lda.z val+1
    rol
    sta.z __2+1
    // val += val << 1
    clc
    lda.z val_1
    adc.z val
    sta.z val_1
    lda.z val_1+1
    adc.z val+1
    sta.z val_1+1
    // val >> 4
    lsr
    sta.z __3+1
    lda.z val_1
    ror
    sta.z __3
    lsr.z __3+1
    ror.z __3
    lsr.z __3+1
    ror.z __3
    lsr.z __3+1
    ror.z __3
    // val += val >> 4
    clc
    lda.z val_2
    adc.z val_1
    sta.z val_2
    lda.z val_2+1
    adc.z val_1+1
    sta.z val_2+1
    // val >> 8
    sta.z __4
    lda #0
    sta.z __4+1
    // val += val >> 8
    clc
    lda.z val_3
    adc.z val_2
    sta.z val_3
    lda.z val_3+1
    adc.z val_2+1
    sta.z val_3+1
    // val >> 4
    lsr.z return+1
    ror.z return
    lsr.z return+1
    ror.z return
    lsr.z return+1
    ror.z return
    lsr.z return+1
    ror.z return
    // }
    rts
}
// Performs division on two 16 bit unsigned ints
// Returns the quotient dividend/divisor.
// The remainder will be set into the global variable rem16u
// Implemented using simple binary division
// __zp($a) unsigned int div16u(__zp($15) unsigned int dividend, unsigned int divisor)
div16u: {
    .label divisor = $a
    .label return = $a
    .label dividend = $15
    // divr16u(dividend, divisor, 0)
    lda.z dividend
    sta.z divr16u.dividend
    lda.z dividend+1
    sta.z divr16u.dividend+1
    jsr divr16u
    // divr16u(dividend, divisor, 0)
    // }
    rts
}
// void utoa(__zp(2) unsigned int value, __zp(4) char *dst)
utoa: {
    .label value = 2
    .label dst = 4
    // if (bStarted == 1 || value >= 10000)
    lda.z value+1
    cmp #>$2710
    bcc !+
    beq !__b5+
    jmp __b5
  !__b5:
    lda.z value
    cmp #<$2710
    bcc !__b5+
    jmp __b5
  !__b5:
  !:
    lda #<myprintf.buf6
    sta.z dst
    lda #>myprintf.buf6
    sta.z dst+1
    ldx #0
  __b1:
    // if (bStarted == 1 || value >= 1000)
    cpx #1
    beq __b6
    lda.z value+1
    cmp #>$3e8
    bcc !+
    bne __b6
    lda.z value
    cmp #<$3e8
    bcs __b6
  !:
  __b2:
    // if (bStarted == 1 || value >= 100)
    cpx #1
    beq __b7
    lda.z value+1
    bne __b7
    lda.z value
    cmp #$64
    bcs __b7
  !:
  __b3:
    // if (bStarted == 1 || value >= 10)
    cpx #1
    beq __b8
    lda.z value+1
    bne __b8
    lda.z value
    cmp #$a
    bcs __b8
  !:
  __b4:
    // '0' + (byte)value
    lda.z value
    clc
    adc #'0'
    // *dst++ = '0' + (byte)value
    ldy #0
    sta (dst),y
    // *dst++ = '0' + (byte)value;
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // *dst = 0
    lda #0
    tay
    sta (dst),y
    // }
    rts
  __b8:
    // append(dst++, value, 10)
    lda #<$a
    sta.z append.sub
    lda #>$a
    sta.z append.sub+1
    jsr append
    // append(dst++, value, 10)
    // value = append(dst++, value, 10)
    // value = append(dst++, value, 10);
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b4
  __b7:
    // append(dst++, value, 100)
    lda #<$64
    sta.z append.sub
    lda #>$64
    sta.z append.sub+1
    jsr append
    // append(dst++, value, 100)
    // value = append(dst++, value, 100)
    // value = append(dst++, value, 100);
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    ldx #1
    jmp __b3
  __b6:
    // append(dst++, value, 1000)
    lda #<$3e8
    sta.z append.sub
    lda #>$3e8
    sta.z append.sub+1
    jsr append
    // append(dst++, value, 1000)
    // value = append(dst++, value, 1000)
    // value = append(dst++, value, 1000);
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    ldx #1
    jmp __b2
  __b5:
    // append(dst++, value, 10000)
    lda #<$2710
    sta.z append.sub
    lda #>$2710
    sta.z append.sub+1
    lda #<myprintf.buf6
    sta.z append.dst
    lda #>myprintf.buf6
    sta.z append.dst+1
    jsr append
    // append(dst++, value, 10000)
    // value = append(dst++, value, 10000)
    lda #<myprintf.buf6+1
    sta.z dst
    lda #>myprintf.buf6+1
    sta.z dst+1
    ldx #1
    jmp __b1
}
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// __zp($a) unsigned int divr16u(__zp($c) unsigned int dividend, unsigned int divisor, __zp(8) unsigned int rem)
divr16u: {
    .label rem = 8
    .label dividend = $c
    .label quotient = $a
    .label return = $a
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
    sta.z rem
    sta.z rem+1
  __b1:
    // rem = rem << 1
    asl.z rem
    rol.z rem+1
    // BYTE1(dividend)
    lda.z dividend+1
    // BYTE1(dividend) & $80
    and #$80
    // if( (BYTE1(dividend) & $80) != 0 )
    cmp #0
    beq __b2
    // rem = rem | 1
    lda #1
    ora.z rem
    sta.z rem
  __b2:
    // dividend = dividend << 1
    asl.z dividend
    rol.z dividend+1
    // quotient = quotient << 1
    asl.z quotient
    rol.z quotient+1
    // if(rem>=divisor)
    lda.z rem+1
    cmp #>div16u.divisor
    bcc __b3
    bne !+
    lda.z rem
    cmp #<div16u.divisor
    bcc __b3
  !:
    // quotient++;
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    // rem = rem - divisor
    lda.z rem
    sec
    sbc #<div16u.divisor
    sta.z rem
    lda.z rem+1
    sbc #>div16u.divisor
    sta.z rem+1
  __b3:
    // for( char i : 0..15)
    inx
    cpx #$10
    bne __b1
    // }
    rts
}
// simple 'utoa' without using multiply or divide
// __zp(2) unsigned int append(__zp(4) char *dst, __zp(2) unsigned int value, __zp(6) unsigned int sub)
append: {
    .label value = 2
    .label return = 2
    .label dst = 4
    .label sub = 6
    // *dst = '0'
    lda #'0'
    ldy #0
    sta (dst),y
  __b1:
    // while (value >= sub)
    lda.z sub+1
    cmp.z value+1
    bne !+
    lda.z sub
    cmp.z value
    beq __b2
  !:
    bcc __b2
    // }
    rts
  __b2:
    // ++*dst;
    ldy #0
    lda (dst),y
    clc
    adc #1
    sta (dst),y
    // value -= sub
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    jmp __b1
}
.segment Data
  // "char buf16[16]" is the normal way -- not supported -- https://gitlab.com/camelot/kickc/issues/162
  strTemp: .fill $64, 0
