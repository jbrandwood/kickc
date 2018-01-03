.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const BGCOL = $d021
  .label char_cursor = 8
  .label line_cursor = 4
  jsr main
main: {
    lda #5
    sta BGCOL
    jsr print_cls
    jsr init_multiply
    jsr init_multiply_asm
    jsr multiply_tables_compare
    jsr multiply_results_compare
    jsr signed_multiply_results_compare
    rts
}
signed_multiply_results_compare: {
    .label ms = 8
    .label ma = 6
    .label b = 3
    .label a = 2
    lda #-$80
    sta a
  b1:
    lda #-$80
    sta b
  b2:
    ldx b
    jsr slow_signed_multiply
    lda slow_signed_multiply.return
    sta ms
    lda slow_signed_multiply.return+1
    sta ms+1
    ldy a
    jsr signed_multiply
    lda ms
    cmp ma
    bne !+
    lda ms+1
    cmp ma+1
    beq b3
  !:
    lda #2
    sta BGCOL
    ldx a
    lda b
    sta signed_multiply_error.b
    lda ms
    sta signed_multiply_error.ms
    lda ms+1
    sta signed_multiply_error.ms+1
    lda ma
    sta signed_multiply_error.ma
    lda ma+1
    sta signed_multiply_error.ma+1
    jsr signed_multiply_error
  breturn:
    rts
  b3:
    inc b
    lda b
    cmp #-$80
    bne b2
    inc a
    lda a
    cmp #-$80
    bne b1
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    jsr print_ln
    jmp breturn
    str: .text "signed multiply results match!@"
}
print_ln: {
  b1:
    lda line_cursor
    clc
    adc #$28
    sta line_cursor
    bcc !+
    inc line_cursor+1
  !:
    lda line_cursor+1
    cmp char_cursor+1
    bcc b1
    bne !+
    lda line_cursor
    cmp char_cursor
    bcc b1
  !:
    rts
}
print_str: {
    .label str = 6
  b1:
    ldy #0
    lda (str),y
    cmp #'@'
    bne b2
    rts
  b2:
    ldy #0
    lda (str),y
    sta (char_cursor),y
    inc char_cursor
    bne !+
    inc char_cursor+1
  !:
    inc str
    bne !+
    inc str+1
  !:
    jmp b1
}
signed_multiply_error: {
    .label b = 2
    .label ms = $a
    .label ma = $c
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
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
    lda ms
    sta print_sword.w
    lda ms+1
    sta print_sword.w+1
    jsr print_sword
    lda #<str3
    sta print_str.str
    lda #>str3
    sta print_str.str+1
    jsr print_str
    lda ma
    sta print_sword.w
    lda ma+1
    sta print_sword.w+1
    jsr print_sword
    jsr print_ln
    rts
    str: .text "signed multiply mismatch @"
    str1: .text "*@"
    str2: .text " slow:@"
    str3: .text " / fast asm:@"
}
print_sword: {
    .label w = 6
    lda w+1
    bpl b1
    lda #'-'
    jsr print_char
    sec
    lda w
    eor #$ff
    adc #0
    sta w
    lda w+1
    eor #$ff
    adc #0
    sta w+1
  b1:
    jsr print_word
    rts
}
print_word: {
    .label w = 6
    lda w+1
    tax
    jsr print_byte
    lda w
    tax
    jsr print_byte
    rts
}
print_byte: {
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    lda hextab,y
    jsr print_char
    txa
    and #$f
    tay
    lda hextab,y
    jsr print_char
    rts
    hextab: .text "0123456789abcdef"
}
print_char: {
    ldy #0
    sta (char_cursor),y
    inc char_cursor
    bne !+
    inc char_cursor+1
  !:
    rts
}
print_sbyte: {
    cpx #0
    bpl b1
    lda #'-'
    jsr print_char
    txa
    eor #$ff
    clc
    adc #1
    tax
  b1:
    jsr print_byte
    rts
}
signed_multiply: {
    .label _6 = $e
    .label m = 6
    .label return = 6
    .label b = 3
    tya
    tax
    lda b
    jsr multiply
    cpy #0
    bpl b1
    lda m+1
    sta _6
    lda b
    eor #$ff
    sec
    adc _6
    sta m+1
  b1:
    lda b
    cmp #0
    bpl b2
    lda m+1
    sty $ff
    sec
    sbc $ff
    sta m+1
  b2:
    rts
}
multiply: {
    .const memA = $fe
    .const memB = $ff
    .label return = 6
    stx memA
    sta memB
    txa
    sta sm1+1
    sta sm3+1
    eor #$ff
    sta sm2+1
    sta sm4+1
    ldx memB
    sec
  sm1:
    lda mul_sqr1_lo,x
  sm2:
    sbc mul_sqr2_lo,x
    sta memA
  sm3:
    lda mul_sqr1_hi,x
  sm4:
    sbc mul_sqr2_hi,x
    sta memB
    lda memA
    sta return
    lda memB
    sta return+1
    rts
}
slow_signed_multiply: {
    .label m = 6
    .label return = 6
    .label a = 2
    lda a
    cmp #0
    bpl b1
    lda #0
    tay
    sta m
    sta m+1
  b2:
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
    cpy a
    bne b2
    jmp b3
  b6:
    lda #0
    sta return
    sta return+1
  b3:
    rts
  b1:
    lda a
    cmp #1
    bmi b6
    lda #0
    tay
    sta m
    sta m+1
  b5:
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
    cpy a
    bne b5
    jmp b3
}
multiply_results_compare: {
    .label ms = $a
    .label ma = 6
    .label b = 3
    .label a = 2
    lda #0
    sta a
  b1:
    lda #0
    sta b
  b2:
    ldx b
    jsr slow_multiply
    lda slow_multiply.return
    sta ms
    lda slow_multiply.return+1
    sta ms+1
    ldx a
    lda b
    jsr multiply
    lda ms
    cmp ma
    bne !+
    lda ms+1
    cmp ma+1
    beq b3
  !:
    lda #2
    sta BGCOL
    ldx a
    lda b
    sta multiply_error.b
    lda ma
    sta multiply_error.ma
    lda ma+1
    sta multiply_error.ma+1
    jsr multiply_error
  breturn:
    rts
  b3:
    inc b
    lda b
    bne b2
    inc a
    lda a
    bne b1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    jsr print_ln
    jmp breturn
    str: .text "multiply results match!@"
}
multiply_error: {
    .label b = 2
    .label ms = $a
    .label ma = $c
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
    lda ms
    sta print_word.w
    lda ms+1
    sta print_word.w+1
    jsr print_word
    lda #<str3
    sta print_str.str
    lda #>str3
    sta print_str.str+1
    jsr print_str
    lda ma
    sta print_word.w
    lda ma+1
    sta print_word.w+1
    jsr print_word
    jsr print_ln
    rts
    str: .text "multiply mismatch @"
    str1: .text "*@"
    str2: .text " slow:@"
    str3: .text " / fast asm:@"
}
slow_multiply: {
    .label return = 6
    .label m = 6
    .label a = 2
    lda a
    beq b3
    ldy #0
    tya
    sta m
    sta m+1
  b2:
    txa
    clc
    adc m
    sta m
    lda #0
    adc m+1
    sta m+1
    iny
    cpy a
    bne b2
    jmp b1
  b3:
    lda #0
    sta return
    sta return+1
  b1:
    rts
}
multiply_tables_compare: {
    .label asm_sqr = $a
    .label kc_sqr = 4
    lda #<asm_mul_sqr1_lo
    sta asm_sqr
    lda #>asm_mul_sqr1_lo
    sta asm_sqr+1
    lda #<mul_sqr1_lo
    sta kc_sqr
    lda #>mul_sqr1_lo
    sta kc_sqr+1
  b1:
    ldy #0
    lda (kc_sqr),y
    cmp (asm_sqr),y
    beq b2
    lda #2
    sta BGCOL
    lda #<$400
    sta char_cursor
    lda #>$400
    sta char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda asm_sqr
    sta print_word.w
    lda asm_sqr+1
    sta print_word.w+1
    jsr print_word
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda kc_sqr
    sta print_word.w
    lda kc_sqr+1
    sta print_word.w+1
    jsr print_word
    lda #<$400
    sta line_cursor
    lda #>$400
    sta line_cursor+1
  breturn:
    rts
  b2:
    inc asm_sqr
    bne !+
    inc asm_sqr+1
  !:
    inc kc_sqr
    bne !+
    inc kc_sqr+1
  !:
    lda kc_sqr+1
    cmp #>mul_sqr1_lo+$200*4
    bcc b1
    bne !+
    lda kc_sqr
    cmp #<mul_sqr1_lo+$200*4
    bcc b1
  !:
    lda #<$400
    sta char_cursor
    lda #>$400
    sta char_cursor+1
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    lda #<$400
    sta line_cursor
    lda #>$400
    sta line_cursor+1
    jsr print_ln
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    jmp breturn
    str: .text "multiply table mismatch at @"
    str1: .text " / @"
    str2: .text "multiply tables match!@"
}
init_multiply_asm: {
    .const mem = $ff
    ldx #0
    txa
    .byte $c9
  lb1:
    tya
    adc #0
  ml1:
    sta asm_mul_sqr1_hi,x
    tay
    cmp #$40
    txa
    ror
  ml9:
    adc #0
    sta ml9+1
    inx
  ml0:
    sta asm_mul_sqr1_lo,x
    bne lb1
    inc ml0+2
    inc ml1+2
    clc
    iny
    bne lb1
    ldx #0
    ldy #$ff
  !:
    lda asm_mul_sqr1_hi+1,x
    sta asm_mul_sqr2_hi+$100,x
    lda asm_mul_sqr1_hi,x
    sta asm_mul_sqr2_hi,y
    lda asm_mul_sqr1_lo+1,x
    sta asm_mul_sqr2_lo+$100,x
    lda asm_mul_sqr1_lo,x
    sta asm_mul_sqr2_lo,y
    dey
    inx
    bne !-
    lda asm_mul_sqr1_lo
    sta mem
    lda asm_mul_sqr1_hi
    sta mem
    lda asm_mul_sqr2_lo
    sta mem
    lda asm_mul_sqr2_hi
    sta mem
    rts
}
init_multiply: {
    .label sqr1_hi = 6
    .label sqr = 8
    .label sqr1_lo = 4
    .label x_2 = 2
    .label sqr2_hi = 6
    .label sqr2_lo = 4
    .label dir = 2
    lda #0
    sta x_2
    lda #<mul_sqr1_hi+1
    sta sqr1_hi
    lda #>mul_sqr1_hi+1
    sta sqr1_hi+1
    lda #<mul_sqr1_lo+1
    sta sqr1_lo
    lda #>mul_sqr1_lo+1
    sta sqr1_lo+1
    lda #0
    sta sqr
    sta sqr+1
    tax
  b1:
    inx
    txa
    and #1
    cmp #0
    bne b2
    inc x_2
    inc sqr
    bne !+
    inc sqr+1
  !:
  b2:
    lda sqr
    ldy #0
    sta (sqr1_lo),y
    lda sqr+1
    sta (sqr1_hi),y
    inc sqr1_hi
    bne !+
    inc sqr1_hi+1
  !:
    lda x_2
    clc
    adc sqr
    sta sqr
    lda #0
    adc sqr+1
    sta sqr+1
    inc sqr1_lo
    bne !+
    inc sqr1_lo+1
  !:
    lda sqr1_lo+1
    cmp #>mul_sqr1_lo+$200
    bne b1
    lda sqr1_lo
    cmp #<mul_sqr1_lo+$200
    bne b1
    lda #$ff
    sta dir
    lda #<mul_sqr2_hi
    sta sqr2_hi
    lda #>mul_sqr2_hi
    sta sqr2_hi+1
    lda #<mul_sqr2_lo
    sta sqr2_lo
    lda #>mul_sqr2_lo
    sta sqr2_lo+1
    ldx #-1
  b3:
    lda mul_sqr1_lo,x
    ldy #0
    sta (sqr2_lo),y
    lda mul_sqr1_hi,x
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
    bne b4
    lda #1
    sta dir
  b4:
    inc sqr2_lo
    bne !+
    inc sqr2_lo+1
  !:
    lda sqr2_lo+1
    cmp #>mul_sqr2_lo+$1ff
    bne b3
    lda sqr2_lo
    cmp #<mul_sqr2_lo+$1ff
    bne b3
    lda mul_sqr1_lo+$100
    sta mul_sqr2_lo+$1ff
    lda mul_sqr1_hi+$100
    sta mul_sqr2_hi+$1ff
    rts
}
print_cls: {
    .label sc = 4
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
  .align $100
  mul_sqr1_lo: .fill $200, 0
  .align $100
  mul_sqr1_hi: .fill $200, 0
  .align $100
  mul_sqr2_lo: .fill $200, 0
  .align $100
  mul_sqr2_hi: .fill $200, 0
  .align $100
  asm_mul_sqr1_lo: .fill $200, 0
  .align $100
  asm_mul_sqr1_hi: .fill $200, 0
  .align $100
  asm_mul_sqr2_lo: .fill $200, 0
  .align $100
  asm_mul_sqr2_hi: .fill $200, 0
