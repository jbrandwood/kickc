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
    rts
}
multiply_results_compare: {
    .label ms = $a
    .label ma = $c
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
    lda multiply.return
    sta ma
    lda multiply.return+1
    sta ma+1
    lda ms
    cmp ma
    bne !+
    lda ms+1
    cmp ma+1
    beq b3
  !:
    lda #2
    sta BGCOL
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda ms
    sta print_word.w
    lda ms+1
    sta print_word.w+1
    jsr print_word
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda ma
    sta print_word.w
    lda ma+1
    sta print_word.w+1
    jsr print_word
  breturn:
    rts
  b3:
    inc b
    lda b
    bne b2
    inc a
    lda a
    bne b1
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    jsr print_ln
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    jmp breturn
    str: .text "multiply mismatch slow:@"
    str1: .text " / fast asm:"
    str2: .text "multiply results match!@"
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
    tax
    lda hextab,x
    jsr print_char
    rts
    hextab: .byte '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
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
slow_multiply: {
    .label return = 6
    .label m = 6
    .label a = 2
    lda a
    cmp #0
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
    bcc !+
    inc m+1
  !:
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
    bcc !+
    inc sqr+1
  !:
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
    ldy #0
    lda #' '
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
