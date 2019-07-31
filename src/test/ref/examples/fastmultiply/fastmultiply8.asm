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
  .label print_screen = $400
  // Pointers to a, b and c=a*b
  .label ap = $fd
  .label bp = $fe
  .label cp = $ff
main: {
    .label at = $a
    .label at_2 = $c
    .label at_3 = 3
    .label j = 5
    .label i = 2
    .label at_line = $c
    .label at_6 = 3
    .label at_12 = 3
    jsr init_screen
    lda #<$400+4
    sta at
    lda #>$400+4
    sta at+1
    ldx #0
  b1:
    lda vals,x
    sta print_sbyte_at.b
    lda at
    sta print_sbyte_at.at
    lda at+1
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    lda #4
    clc
    adc at
    sta at
    bcc !+
    inc at+1
  !:
    inx
    cpx #9
    bne b1
    lda #0
    sta i
    lda #<$400
    sta at_line
    lda #>$400
    sta at_line+1
  b2:
    lda #$28
    clc
    adc at_2
    sta at_2
    bcc !+
    inc at_2+1
  !:
    ldy i
    lda vals,y
    sta print_sbyte_at.b
    lda at_2
    sta print_sbyte_at.at
    lda at_2+1
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    lda at_2
    sta at_12
    lda at_2+1
    sta at_12+1
    lda #0
    sta j
  b3:
    lda #4
    clc
    adc at_3
    sta at_3
    bcc !+
    inc at_3+1
  !:
    ldy i
    lda vals,y
    ldy j
    ldx vals,y
    jsr fmul8
    sta print_sbyte_at.b
    lda at_3
    sta print_sbyte_at.at
    lda at_3+1
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    inc j
    lda #9
    cmp j
    bne b3
    inc i
    cmp i
    bne b2
    rts
}
// Print a signed byte as hex at a specific screen position
// print_sbyte_at(signed byte zeropage(8) b, byte* zeropage(6) at)
print_sbyte_at: {
    .label b = 8
    .label at = 6
    lda b
    bmi b1
    lda #' '
    sta print_char_at.ch
    jsr print_char_at
  b2:
    inc print_byte_at.at
    bne !+
    inc print_byte_at.at+1
  !:
    jsr print_byte_at
    rts
  b1:
    lda #'-'
    sta print_char_at.ch
    jsr print_char_at
    lda b
    eor #$ff
    clc
    adc #1
    sta b
    jmp b2
}
// Print a single char
// print_char_at(byte zeropage(9) ch, byte* zeropage(6) at)
print_char_at: {
    .label at = 6
    .label ch = 9
    lda ch
    ldy #0
    sta (at),y
    rts
}
// Print a byte as HEX at a specific position
// print_byte_at(byte zeropage(8) b, byte* zeropage(6) at)
print_byte_at: {
    .label b = 8
    .label at = 6
    lda b
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    sta print_char_at.ch
    jsr print_char_at
    lda #$f
    and b
    tay
    inc print_char_at.at
    bne !+
    inc print_char_at.at+1
  !:
    lda print_hextab,y
    sta print_char_at.ch
    jsr print_char_at
    rts
}
// fmul8(signed byte register(A) a, signed byte register(X) b)
fmul8: {
    sta ap
    txa
    sta bp
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
    rts
}
init_screen: {
    .const WHITE = 1
    .label COLS = $a
    jsr print_cls
    ldx #0
  b1:
    lda #WHITE
    sta $d800,x
    inx
    cpx #$28
    bne b1
    ldx #0
    lda #<$d800
    sta COLS
    lda #>$d800
    sta COLS+1
  b2:
    lda #WHITE
    ldy #0
    sta (COLS),y
    ldy #1
    sta (COLS),y
    ldy #2
    sta (COLS),y
    ldy #3
    sta (COLS),y
    lda #$28
    clc
    adc COLS
    sta COLS
    bcc !+
    inc COLS+1
  !:
    inx
    cpx #$19
    bne b2
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    jsr memset
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
    sta dst
    lda #>str
    sta dst+1
  b1:
    lda #c
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp #>end
    bne b1
    lda dst
    cmp #<end
    bne b1
    rts
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

