// Seriously fast multiply 8-bit version (8bit*8bit=8bit)
// Multiplies two signed 8-bit numbers and results in an 8-bit number
// C=A*B, A in [-64;64], B in [-96;95], C in [-96;95] - 64 acts a 1 (X*64=X)
// Uses the formula a*b = (a+b)^2/4 - (a-b)^2/4
// See the following for information about the method
// - http://codebase64.org/doku.php?id=base:seriously_fast_multiplication 
// - http://codebase64.org/doku.php?id=magazines:chacking16
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // Pointers to a, b and c=a*b
  .label ap = $fd
  .label bp = $fe
  .label cp = $ff
  .label print_screen = $400
main: {
    .label at = $a
    .label at_1 = $c
    .label at_2 = 3
    .label j = 5
    .label i = 2
    .label at_line = $c
    // init_screen()
    jsr init_screen
    lda #<$400+4
    sta.z at
    lda #>$400+4
    sta.z at+1
    ldx #0
  __b1:
    // print_sbyte_at(vals[k], at)
    lda vals,x
    sta.z print_sbyte_at.b
    lda.z at
    sta.z print_sbyte_at.at
    lda.z at+1
    sta.z print_sbyte_at.at+1
    jsr print_sbyte_at
    // at += 4
    lda #4
    clc
    adc.z at
    sta.z at
    bcc !+
    inc.z at+1
  !:
    // for(byte k: 0..8)
    inx
    cpx #9
    bne __b1
    lda #0
    sta.z i
    lda #<$400
    sta.z at_line
    lda #>$400
    sta.z at_line+1
  __b2:
    // at_line +=40
    lda #$28
    clc
    adc.z at_1
    sta.z at_1
    bcc !+
    inc.z at_1+1
  !:
    // print_sbyte_at(vals[i], at)
    ldy.z i
    lda vals,y
    sta.z print_sbyte_at.b
    lda.z at_1
    sta.z print_sbyte_at.at
    lda.z at_1+1
    sta.z print_sbyte_at.at+1
    jsr print_sbyte_at
    lda.z at_1
    sta.z at_2
    lda.z at_1+1
    sta.z at_2+1
    lda #0
    sta.z j
  __b3:
    // at += 4
    lda #4
    clc
    adc.z at_2
    sta.z at_2
    bcc !+
    inc.z at_2+1
  !:
    // fmul8(vals[i], vals[j])
    ldy.z i
    lda vals,y
    ldy.z j
    ldx vals,y
    jsr fmul8
    // r = fmul8(vals[i], vals[j])
    // print_sbyte_at(r, at)
    sta.z print_sbyte_at.b
    lda.z at_2
    sta.z print_sbyte_at.at
    lda.z at_2+1
    sta.z print_sbyte_at.at+1
    jsr print_sbyte_at
    // for(byte j: 0..8)
    inc.z j
    lda #9
    cmp.z j
    bne __b3
    // for(byte i: 0..8)
    inc.z i
    cmp.z i
    bne __b2
    // }
    rts
}
// Print a signed byte as hex at a specific screen position
// print_sbyte_at(signed byte zp(8) b, byte* zp(6) at)
print_sbyte_at: {
    .label b = 8
    .label at = 6
    // if(b<0)
    lda.z b
    bmi __b1
    // print_char_at(' ', at)
    lda #' '
    sta.z print_char_at.ch
    jsr print_char_at
  __b2:
    // print_byte_at((byte)b, at+1)
    inc.z print_byte_at.at
    bne !+
    inc.z print_byte_at.at+1
  !:
    jsr print_byte_at
    // }
    rts
  __b1:
    // print_char_at('-', at)
    lda #'-'
    sta.z print_char_at.ch
    jsr print_char_at
    // b = -b
    lda.z b
    eor #$ff
    clc
    adc #1
    sta.z b
    jmp __b2
}
// Print a single char
// print_char_at(byte zp(9) ch, byte* zp(6) at)
print_char_at: {
    .label at = 6
    .label ch = 9
    // *(at) = ch
    lda.z ch
    ldy #0
    sta (at),y
    // }
    rts
}
// Print a byte as HEX at a specific position
// print_byte_at(byte zp(8) b, byte* zp(6) at)
print_byte_at: {
    .label b = 8
    .label at = 6
    // b>>4
    lda.z b
    lsr
    lsr
    lsr
    lsr
    // print_char_at(print_hextab[b>>4], at)
    tay
    lda print_hextab,y
    sta.z print_char_at.ch
    jsr print_char_at
    // b&$f
    lda #$f
    and.z b
    tay
    // print_char_at(print_hextab[b&$f], at+1)
    inc.z print_char_at.at
    bne !+
    inc.z print_char_at.at+1
  !:
    lda print_hextab,y
    sta.z print_char_at.ch
    jsr print_char_at
    // }
    rts
}
// fmul8(signed byte register(A) a, signed byte register(X) b)
fmul8: {
    // *ap = a
    sta ap
    // *bp = b
    txa
    sta bp
    // asm
    lda ap
    sta A1+1
    eor #$ff
    sta A2+1
    ldx bp
    sec
  A1:
    lda mulf_sqr1,x
  A2:
    sbc mulf_sqr2,x
    sta cp
    // return *cp;
    // }
    rts
}
init_screen: {
    .const WHITE = 1
    .label COLS = $a
    // print_cls()
    jsr print_cls
    ldx #0
  __b1:
    // COLS[l] = WHITE
    lda #WHITE
    sta $d800,x
    // for(byte l: 0..39)
    inx
    cpx #$28
    bne __b1
    ldx #0
    lda #<$d800
    sta.z COLS
    lda #>$d800
    sta.z COLS+1
  __b2:
    // COLS[0] = WHITE
    lda #WHITE
    ldy #0
    sta (COLS),y
    // COLS[1] = WHITE
    ldy #1
    sta (COLS),y
    // COLS[2] = WHITE
    ldy #2
    sta (COLS),y
    // COLS[3] = WHITE
    ldy #3
    sta (COLS),y
    // COLS += 40
    lda #$28
    clc
    adc.z COLS
    sta.z COLS
    bcc !+
    inc.z COLS+1
  !:
    // for(byte m: 0..24)
    inx
    cpx #$19
    bne __b2
    // }
    rts
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
    .label str = print_screen
    .label end = str+num
    .label dst = $c
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
  vals: .byte -$5f, -$40, -$20, -$10, 0, $10, $20, $40, $5f
  // mulf_sqr tables will contain f(x)=int(x*x) and g(x) = f(1-x).
  // f(x) = >(( x * x ))
  .align $100
mulf_sqr1:
.for(var i=0;i<$200;i++) {
    	.if(i<=159) { .byte round((i*i)/256) }
    	.if(i>159 && i<=351 ) { .byte round(((i-256)*(i-256))/256) }
    	.if(i>351) { .byte round(((512-i)*(512-i))/256) }
    }

  // g(x) =  >((( 1 - x ) * ( 1 - x )))
  .align $100
mulf_sqr2:
.for(var i=0;i<$200;i++) {
    	.if(i<=159) { .byte round((-i-1)*(-i-1)/256) }
    	.if(i>159 && i<=351 ) { .byte round(((255-i)*(255-i))/256) }
    	.if(i>351) { .byte round(((i-511)*(i-511))/256) }  
    }

