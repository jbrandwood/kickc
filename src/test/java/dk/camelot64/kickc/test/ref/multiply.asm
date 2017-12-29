.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const BGCOL = $d021
  .label char_cursor = 6
  mul_sqr1_lo: .fill 512, 0
  mul_sqr1_hi: .fill 512, 0
  mul_sqr2_lo: .fill 512, 0
  mul_sqr2_hi: .fill 512, 0
  asm_mul_sqr1_lo: .fill 512, 0
  asm_mul_sqr1_hi: .fill 512, 0
  asm_mul_sqr2_lo: .fill 512, 0
  asm_mul_sqr2_hi: .fill 512, 0
  jsr main
main: {
    jsr init_mul_tables
    jsr init_mul_tables_asm
    jsr mul_tables_compare
    rts
}
mul_tables_compare: {
    .label asm_sqr = 4
    .label kc_sqr = 2
    lda #5
    sta BGCOL
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
    jsr print_cls
    lda #<$400
    sta char_cursor
    lda #>$400
    sta char_cursor+1
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
    lda kc_sqr
    sta print_word.w
    lda kc_sqr+1
    sta print_word.w+1
    jsr print_word
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
    jmp breturn
    str: .text "mul table mismatch at @"
    str1: .text " / @"
}
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
print_str: {
    .label str = 8
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
print_cls: {
    .label sc = 6
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
init_mul_tables_asm: {
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
init_mul_tables: {
    .label sqr1_hi = 4
    .label sqr = 6
    .label sqr1_lo = 2
    .label x_2 = $a
    .label sqr2_hi = 4
    .label sqr2_lo = 2
    .label dir = $a
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
