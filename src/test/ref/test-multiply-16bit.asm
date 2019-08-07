// Test the fast multiplication library
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
  .label print_char_cursor = $15
  .label print_line_cursor = $13
main: {
    lda #5
    sta BGCOL
    jsr print_cls
    jsr mulf_init
    jsr mul16u_compare
    jsr mul16s_compare
    rts
}
// Perform many possible word multiplications (slow and fast) and compare the results
mul16s_compare: {
    .label a = $e
    .label b = $10
    .label ms = 2
    .label mn = 6
    .label mf = $a
    .label i = $12
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #0
    sta i
    lda #<-$7fff
    sta b
    lda #>-$7fff
    sta b+1
    lda #<-$7fff
    sta a
    lda #>-$7fff
    sta a+1
  b1:
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    ldy #0
  b2:
    clc
    lda a
    adc #<$d2b
    sta a
    lda a+1
    adc #>$d2b
    sta a+1
    clc
    lda b
    adc #<$ffd
    sta b
    lda b+1
    adc #>$ffd
    sta b+1
    jsr muls16s
    jsr mul16s
    jsr mulf16s
    lda ms
    cmp mf
    bne !+
    lda ms+1
    cmp mf+1
    bne !+
    lda ms+2
    cmp mf+2
    bne !+
    lda ms+3
    cmp mf+3
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
    bne !+
    lda ms+2
    cmp mn+2
    bne !+
    lda ms+3
    cmp mn+3
    beq b4
  !:
    ldx #0
  b4:
    cpx #0
    bne b5
    lda #2
    sta BGCOL
    jsr mul16s_error
    rts
  b5:
    iny
    cpy #$10
    bne b2
    inc i
    lda #$10
    cmp i
    beq !b1+
    jmp b1
  !b1:
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    jsr print_ln
    rts
    str1: .text "signed word multiply results match!"
    .byte 0
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
// Print a zero-terminated string
// print_str(byte* zeropage($1a) str)
print_str: {
    .label str = $1a
  b1:
    ldy #0
    lda (str),y
    cmp #0
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
// mul16s_error(signed word zeropage($e) a, signed word zeropage($10) b, signed dword zeropage(2) ms, signed dword zeropage(6) mn, signed dword zeropage($a) mf)
mul16s_error: {
    .label a = $e
    .label b = $10
    .label ms = 2
    .label mn = 6
    .label mf = $a
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    jsr print_sword
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda b
    sta print_sword.w
    lda b+1
    sta print_sword.w+1
    jsr print_sword
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    jsr print_sdword
    lda #<str3
    sta print_str.str
    lda #>str3
    sta print_str.str+1
    jsr print_str
    lda mn
    sta print_sdword.dw
    lda mn+1
    sta print_sdword.dw+1
    lda mn+2
    sta print_sdword.dw+2
    lda mn+3
    sta print_sdword.dw+3
    jsr print_sdword
    lda #<str4
    sta print_str.str
    lda #>str4
    sta print_str.str+1
    jsr print_str
    lda mf
    sta print_sdword.dw
    lda mf+1
    sta print_sdword.dw+1
    lda mf+2
    sta print_sdword.dw+2
    lda mf+3
    sta print_sdword.dw+3
    jsr print_sdword
    jsr print_ln
    rts
    str: .text "signed word multiply mismatch "
    .byte 0
}
// Print a signed dword as HEX
// print_sdword(signed dword zeropage(2) dw)
print_sdword: {
    .label dw = 2
    lda dw+3
    bmi b1
    lda #' '
    jsr print_char
  b2:
    jsr print_dword
    rts
  b1:
    lda #'-'
    jsr print_char
    sec
    lda dw
    eor #$ff
    adc #0
    sta dw
    lda dw+1
    eor #$ff
    adc #0
    sta dw+1
    lda dw+2
    eor #$ff
    adc #0
    sta dw+2
    lda dw+3
    eor #$ff
    adc #0
    sta dw+3
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
// Print a dword as HEX
// print_dword(dword zeropage(2) dw)
print_dword: {
    .label dw = 2
    lda dw+2
    sta print_word.w
    lda dw+3
    sta print_word.w+1
    jsr print_word
    lda dw
    sta print_word.w
    lda dw+1
    sta print_word.w+1
    jsr print_word
    rts
}
// Print a word as HEX
// print_word(word zeropage($e) w)
print_word: {
    .label w = $e
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
// Print a signed word as HEX
// print_sword(signed word zeropage($e) w)
print_sword: {
    .label w = $e
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
// Fast multiply two signed words to a signed double word result
// Fixes offsets introduced by using unsigned multiplication
// mulf16s(signed word zeropage($e) a, signed word zeropage($10) b)
mulf16s: {
    .label _9 = $1c
    .label _13 = $1e
    .label _16 = $1c
    .label _17 = $1e
    .label m = $a
    .label return = $a
    .label a = $e
    .label b = $10
    lda a
    sta mulf16u.a
    lda a+1
    sta mulf16u.a+1
    lda b
    sta mulf16u.b
    lda b+1
    sta mulf16u.b+1
    jsr mulf16u
    lda a+1
    bpl b1
    lda m+2
    sta _9
    lda m+3
    sta _9+1
    lda _16
    sec
    sbc b
    sta _16
    lda _16+1
    sbc b+1
    sta _16+1
    lda _16
    sta m+2
    lda _16+1
    sta m+3
  b1:
    lda b+1
    bpl b2
    lda m+2
    sta _13
    lda m+3
    sta _13+1
    lda _17
    sec
    sbc a
    sta _17
    lda _17+1
    sbc a+1
    sta _17+1
    lda _17
    sta m+2
    lda _17+1
    sta m+3
  b2:
    rts
}
// Fast multiply two unsigned words to a double word result
// Done in assembler to utilize fast addition A+X
// mulf16u(word zeropage($1c) a, word zeropage($1e) b)
mulf16u: {
    .label memA = $f8
    .label memB = $fa
    .label memR = $fc
    .label return = $a
    .label a = $1c
    .label b = $1e
    lda a
    sta memA
    lda a+1
    sta memA+1
    lda b
    sta memB
    lda b+1
    sta memB+1
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
    lda memR
    sta return
    lda memR+1
    sta return+1
    lda memR+2
    sta return+2
    lda memR+3
    sta return+3
    rts
}
// Multiply of two signed words to a signed double word
// Fixes offsets introduced by using unsigned multiplication
// mul16s(signed word zeropage($e) a, signed word zeropage($10) b)
mul16s: {
    .label _9 = $1c
    .label _13 = $1e
    .label _16 = $1c
    .label _17 = $1e
    .label m = 6
    .label return = 6
    .label a = $e
    .label b = $10
    lda a
    sta mul16u.a
    lda a+1
    sta mul16u.a+1
    lda b
    sta mul16u.b
    lda b+1
    sta mul16u.b+1
    lda mul16u.b
    sta mul16u.mb
    lda mul16u.b+1
    sta mul16u.mb+1
    lda #0
    sta mul16u.mb+2
    sta mul16u.mb+3
    jsr mul16u
    lda a+1
    bpl b1
    lda m+2
    sta _9
    lda m+3
    sta _9+1
    lda _16
    sec
    sbc b
    sta _16
    lda _16+1
    sbc b+1
    sta _16+1
    lda _16
    sta m+2
    lda _16+1
    sta m+3
  b1:
    lda b+1
    bpl b2
    lda m+2
    sta _13
    lda m+3
    sta _13+1
    lda _17
    sec
    sbc a
    sta _17
    lda _17+1
    sbc a+1
    sta _17+1
    lda _17
    sta m+2
    lda _17+1
    sta m+3
  b2:
    rts
}
// Perform binary multiplication of two unsigned 16-bit words into a 32-bit unsigned double word
// mul16u(word zeropage($17) a, word zeropage($1a) b)
mul16u: {
    .label mb = $a
    .label a = $17
    .label res = 6
    .label b = $1a
    .label return = 6
    .label b_1 = $1e
    lda #0
    sta res
    sta res+1
    sta res+2
    sta res+3
  b1:
    lda a
    bne b2
    lda a+1
    bne b2
    rts
  b2:
    lda a
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
    lda res+2
    adc mb+2
    sta res+2
    lda res+3
    adc mb+3
    sta res+3
  b3:
    lsr a+1
    ror a
    asl mb
    rol mb+1
    rol mb+2
    rol mb+3
    jmp b1
}
// Slow multiplication of signed words
// Perform a signed multiplication by repeated addition/subtraction
// muls16s(signed word zeropage($e) a, signed word zeropage($10) b)
muls16s: {
    .label m = 2
    .label j = $1c
    .label return = 2
    .label i = $1e
    .label a = $e
    .label b = $10
    lda a+1
    bmi b8
    bmi b7
    bne !+
    lda a
    beq b7
  !:
    lda #0
    sta m
    sta m+1
    sta m+2
    sta m+3
    sta j
    sta j+1
  b3:
    lda j+1
    cmp a+1
    bne b4
    lda j
    cmp a
    bne b4
    rts
  b7:
    lda #0
    sta return
    sta return+1
    sta return+2
    sta return+3
    rts
  b4:
    lda b+1
    ora #$7f
    bmi !+
    lda #0
  !:
    sta $ff
    lda m
    clc
    adc b
    sta m
    lda m+1
    adc b+1
    sta m+1
    lda m+2
    adc $ff
    sta m+2
    lda m+3
    adc $ff
    sta m+3
    inc j
    bne !+
    inc j+1
  !:
    jmp b3
  b8:
    lda #0
    sta m
    sta m+1
    sta m+2
    sta m+3
    sta i
    sta i+1
  b5:
    lda i+1
    cmp a+1
    bne b6
    lda i
    cmp a
    bne b6
    rts
  b6:
    lda b+1
    ora #$7f
    bmi !+
    lda #0
  !:
    sta $ff
    sec
    lda m
    sbc b
    sta m
    lda m+1
    sbc b+1
    sta m+1
    lda m+2
    sbc $ff
    sta m+2
    lda m+3
    sbc $ff
    sta m+3
    lda i
    bne !+
    dec i+1
  !:
    dec i
    jmp b5
}
// Perform many possible word multiplications (slow and fast) and compare the results
mul16u_compare: {
    .label a = $1c
    .label b = $1e
    .label ms = 2
    .label mn = 6
    .label mf = $a
    .label i = $12
    lda #0
    sta i
    sta b
    sta b+1
    sta a
    sta a+1
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
  b1:
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    ldy #0
  b2:
    clc
    lda a
    adc #<$d2b
    sta a
    lda a+1
    adc #>$d2b
    sta a+1
    clc
    lda b
    adc #<$ffd
    sta b
    lda b+1
    adc #>$ffd
    sta b+1
    jsr muls16u
    lda a
    sta mul16u.a
    lda a+1
    sta mul16u.a+1
    lda mul16u.b_1
    sta mul16u.mb
    lda mul16u.b_1+1
    sta mul16u.mb+1
    lda #0
    sta mul16u.mb+2
    sta mul16u.mb+3
    jsr mul16u
    jsr mulf16u
    lda ms
    cmp mf
    bne !+
    lda ms+1
    cmp mf+1
    bne !+
    lda ms+2
    cmp mf+2
    bne !+
    lda ms+3
    cmp mf+3
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
    bne !+
    lda ms+2
    cmp mn+2
    bne !+
    lda ms+3
    cmp mn+3
    beq b4
  !:
    ldx #0
  b4:
    cpx #0
    bne b5
    lda #2
    sta BGCOL
    lda a
    sta mul16u_error.a
    lda a+1
    sta mul16u_error.a+1
    jsr mul16u_error
    rts
  b5:
    iny
    cpy #$10
    beq !b2+
    jmp b2
  !b2:
    inc i
    lda #$10
    cmp i
    beq !b1+
    jmp b1
  !b1:
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    jsr print_ln
    rts
    str1: .text "word multiply results match!"
    .byte 0
}
// mul16u_error(word zeropage($e) a, word zeropage($1e) b, dword zeropage(2) ms, dword zeropage(6) mn, dword zeropage($a) mf)
mul16u_error: {
    .label a = $e
    .label b = $1e
    .label ms = 2
    .label mn = 6
    .label mf = $a
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    jsr print_word
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda b
    sta print_word.w
    lda b+1
    sta print_word.w+1
    jsr print_word
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    jsr print_dword
    lda #<str3
    sta print_str.str
    lda #>str3
    sta print_str.str+1
    jsr print_str
    lda mn
    sta print_dword.dw
    lda mn+1
    sta print_dword.dw+1
    lda mn+2
    sta print_dword.dw+2
    lda mn+3
    sta print_dword.dw+3
    jsr print_dword
    lda #<str4
    sta print_str.str
    lda #>str4
    sta print_str.str+1
    jsr print_str
    lda mf
    sta print_dword.dw
    lda mf+1
    sta print_dword.dw+1
    lda mf+2
    sta print_dword.dw+2
    lda mf+3
    sta print_dword.dw+3
    jsr print_dword
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    jsr print_ln
    rts
    str: .text "multiply mismatch "
    .byte 0
}
// Slow multiplication of unsigned words
// Calculate an unsigned multiplication by repeated addition
// muls16u(word zeropage($1c) a, word zeropage($1e) b)
muls16u: {
    .label return = 2
    .label m = 2
    .label i = $e
    .label a = $1c
    .label b = $1e
    lda a
    bne !+
    lda a+1
    beq b4
  !:
    lda #0
    sta m
    sta m+1
    sta m+2
    sta m+3
    sta i
    sta i+1
  b2:
    lda i+1
    cmp a+1
    bne b3
    lda i
    cmp a
    bne b3
    rts
  b4:
    lda #0
    sta return
    sta return+1
    sta return+2
    sta return+3
    rts
  b3:
    lda m
    clc
    adc b
    sta m
    lda m+1
    adc b+1
    sta m+1
    lda m+2
    adc #0
    sta m+2
    lda m+3
    adc #0
    sta m+3
    inc i
    bne !+
    inc i+1
  !:
    jmp b2
}
// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
mulf_init: {
    .label c = $12
    .label sqr1_hi = $13
    .label sqr = $1a
    .label sqr1_lo = $10
    .label sqr2_hi = $17
    .label sqr2_lo = $15
    .label dir = $19
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
    .label dst = $1a
    lda #<str
    sta dst
    lda #>str
    sta dst+1
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp #>end
    bne b2
    lda dst
    cmp #<end
    bne b2
    rts
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
