.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
  .label print_char_cursor = $e
  .label print_line_cursor = 6
  jsr main
main: {
    lda #5
    sta BGCOL
    jsr print_cls
    jsr mulf_init
    jsr mul16u_compare
    jsr mul16s_compare
    rts
}
mul16s_compare: {
    .label a = 2
    .label b = 4
    .label ms = $a
    .label mn = $10
    ldx #0
    lda #<-$7fff
    sta b
    lda #>-$7fff
    sta b+1
    lda #<-$7fff
    sta a
    lda #>-$7fff
    sta a+1
  b1:
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
    beq b5
  !:
    lda #0
    jmp b3
  b5:
    lda #1
  b3:
    cmp #0
    bne b4
    lda #2
    sta BGCOL
    jsr mul16s_error
  breturn:
    rts
  b4:
    iny
    cpy #$10
    bne b2
    inx
    cpx #$10
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
    str: .text "signed word multiply results match!@"
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
mul16s_error: {
    .label a = 2
    .label b = 4
    .label ms = $a
    .label mn = $10
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
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
    jsr print_ln
    rts
    str: .text "signed word multiply mismatch @"
    str1: .text "*@"
    str2: .text " slow:@"
    str3: .text " / normal:@"
}
print_sdword: {
    .label dw = $a
    lda dw+3
    bpl b1
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
  b1:
    jsr print_dword
    rts
}
print_dword: {
    .label dw = $a
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
print_word: {
    .label w = 2
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
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    rts
}
print_sword: {
    .label w = 2
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
mul16s: {
    .label _6 = 8
    .label _12 = 8
    .label _16 = 8
    .label _17 = 8
    .label m = $10
    .label return = $10
    .label a = 2
    .label b = 4
    lda b
    sta mul16u.b
    lda b+1
    sta mul16u.b+1
    lda a
    sta mul16u.a
    lda a+1
    sta mul16u.a+1
    jsr mul16u
    lda a+1
    bpl b1
    lda m+2
    sta _6
    lda m+3
    sta _6+1
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
    sta _12
    lda m+3
    sta _12+1
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
mul16u: {
    .label mb = $16
    .label a = 8
    .label res = $10
    .label return = $10
    .label b = $14
    lda b
    sta mb
    lda b+1
    sta mb+1
    lda #0
    sta mb+2
    sta mb+3
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
    beq b4
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
  b4:
    clc
    ror a+1
    ror a
    asl mb
    rol mb+1
    rol mb+2
    rol mb+3
    jmp b1
}
muls16s: {
    .label m = $a
    .label i = 8
    .label return = $a
    .label j = 8
    .label a = 2
    .label b = 4
    lda a+1
    bpl b1
    lda #<0
    sta i
    sta i+1
    sta m
    sta m+1
    lda #<0>>$10
    sta m+2
    lda #>0>>$10
    sta m+3
  b2:
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
    lda i+1
    cmp a+1
    bne b2
    lda i
    cmp a
    bne b2
    jmp b3
  b6:
    lda #<0
    sta return
    sta return+1
    lda #<0>>$10
    sta return+2
    lda #>0>>$10
    sta return+3
  b3:
    rts
  b1:
    lda a+1
    bmi b6
    bne !+
    lda a
    beq b6
  !:
    lda #<0
    sta j
    sta j+1
    sta m
    sta m+1
    lda #<0>>$10
    sta m+2
    lda #>0>>$10
    sta m+3
  b5:
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
    lda j+1
    cmp a+1
    bne b5
    lda j
    cmp a
    bne b5
    jmp b3
}
mul16u_compare: {
    .label a = 2
    .label b = $14
    .label ms = $a
    .label mn = $10
    ldx #0
    txa
    sta b
    sta b+1
    sta a
    sta a+1
  b1:
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
    jsr mul16u
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
    beq b5
  !:
    lda #0
    jmp b3
  b5:
    lda #1
  b3:
    cmp #0
    bne b4
    lda #2
    sta BGCOL
    jsr mul16u_error
  breturn:
    rts
  b4:
    iny
    cpy #$10
    bne b2
    inx
    cpx #$10
    bne b1
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
    jmp breturn
    str: .text "word multiply results match!@"
}
mul16u_error: {
    .label a = 2
    .label b = $14
    .label ms = $a
    .label mn = $10
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
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    jsr print_ln
    rts
    str: .text "word multiply mismatch @"
    str1: .text "*@"
    str2: .text " slow:@"
    str3: .text " / normal:@"
}
muls16u: {
    .label return = $a
    .label m = $a
    .label i = 4
    .label a = 2
    .label b = $14
    lda a
    bne !+
    lda a+1
    beq b3
  !:
    lda #<0
    sta i
    sta i+1
    sta m
    sta m+1
    sta m+2
    sta m+3
  b2:
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
    lda i+1
    cmp a+1
    bne b2
    lda i
    cmp a
    bne b2
    jmp b1
  b3:
    lda #0
    sta return
    sta return+1
    sta return+2
    sta return+3
  b1:
    rts
}
mulf_init: {
    .label sqr1_hi = 4
    .label sqr = 6
    .label sqr1_lo = 2
    .label x_2 = $1a
    .label sqr2_hi = 4
    .label sqr2_lo = 2
    .label dir = $1a
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
  .align $100
  mulf_sqr1_lo: .fill $200, 0
  .align $100
  mulf_sqr1_hi: .fill $200, 0
  .align $100
  mulf_sqr2_lo: .fill $200, 0
  .align $100
  mulf_sqr2_hi: .fill $200, 0
