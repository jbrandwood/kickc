.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label xr = $f0
  .label yr = $f1
  .label zr = $f2
  .label psp1 = $f3
  .label psp2 = $f5
  .label PERSP_Z = $2400
  .label print_char_cursor = 4
  .label print_line_cursor = 2
main: {
    sei
    jsr mulf_init
    lda #<mulf_sqr1
    sta psp1
    lda #>mulf_sqr1
    sta psp1+1
    lda #<mulf_sqr2
    sta psp2
    lda #>mulf_sqr2
    sta psp2+1
    jsr print_cls
    jsr do_perspective
    rts
}
do_perspective: {
    .label y = -$47
    .label x = $39
    .label z = $36
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    ldx #x
    jsr print_sbyte
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    ldx #y
    jsr print_sbyte
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    ldx #z
    jsr print_sbyte
    lda #<str3
    sta print_str.str
    lda #>str3
    sta print_str.str+1
    jsr print_str
    jsr perspective
    ldx xr
    jsr print_byte
    lda #<str4
    sta print_str.str
    lda #>str4
    sta print_str.str+1
    jsr print_str
    ldx yr
    jsr print_byte
    lda #<str5
    sta print_str.str
    lda #>str5
    sta print_str.str+1
    jsr print_str
    jsr print_ln
    rts
    str: .text "(@"
    str1: .text ",@"
    str2: .text ",@"
    str3: .text ") -> (@"
    str4: .text ",@"
    str5: .text ")@"
}
//  Print a newline
print_ln: {
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
  b1:
    lda print_line_cursor
    clc
    adc #$28
    sta print_line_cursor
    bcc !+
    inc print_line_cursor+1
  !:
    lda print_line_cursor+1
    cmp print_char_cursor+1
    bcc b1
    bne !+
    lda print_line_cursor
    cmp print_char_cursor
    bcc b1
  !:
    rts
}
//  Print a zero-terminated string
print_str: {
    .label str = 2
  b1:
    ldy #0
    lda (str),y
    cmp #'@'
    bne b2
    rts
  b2:
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    inc str
    bne !+
    inc str+1
  !:
    jmp b1
}
//  Print a byte as HEX
print_byte: {
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    jsr print_char
    txa
    and #$f
    tay
    lda print_hextab,y
    jsr print_char
    rts
}
//  Print a single char
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    rts
}
//  Apply perspective to a 3d-point. Result is returned in (*xr,*yr) 
//  Implemented in assembler to utilize seriously fast multiplication 
perspective: {
    lda #do_perspective.x
    sta xr
    lda #do_perspective.y
    sta yr
    lda #do_perspective.z
    sta zr
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
    rts
}
//  Print a signed byte as HEX
print_sbyte: {
    cpx #0
    bmi b1
    lda #' '
    jsr print_char
  b2:
    jsr print_byte
    rts
  b1:
    lda #'-'
    jsr print_char
    txa
    eor #$ff
    clc
    adc #1
    tax
    jmp b2
}
//  Clear the screen. Also resets current line/char cursor.
print_cls: {
    .label sc = 2
    lda #<$400
    sta sc
    lda #>$400
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
    cmp #>$400+$3e8
    bne b1
    lda sc
    cmp #<$400+$3e8
    bne b1
    rts
}
//  Initialize the mulf_sqr multiplication tables with f(x)=int(x*x) and g(x) = f(1-x) 
mulf_init: {
    .label val = 6
    .label sqr = 2
    .label add = 4
    lda #<1
    sta add
    lda #>1
    sta add+1
    tax
    sta sqr
    sta sqr+1
  b1:
    lda sqr+1
    sta val
    sta mulf_sqr1,x
    sta mulf_sqr1+$100,x
    txa
    eor #$ff
    clc
    adc #1
    tay
    lda val
    sta mulf_sqr1,y
    txa
    eor #$ff
    clc
    adc #1
    tay
    lda val
    sta mulf_sqr1+$100,y
    sta mulf_sqr2+1,x
    sta mulf_sqr2+$100+1,x
    txa
    eor #$ff
    clc
    adc #1+1
    tay
    lda val
    sta mulf_sqr2,y
    txa
    eor #$ff
    clc
    adc #1+1
    tay
    lda val
    sta mulf_sqr2+$100,y
    lda sqr
    clc
    adc add
    sta sqr
    lda sqr+1
    adc add+1
    sta sqr+1
    lda add
    clc
    adc #2
    sta add
    bcc !+
    inc add+1
  !:
    inx
    cpx #$81
    bne b1
    rts
}
  print_hextab: .text "0123456789abcdef"
  //  Multiplication tables for seriously fast multiplication. 
  //  This version is optimized for speed over accuracy
  //  - It can multiply signed numbers with no extra code - but only for numbers in [-$3f;$3f]  
  //  - It throws away the low part of the 32-bit result
  //  - It return >a*b*4 to maximize precision (when passed maximal input values $3f*$3f the result is $3e) 
  //  See the following for information about the method
  //  - http://codebase64.org/doku.php?id=base:seriously_fast_multiplication 
  //  - http://codebase64.org/doku.php?id=magazines:chacking16
  //  mulf_sqr tables will contain f(x)=int(x*x) and g(x) = f(1-x).
  //  f(x) = >(( x * x ))
  .align $100
  mulf_sqr1: .fill $200, 0
  //  g(x) =  >((( 1 - x ) * ( 1 - x )))
  .align $100
  mulf_sqr2: .fill $200, 0
.pc = PERSP_Z "PERSP_Z"
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

