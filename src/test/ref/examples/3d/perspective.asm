// 3D Rotation using a Rotation Matrix
// Based on: 
// - C= Hacking Magazine Issue 8. http://www.ffd2.com/fridge/chacking/c=hacking8.txt
// - Codebase64 Article http://codebase64.org/doku.php?id=base:3d_rotation  
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The rotated point - updated by calling rotate()
  .label xr = $f0
  .label yr = $f1
  .label zr = $f2
  // Pointers used to multiply perspective (d/z0-z) onto x- & y-coordinates. Points into mulf_sqr1 / mulf_sqr2.  
  .label psp1 = $f3
  .label psp2 = $f5
  .label print_char_cursor = 4
  .label print_line_cursor = 2
main: {
    // asm
    sei
    // mulf_init()
    jsr mulf_init
    // *psp1 = (unsigned int)mulf_sqr1
    lda #<mulf_sqr1
    sta psp1
    lda #>mulf_sqr1
    sta psp1+1
    // *psp2 = (unsigned int)mulf_sqr2
    lda #<mulf_sqr2
    sta psp2
    lda #>mulf_sqr2
    sta psp2+1
    // print_cls()
    jsr print_cls
    // do_perspective($39, -$47, $36)
    jsr do_perspective
    // }
    rts
}
do_perspective: {
    .label x = $39
    .label y = -$47
    .label z = $36
    // print_str("(")
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_s8(x)
    ldx #x
    jsr print_s8
    // print_str(",")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_s8(y)
    ldx #y
    jsr print_s8
    // print_str(",")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_s8(z)
    ldx #z
    jsr print_s8
    // print_str(") -> (")
    lda #<str3
    sta.z print_str.str
    lda #>str3
    sta.z print_str.str+1
    jsr print_str
    // perspective(x, y, z)
    jsr perspective
    ldx xr
    // print_u8((byte)*xr)
    jsr print_u8
    // print_str(",")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    ldx yr
    // print_u8((byte)*yr)
    jsr print_u8
    // print_str(")")
    lda #<str5
    sta.z print_str.str
    lda #>str5
    sta.z print_str.str+1
    jsr print_str
    // print_ln()
    jsr print_ln
    // }
    rts
    str: .text "("
    .byte 0
    str1: .text ","
    .byte 0
    str3: .text ") -> ("
    .byte 0
    str5: .text ")"
    .byte 0
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
// Print a zero-terminated string
// print_str(byte* zp(6) str)
print_str: {
    .label str = 6
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
// Apply perspective to a 3d-point. Result is returned in (*xr,*yr) 
// Implemented in assembler to utilize seriously fast multiplication 
perspective: {
    // *xr = x
    lda #do_perspective.x
    sta xr
    // *yr = y
    lda #do_perspective.y
    sta yr
    // *zr = z
    lda #do_perspective.z
    sta zr
    // asm
    sta PP+1
  PP:
    lda PERSP_Z
    sta psp1
    eor #$ff
    sta psp2
    clc
    ldy yr
    lda (psp1),y
    sbc (psp2),y
    adc #$80
    sta yr
    clc
    ldy xr
    lda (psp1),y
    sbc (psp2),y
    adc #$80
    sta xr
    // }
    rts
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
    .label dst = 6
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
// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x) and g(x) = f(1-x) 
mulf_init: {
    .label val = $a
    .label sqr = 6
    .label add = 8
    lda #<1
    sta.z add
    lda #>1
    sta.z add+1
    tay
    sta.z sqr
    sta.z sqr+1
  __b1:
    // val = >sqr
    lda.z sqr+1
    sta.z val
    // mulf_sqr1[i] = val
    sta mulf_sqr1,y
    // (mulf_sqr1+$100)[i] = val
    sta mulf_sqr1+$100,y
    // -i
    tya
    eor #$ff
    tax
    inx
    // mulf_sqr1[-i] = val
    lda.z val
    sta mulf_sqr1,x
    // (mulf_sqr1+$100)[-i] = val
    sta mulf_sqr1+$100,x
    // mulf_sqr2[i+1] = val
    sta mulf_sqr2+1,y
    // (mulf_sqr2+$100)[i+1] = val
    sta mulf_sqr2+$100+1,y
    // 1-i
    tya
    eor #$ff
    tax
    axs #-1-1
    // mulf_sqr2[1-i] = val
    lda.z val
    sta mulf_sqr2,x
    // 1-i
    tya
    eor #$ff
    tax
    axs #-1-1
    // (mulf_sqr2+$100)[1-i] = val
    lda.z val
    sta mulf_sqr2+$100,x
    // sqr += add
    lda.z sqr
    clc
    adc.z add
    sta.z sqr
    lda.z sqr+1
    adc.z add+1
    sta.z sqr+1
    // add +=2
    lda.z add
    clc
    adc #<2
    sta.z add
    lda.z add+1
    adc #>2
    sta.z add+1
    // for( char i:0..128)
    iny
    cpy #$81
    bne __b1
    // }
    rts
}
  print_hextab: .text "0123456789abcdef"
  // Multiplication tables for seriously fast multiplication. 
  // This version is optimized for speed over accuracy
  // - It can multiply signed numbers with no extra code - but only for numbers in [-$3f;$3f]  
  // - It throws away the low part of the 32-bit result
  // - It return >a*b*4 to maximize precision (when passed maximal input values $3f*$3f the result is $3e) 
  // See the following for information about the method
  // - http://codebase64.org/doku.php?id=base:seriously_fast_multiplication 
  // - http://codebase64.org/doku.php?id=magazines:chacking16
  // mulf_sqr tables will contain f(x)=int(x*x) and g(x) = f(1-x).
  // f(x) = >(( x * x ))
  .align $100
  mulf_sqr1: .fill $200, 0
  // g(x) =  >((( 1 - x ) * ( 1 - x )))
  .align $100
  mulf_sqr2: .fill $200, 0
  // Perspective multiplication table containing (d/(z0-z)[z] for each z-value   
  .align $100
PERSP_Z:
{
    .var d = 256.0	
    .var z0 = 5.0	
    .for(var z=0;z<$100;z++) {
    	.if(z>127) {
    		.byte round(d / (z0 - ((z - 256) / 64.0)));
    	} else {
    		.byte round(d / (z0 - (z / 64.0)));
    	}
    }
	}

