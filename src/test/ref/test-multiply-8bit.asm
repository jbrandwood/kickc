.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
  .label print_char_cursor = $a
  .label print_line_cursor = 4
  jsr main
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
mul8s_compare: {
    .label ms = 8
    .label mf = $e
    .label mn = $c
    .label b = 3
    .label a = 2
    lda #-$80
    sta a
  b1:
    lda #-$80
    sta b
  b2:
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
    jsr mul8s_error
  breturn:
    rts
  b5:
    inc b
    lda b
    cmp #-$80
    bne b2
    inc a
    lda a
    cmp #-$80
    bne b1
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
    jmp breturn
    str: .text "signed multiply results match!@"
}
print_ln: {
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
mul8s_error: {
    .label b = 3
    .label ms = 8
    .label mn = $c
    .label mf = $e
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
    str1: .text "*@"
    str2: .text " slow:@"
    str3: .text " / normal:@"
    str4: .text " / fast:@"
}
print_sword: {
    .label w = 8
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
    .label w = 8
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
    lda print_hextab,y
    jsr print_char
    txa
    and #$f
    tay
    lda print_hextab,y
    jsr print_char
    rts
}
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
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
mul8s: {
    .label m = $c
    .label a = 2
    .label return = $c
    tya
    ldx a
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
mul8u: {
    .label mb = 6
    .label res = $c
    .label return = $c
    sta mb
    lda #0
    sta mb+1
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
    beq b4
    lda res
    clc
    adc mb
    sta res
    lda res+1
    adc mb+1
    sta res+1
  b4:
    txa
    lsr
    tax
    asl mb
    rol mb+1
    jmp b1
}
mulf8s: {
    .label return = $e
    jsr mulf8u_prepare
    stx mulf8s_prepared.b
    jsr mulf8s_prepared
    rts
}
mulf8s_prepared: {
    .label memA = $fd
    .label m = $e
    .label b = 3
    .label return = $e
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
mulf8u_prepared: {
    .label resL = $fe
    .label memB = $ff
    .label return = $e
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
muls8s: {
    .label m = 8
    .label return = 8
    .label a = 2
    lda a
    bmi b6
    cmp #1
    bmi b2
    lda #0
    tay
    sta m
    sta m+1
  b3:
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
    bne b3
    jmp b4
  b2:
    lda #<0
    sta return
    sta return+1
  b4:
    rts
  b6:
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
    sec
    lda m
    sbc $fe
    sta m
    lda m+1
    sbc $ff
    sta m+1
    dey
    cpy a
    bne b5
    jmp b4
}
mul8u_compare: {
    .label ms = 8
    .label mf = $e
    .label mn = $c
    .label b = 3
    .label a = 2
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
  breturn:
    rts
  b5:
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
mul8u_error: {
    .label b = 3
    .label ms = 8
    .label mn = $c
    .label mf = $e
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
    str1: .text "*@"
    str2: .text " slow:@"
    str3: .text " / normal:@"
    str4: .text " / fast:@"
}
mulf8u: {
    .label return = $e
    jsr mulf8u_prepare
    jsr mulf8u_prepared
    rts
}
muls8u: {
    .label return = 8
    .label m = 8
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
    lda #<0
    sta return
    sta return+1
  b1:
    rts
}
mulf_tables_cmp: {
    .label asm_sqr = 8
    .label kc_sqr = 4
    lda #<mula_sqr1_lo
    sta asm_sqr
    lda #>mula_sqr1_lo
    sta asm_sqr+1
    lda #<mulf_sqr1_lo
    sta kc_sqr
    lda #>mulf_sqr1_lo
    sta kc_sqr+1
  b1:
    ldy #0
    lda (kc_sqr),y
    cmp (asm_sqr),y
    beq b2
    lda #2
    sta BGCOL
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
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
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
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
    cmp #>mulf_sqr1_lo+$200*4
    bcc b1
    bne !+
    lda kc_sqr
    cmp #<mulf_sqr1_lo+$200*4
    bcc b1
  !:
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<str2
    sta print_str.str
    lda #>str2
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
    jmp breturn
    str: .text "multiply table mismatch at @"
    str1: .text " / @"
    str2: .text "multiply tables match!@"
}
mulf_init_asm: {
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
mulf_init: {
    .label sqr1_hi = 6
    .label sqr = 8
    .label sqr1_lo = 4
    .label x_2 = 2
    .label sqr2_hi = 6
    .label sqr2_lo = 4
    .label dir = 2
    lda #0
    sta x_2
    lda #<mulf_sqr1_hi+1
    sta sqr1_hi
    lda #>mulf_sqr1_hi+1
    sta sqr1_hi+1
    lda #<mulf_sqr1_lo+1
    sta sqr1_lo
    lda #>mulf_sqr1_lo+1
    sta sqr1_lo+1
    lda #<0
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
    cmp #>mulf_sqr1_lo+$200
    bne b1
    lda sqr1_lo
    cmp #<mulf_sqr1_lo+$200
    bne b1
    lda #$ff
    sta dir
    lda #<mulf_sqr2_hi
    sta sqr2_hi
    lda #>mulf_sqr2_hi
    sta sqr2_hi+1
    lda #<mulf_sqr2_lo
    sta sqr2_lo
    lda #>mulf_sqr2_lo
    sta sqr2_lo+1
    ldx #-1
  b3:
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
    bne b4
    lda #1
    sta dir
  b4:
    inc sqr2_lo
    bne !+
    inc sqr2_lo+1
  !:
    lda sqr2_lo+1
    cmp #>mulf_sqr2_lo+$1ff
    bne b3
    lda sqr2_lo
    cmp #<mulf_sqr2_lo+$1ff
    bne b3
    lda mulf_sqr1_lo+$100
    sta mulf_sqr2_lo+$1ff
    lda mulf_sqr1_hi+$100
    sta mulf_sqr2_hi+$1ff
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
  print_hextab: .text "0123456789abcdef"
  .align $100
  mulf_sqr1_lo: .fill $200, 0
  .align $100
  mulf_sqr1_hi: .fill $200, 0
  .align $100
  mulf_sqr2_lo: .fill $200, 0
  .align $100
  mulf_sqr2_hi: .fill $200, 0
  .align $100
  mula_sqr1_lo: .fill $200, 0
  .align $100
  mula_sqr1_hi: .fill $200, 0
  .align $100
  mula_sqr2_lo: .fill $200, 0
  .align $100
  mula_sqr2_hi: .fill $200, 0
