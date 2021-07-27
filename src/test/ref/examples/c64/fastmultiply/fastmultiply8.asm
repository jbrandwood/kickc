// Seriously fast multiply 8-bit version (8bit*8bit=8bit)
// Multiplies two signed 8-bit numbers and results in an 8-bit number
// C=A*B, A in [-64;64], B in [-96;95], C in [-96;95] - 64 acts a 1 (X*64=X)
// Uses the formula a*b = (a+b)^2/4 - (a-b)^2/4
// See the following for information about the method
// - http://codebase64.org/doku.php?id=base:seriously_fast_multiplication 
// - http://codebase64.org/doku.php?id=magazines:chacking16
  // Commodore 64 PRG executable file
.file [name="fastmultiply8.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label print_screen = $400
.segment Code
main: {
    .label at = 3
    .label k = 2
    .label at_1 = 5
    .label at_2 = 8
    .label j = $a
    .label i = 7
    .label at_line = 5
    // init_screen()
    jsr init_screen
    lda #<$400+4
    sta.z at
    lda #>$400+4
    sta.z at+1
    lda #0
    sta.z k
  __b1:
    // print_schar_at(vals[k], at)
    ldy.z k
    lda vals,y
    sta.z print_schar_at.b
    lda.z at
    sta.z print_schar_at.at
    lda.z at+1
    sta.z print_schar_at.at+1
    jsr print_schar_at
    // at += 4
    lda #4
    clc
    adc.z at
    sta.z at
    bcc !+
    inc.z at+1
  !:
    // for(char k: 0..8)
    inc.z k
    lda #9
    cmp.z k
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
    // print_schar_at(vals[i], at)
    ldy.z i
    lda vals,y
    sta.z print_schar_at.b
    lda.z at_1
    sta.z print_schar_at.at
    lda.z at_1+1
    sta.z print_schar_at.at+1
    jsr print_schar_at
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
    // signed char r = fmul8(vals[i], vals[j])
    ldy.z i
    lda vals,y
    sta.z fmul8.aa
    ldy.z j
    lda vals,y
    sta.z fmul8.bb
    jsr fmul8
    // print_schar_at(r, at)
    sta.z print_schar_at.b
    lda.z at_2
    sta.z print_schar_at.at
    lda.z at_2+1
    sta.z print_schar_at.at+1
    jsr print_schar_at
    // for(char j: 0..8)
    inc.z j
    lda #9
    cmp.z j
    bne __b3
    // for(char i: 0..8)
    inc.z i
    cmp.z i
    bne __b2
    // }
    rts
}
init_screen: {
    .const WHITE = 1
    .label COLS = $b
    // print_cls()
    jsr print_cls
    ldx #0
  __b1:
    // COLS[l] = WHITE
    lda #WHITE
    sta $d800,x
    // for(char l: 0..39)
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
    // for(char m: 0..24)
    inx
    cpx #$19
    bne __b2
    // }
    rts
}
// Print a signed char as hex at a specific screen position
// print_schar_at(signed byte zp($d) b, byte* zp($b) at)
print_schar_at: {
    .label b = $d
    .label at = $b
    // if(b<0)
    lda.z b
    bmi __b1
    // print_char_at(' ', at)
    ldx #' '
    jsr print_char_at
  __b2:
    // print_uchar_at((char)b, at+1)
    inc.z print_uchar_at.at
    bne !+
    inc.z print_uchar_at.at+1
  !:
    jsr print_uchar_at
    // }
    rts
  __b1:
    // print_char_at('-', at)
    ldx #'-'
    jsr print_char_at
    // b = -b
    lda.z b
    eor #$ff
    clc
    adc #1
    sta.z b
    jmp __b2
}
// fmul8(signed byte zp($10) aa, signed byte zp($11) bb)
fmul8: {
    .label aa = $10
    .label bb = $11
    .label cc = $12
    // signed char cc
    lda #0
    sta.z cc
    // asm
    lda aa
    sta A1+1
    eor #$ff
    sta A2+1
    ldx bb
    sec
  A1:
    lda mulf_sqr1,x
  A2:
    sbc mulf_sqr2,x
    sta cc
    // return cc;
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
// Print a single char
// print_char_at(byte register(X) ch, byte* zp($b) at)
print_char_at: {
    .label at = $b
    // *(at) = ch
    txa
    ldy #0
    sta (at),y
    // }
    rts
}
// Print a char as HEX at a specific position
// print_uchar_at(byte zp($d) b, byte* zp($b) at)
print_uchar_at: {
    .label b = $d
    .label at = $b
    // b>>4
    lda.z b
    lsr
    lsr
    lsr
    lsr
    // print_char_at(print_hextab[b>>4], at)
    tay
    ldx print_hextab,y
  // Table of hexadecimal digits
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
    ldx print_hextab,y
    jsr print_char_at
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = $e
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
.segment Data
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

