// Test the fast multiplication library
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
  .label print_char_cursor = 6
  .label print_line_cursor = 2
main: {
    lda #5
    sta BGCOL
    jsr print_cls
    jsr mulf_init
    jsr mulf_init_asm
    jsr mulf_tables_cmp
    jsr mul8u_compare
    jsr mul8s_compare
    rts
}
// Perform all possible signed byte multiplications (slow and fast) and compare the results
mul8s_compare: {
    .label ms = 4
    .label mf = $a
    .label mn = 8
    .label a = $c
    .label b = $f
    lda #-$80
    sta a
  b1:
    lda #-$80
    cmp a
    bne b2
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    jsr print_ln
    rts
  b2:
    lda #-$80
    sta b
  b3:
    lda #-$80
    cmp b
    bne b4
    inc a
    jmp b1
  b4:
    ldx b
    jsr muls8s
    lda a
    ldx b
    jsr mulf8s
    ldy b
    jsr mul8s
    lda ms
    cmp mf
    bne !+
    lda ms+1
    cmp mf+1
    beq b5
  !:
    ldx #0
    jmp b6
  b5:
    ldx #1
  b6:
    lda ms
    cmp mn
    bne !+
    lda ms+1
    cmp mn+1
    beq b7
  !:
    ldx #0
  b7:
    cpx #0
    bne b8
    lda #2
    sta BGCOL
    ldx a
    jsr mul8s_error
    rts
  b8:
    inc b
    jmp b3
    str: .text "signed multiply results match!@"
}
// mul8s_error(signed byte register(X) a, signed byte zeropage($f) b, signed word zeropage(4) ms, signed word zeropage(8) mn, signed word zeropage($a) mf)
mul8s_error: {
    .label b = $f
    .label ms = 4
    .label mn = 8
    .label mf = $a
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    jsr print_sbyte
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    ldx b
    jsr print_sbyte
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    jsr print_sword
    lda #<str3
    sta print_str.str
    lda #>str3
    sta print_str.str+1
    jsr print_str
    lda mn
    sta print_sword.w
    lda mn+1
    sta print_sword.w+1
    jsr print_sword
    lda #<str4
    sta print_str.str
    lda #>str4
    sta print_str.str+1
    jsr print_str
    lda mf
    sta print_sword.w
    lda mf+1
    sta print_sword.w+1
    jsr print_sword
    jsr print_ln
    rts
    str: .text "signed multiply mismatch @"
}
// Print a newline
print_ln: {
  b1:
    lda #$28
    clc
    adc print_line_cursor
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
// Print a signed word as HEX
// print_sword(signed word zeropage(4) w)
print_sword: {
    .label w = 4
    lda w+1
    bmi b1
    lda #' '
    jsr print_char
  b2:
    jsr print_word
    rts
  b1:
    lda #'-'
    jsr print_char
    sec
    lda #0
    sbc w
    sta w
    lda #0
    sbc w+1
    sta w+1
    jmp b2
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    rts
}
// Print a word as HEX
// print_word(word zeropage(4) w)
print_word: {
    .label w = 4
    lda w+1
    tax
    jsr print_byte
    lda w
    tax
    jsr print_byte
    rts
}
// Print a byte as HEX
// print_byte(byte register(X) b)
print_byte: {
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    jsr print_char
    lda #$f
    axs #0
    lda print_hextab,x
    jsr print_char
    rts
}
// Print a zero-terminated string
// print_str(byte* zeropage($d) str)
print_str: {
    .label str = $d
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
// Print a signed byte as HEX
// print_sbyte(signed byte register(X) b)
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
// Multiply of two signed bytes to a signed word
// Fixes offsets introduced by using unsigned multiplication
// mul8s(signed byte zeropage($c) a, signed byte register(Y) b)
mul8s: {
    .label m = 8
    .label a = $c
    ldx a
    tya
    sta mul8u.mb
    lda #0
    sta mul8u.mb+1
    jsr mul8u
    lda a
    cmp #0
    bpl b1
    lda m+1
    sty $ff
    sec
    sbc $ff
    sta m+1
  b1:
    cpy #0
    bpl b2
    lda m+1
    sec
    sbc a
    sta m+1
  b2:
    rts
}
// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
// mul8u(byte register(X) a, byte register(A) b)
mul8u: {
    .label mb = $d
    .label res = 8
    .label return = 8
    lda #<0
    sta res
    sta res+1
  b1:
    cpx #0
    bne b2
    rts
  b2:
    txa
    and #1
    cmp #0
    beq b3
    lda res
    clc
    adc mb
    sta res
    lda res+1
    adc mb+1
    sta res+1
  b3:
    txa
    lsr
    tax
    asl mb
    rol mb+1
    jmp b1
}
// Fast multiply two signed bytes to a word result
// mulf8s(signed byte register(A) a, signed byte register(X) b)
mulf8s: {
    .label return = $a
    jsr mulf8u_prepare
    stx mulf8s_prepared.b
    jsr mulf8s_prepared
    rts
}
// Calculate fast multiply with a prepared unsigned byte to a word result
// The prepared number is set by calling mulf8s_prepare(byte a)
// mulf8s_prepared(signed byte zeropage($f) b)
mulf8s_prepared: {
    .label memA = $fd
    .label m = $a
    .label b = $f
    ldx b
    jsr mulf8u_prepared
    lda memA
    cmp #0
    bpl b1
    lda m+1
    sec
    sbc b
    sta m+1
  b1:
    lda b
    cmp #0
    bpl b2
    lda m+1
    sec
    sbc memA
    sta m+1
  b2:
    rts
}
// Calculate fast multiply with a prepared unsigned byte to a word result
// The prepared number is set by calling mulf8u_prepare(byte a)
// mulf8u_prepared(byte register(X) b)
mulf8u_prepared: {
    .label resL = $fe
    .label memB = $ff
    .label return = $a
    stx memB
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
    lda resL
    sta return
    lda memB
    sta return+1
    rts
}
// Prepare for fast multiply with an unsigned byte to a word result
// mulf8u_prepare(byte register(A) a)
mulf8u_prepare: {
    .label memA = $fd
    sta memA
    sta mulf8u_prepared.sm1+1
    sta mulf8u_prepared.sm3+1
    eor #$ff
    sta mulf8u_prepared.sm2+1
    sta mulf8u_prepared.sm4+1
    rts
}
// Slow multiplication of signed bytes
// Perform a signed multiplication by repeated addition/subtraction
// muls8s(signed byte zeropage($c) a, signed byte register(X) b)
muls8s: {
    .label m = 4
    .label return = 4
    .label a = $c
    lda a
    bmi b8
    cmp #1
    bmi b7
    lda #<0
    sta m
    sta m+1
    tay
  b3:
    cpy a
    bne b4
    rts
  b7:
    lda #<0
    sta return
    sta return+1
    rts
  b4:
    txa
    sta $fe
    ora #$7f
    bmi !+
    lda #0
  !:
    sta $ff
    clc
    lda m
    adc $fe
    sta m
    lda m+1
    adc $ff
    sta m+1
    iny
    jmp b3
  b8:
    lda #<0
    sta m
    sta m+1
    tay
  b5:
    cpy a
    bne b6
    rts
  b6:
    txa
    sta $fe
    ora #$7f
    bmi !+
    lda #0
  !:
    sta $ff
    sec
    lda m
    sbc $fe
    sta m
    lda m+1
    sbc $ff
    sta m+1
    dey
    jmp b5
}
// Perform all possible byte multiplications (slow and fast) and compare the results
mul8u_compare: {
    .label ms = 4
    .label mf = $a
    .label mn = 8
    .label b = $f
    .label a = $c
    lda #0
    sta a
  b1:
    lda #0
    sta b
  b2:
    ldx b
    jsr muls8u
    lda a
    ldx b
    jsr mulf8u
    ldx a
    lda b
    sta mul8u.mb
    lda #0
    sta mul8u.mb+1
    jsr mul8u
    lda ms
    cmp mf
    bne !+
    lda ms+1
    cmp mf+1
    beq b6
  !:
    ldx #0
    jmp b3
  b6:
    ldx #1
  b3:
    lda ms
    cmp mn
    bne !+
    lda ms+1
    cmp mn+1
    beq b4
  !:
    ldx #0
  b4:
    cpx #0
    bne b5
    lda #2
    sta BGCOL
    ldx a
    jsr mul8u_error
    rts
  b5:
    inc b
    lda b
    cmp #0
    bne b2
    inc a
    lda a
    cmp #0
    bne b1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    jsr print_ln
    rts
    str: .text "multiply results match!@"
}
// mul8u_error(byte register(X) a, byte zeropage($f) b, word zeropage(4) ms, word zeropage(8) mn, word zeropage($a) mf)
mul8u_error: {
    .label b = $f
    .label ms = 4
    .label mn = 8
    .label mf = $a
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    jsr print_byte
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    ldx b
    jsr print_byte
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    jsr print_word
    lda #<str3
    sta print_str.str
    lda #>str3
    sta print_str.str+1
    jsr print_str
    lda mn
    sta print_word.w
    lda mn+1
    sta print_word.w+1
    jsr print_word
    lda #<str4
    sta print_str.str
    lda #>str4
    sta print_str.str+1
    jsr print_str
    lda mf
    sta print_word.w
    lda mf+1
    sta print_word.w+1
    jsr print_word
    jsr print_ln
    rts
    str: .text "multiply mismatch @"
}
// Fast multiply two unsigned bytes to a word result
// mulf8u(byte register(A) a, byte register(X) b)
mulf8u: {
    .label return = $a
    jsr mulf8u_prepare
    jsr mulf8u_prepared
    rts
}
// Slow multiplication of unsigned bytes
// Calculate an unsigned multiplication by repeated addition
// muls8u(byte zeropage($c) a, byte register(X) b)
muls8u: {
    .label return = 4
    .label m = 4
    .label a = $c
    lda a
    cmp #0
    beq b4
    lda #<0
    sta m
    sta m+1
    tay
  b2:
    cpy a
    bne b3
    rts
  b4:
    lda #<0
    sta return
    sta return+1
    rts
  b3:
    txa
    clc
    adc m
    sta m
    bcc !+
    inc m+1
  !:
    iny
    jmp b2
}
// Compare the ASM-based mul tables with the KC-based mul tables
// Red screen on failure - green on success
mulf_tables_cmp: {
    .label asm_sqr = 4
    .label kc_sqr = 2
    lda #<mula_sqr1_lo
    sta asm_sqr
    lda #>mula_sqr1_lo
    sta asm_sqr+1
    lda #<mulf_sqr1_lo
    sta kc_sqr
    lda #>mulf_sqr1_lo
    sta kc_sqr+1
  b1:
    lda kc_sqr+1
    cmp #>mulf_sqr1_lo+$200*4
    bcc b2
    bne !+
    lda kc_sqr
    cmp #<mulf_sqr1_lo+$200*4
    bcc b2
  !:
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    rts
  b2:
    ldy #0
    lda (kc_sqr),y
    cmp (asm_sqr),y
    beq b4
    lda #2
    sta BGCOL
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    jsr print_word
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    lda kc_sqr
    sta print_word.w
    lda kc_sqr+1
    sta print_word.w+1
    jsr print_word
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    rts
  b4:
    inc asm_sqr
    bne !+
    inc asm_sqr+1
  !:
    inc kc_sqr
    bne !+
    inc kc_sqr+1
  !:
    jmp b1
    str: .text "multiply tables match!@"
    str1: .text "multiply table mismatch at @"
    str2: .text " / @"
}
// Initialize the multiplication tables using ASM code from
// http://codebase64.org/doku.php?id=base:seriously_fast_multiplication
mulf_init_asm: {
    // Ensure the ASM tables are not detected as unused by the optimizer
    .label mem = $ff
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
    lda mula_sqr1_lo
    sta mem
    lda mula_sqr1_hi
    sta mem
    lda mula_sqr2_lo
    sta mem
    lda mula_sqr2_hi
    sta mem
    rts
}
// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
mulf_init: {
    .label c = $f
    .label sqr1_hi = 6
    .label sqr = $d
    .label sqr1_lo = 4
    .label sqr2_hi = $a
    .label sqr2_lo = 8
    .label dir = $c
    ldx #0
    lda #<mulf_sqr1_hi+1
    sta sqr1_hi
    lda #>mulf_sqr1_hi+1
    sta sqr1_hi+1
    txa
    sta sqr
    sta sqr+1
    sta c
    lda #<mulf_sqr1_lo+1
    sta sqr1_lo
    lda #>mulf_sqr1_lo+1
    sta sqr1_lo+1
  b1:
    lda sqr1_lo+1
    cmp #>mulf_sqr1_lo+$200
    bne b2
    lda sqr1_lo
    cmp #<mulf_sqr1_lo+$200
    bne b2
    lda #$ff
    sta dir
    lda #<mulf_sqr2_hi
    sta sqr2_hi
    lda #>mulf_sqr2_hi
    sta sqr2_hi+1
    ldx #-1
    lda #<mulf_sqr2_lo
    sta sqr2_lo
    lda #>mulf_sqr2_lo
    sta sqr2_lo+1
  b5:
    lda sqr2_lo+1
    cmp #>mulf_sqr2_lo+$1ff
    bne b6
    lda sqr2_lo
    cmp #<mulf_sqr2_lo+$1ff
    bne b6
    // Set the very last value g(511) = f(256)
    lda mulf_sqr1_lo+$100
    sta mulf_sqr2_lo+$1ff
    lda mulf_sqr1_hi+$100
    sta mulf_sqr2_hi+$1ff
    rts
  b6:
    lda mulf_sqr1_lo,x
    ldy #0
    sta (sqr2_lo),y
    lda mulf_sqr1_hi,x
    sta (sqr2_hi),y
    inc sqr2_hi
    bne !+
    inc sqr2_hi+1
  !:
    txa
    clc
    adc dir
    tax
    cpx #0
    bne b8
    lda #1
    sta dir
  b8:
    inc sqr2_lo
    bne !+
    inc sqr2_lo+1
  !:
    jmp b5
  b2:
    inc c
    lda #1
    and c
    cmp #0
    bne b3
    inx
    inc sqr
    bne !+
    inc sqr+1
  !:
  b3:
    lda sqr
    ldy #0
    sta (sqr1_lo),y
    lda sqr+1
    sta (sqr1_hi),y
    inc sqr1_hi
    bne !+
    inc sqr1_hi+1
  !:
    txa
    clc
    adc sqr
    sta sqr
    bcc !+
    inc sqr+1
  !:
    inc sqr1_lo
    bne !+
    inc sqr1_lo+1
  !:
    jmp b1
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
    .label str = $400
    .label end = str+num
    .label dst = $d
    lda #<str
    sta dst
    lda #>str
    sta dst+1
  b1:
    lda dst+1
    cmp #>end
    bne b2
    lda dst
    cmp #<end
    bne b2
    rts
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    jmp b1
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
  str1: .text "*@"
  str2: .text " slow:@"
  str3: .text " / normal:@"
  str4: .text " / fast:@"
