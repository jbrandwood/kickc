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
  .label print_line_cursor = $400
  // Pointers to a, b and c=a*b
  .label ap = $fd
  .label bp = $fe
  .label cp = $ff
  // mulf_sqr tables will contain f(x)=int(x*x) and g(x) = f(1-x).
  // f(x) = >(( x * x ))
  .label mulf_sqr1 = $2000
  // g(x) =  >((( 1 - x ) * ( 1 - x )))
  .label mulf_sqr2 = $2200
main: {
    .label at = 2
    .label at_3 = 5
    .label j = 7
    .label i = 4
    .label at_line = 2
    .label at_6 = 5
    .label at_12 = 5
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
    lda at
    clc
    adc #4
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
    lda at
    clc
    adc #$28
    sta at
    bcc !+
    inc at+1
  !:
    ldy i
    lda vals,y
    sta print_sbyte_at.b
    lda at
    sta print_sbyte_at.at
    lda at+1
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    lda at
    sta at_12
    lda at+1
    sta at_12+1
    lda #0
    sta j
  b3:
    lda at_3
    clc
    adc #4
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
    lda j
    cmp #9
    bne b3
    inc i
    lda i
    cmp #9
    bne b2
    rts
}
// Print a signed byte as hex at a specific screen position
// print_sbyte_at(signed byte zeropage($a) b, byte* zeropage(8) at)
print_sbyte_at: {
    .label b = $a
    .label at = 8
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
// print_char_at(byte zeropage($b) ch, byte* zeropage(8) at)
print_char_at: {
    .label at = 8
    .label ch = $b
    lda ch
    ldy #0
    sta (at),y
    rts
}
// Print a byte as HEX at a specific position
// print_byte_at(byte* zeropage(8) at)
print_byte_at: {
    .label at = 8
    lda print_sbyte_at.b
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    sta print_char_at.ch
    jsr print_char_at
    lda #$f
    and print_sbyte_at.b
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
    .label COLS = 2
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
    lda COLS
    clc
    adc #$28
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
    .label sc = 2
    lda #<print_line_cursor
    sta sc
    lda #>print_line_cursor
    sta sc+1
  b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda sc+1
    cmp #>print_line_cursor+$3e8
    bne b1
    lda sc
    cmp #<print_line_cursor+$3e8
    bne b1
    rts
}
  print_hextab: .text "0123456789abcdef"
  vals: .byte -$5f, -$40, -$20, -$10, 0, $10, $20, $40, $5f
.pc = mulf_sqr1 "mulf_sqr1"
  .for(var i=0;i<$200;i++) {
    	.if(i<=159) { .byte round((i*i)/256) }
    	.if(i>159 && i<=351 ) { .byte round(((i-256)*(i-256))/256) }
    	.if(i>351) { .byte round(((512-i)*(512-i))/256) }
    }

.pc = mulf_sqr2 "mulf_sqr2"
  .for(var i=0;i<$200;i++) {
    	.if(i<=159) { .byte round((-i-1)*(-i-1)/256) }
    	.if(i>159 && i<=351 ) { .byte round(((255-i)*(255-i))/256) }
    	.if(i>351) { .byte round(((i-511)*(i-511))/256) }  
    }

