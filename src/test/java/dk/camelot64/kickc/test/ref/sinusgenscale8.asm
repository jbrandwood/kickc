.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const PI2_u4f12 = $6488
  .const PI_u4f12 = $3244
  .const PI_HALF_u4f12 = $1922
  .label print_char_cursor = $d
  .label print_line_cursor = 8
  jsr main
main: {
    .label tabsize = $14
    jsr print_cls
    jsr sin8u_table
    rts
    sintab: .fill $14, 0
}
sin8u_table: {
    .const min = $a
    .const max = $ff
    .label amplitude = max-min
    .const sum = min+max
    .const mid = (sum>>1)+1
    .label step = $12
    .label sinx = $11
    .label sinx_sc = $f
    .label sintab = 4
    .label x = 2
    .label i = 6
    jsr div16u
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda step
    sta print_word.w
    lda step+1
    sta print_word.w+1
    jsr print_word
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda #min
    sta print_byte.b
    jsr print_byte
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    lda #max
    sta print_byte.b
    jsr print_byte
    lda #<str3
    sta print_str.str
    lda #>str3
    sta print_str.str+1
    jsr print_str
    lda #amplitude
    sta print_byte.b
    jsr print_byte
    lda #<str4
    sta print_str.str
    lda #>str4
    sta print_str.str+1
    jsr print_str
    lda #mid
    sta print_byte.b
    jsr print_byte
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    jsr print_ln
    lda #<0
    sta i
    sta i+1
    lda #<main.sintab
    sta sintab
    lda #>main.sintab
    sta sintab+1
    lda #<0
    sta x
    sta x+1
  b1:
    lda x
    sta sin8s.x
    lda x+1
    sta sin8s.x+1
    jsr sin8s
    sta sinx
    tay
    jsr mul8su
    lda sinx_sc+1
    clc
    adc #mid
    tax
    txa
    ldy #0
    sta (sintab),y
    inc sintab
    bne !+
    inc sintab+1
  !:
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str5
    sta print_str.str
    lda #>str5
    sta print_str.str+1
    jsr print_str
    lda x
    sta print_word.w
    lda x+1
    sta print_word.w+1
    jsr print_word
    lda #<str6
    sta print_str.str
    lda #>str6
    sta print_str.str+1
    jsr print_str
    lda sinx
    sta print_sbyte.b
    jsr print_sbyte
    lda #<str7
    sta print_str.str
    lda #>str7
    sta print_str.str+1
    jsr print_str
    lda sinx_sc
    sta print_sword.w
    lda sinx_sc+1
    sta print_sword.w+1
    jsr print_sword
    lda #<str8
    sta print_str.str
    lda #>str8
    sta print_str.str+1
    jsr print_str
    stx print_byte.b
    jsr print_byte
    jsr print_ln
    lda x
    clc
    adc step
    sta x
    lda x+1
    adc step+1
    sta x+1
    inc i
    bne !+
    inc i+1
  !:
    lda i+1
    cmp #>main.tabsize
    bcs !b1+
    jmp b1
  !b1:
    bne !+
    lda i
    cmp #<main.tabsize
    bcs !b1+
    jmp b1
  !b1:
  !:
    rts
    str: .text "step:@"
    str1: .text " min:@"
    str2: .text " max:@"
    str3: .text " ampl:@"
    str4: .text " mid:@"
    str5: .text "x: @"
    str6: .text " sin: @"
    str7: .text " scaled: @"
    str8: .text " trans: @"
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
print_byte: {
    .label b = $a
    lda b
    lsr
    lsr
    lsr
    lsr
    tay
    lda hextab,y
    jsr print_char
    lda #$f
    and b
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
print_str: {
    .label str = $b
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
print_sword: {
    .label w = $b
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
    .label w = $b
    lda w+1
    sta print_byte.b
    jsr print_byte
    lda w
    sta print_byte.b
    jsr print_byte
    rts
}
print_sbyte: {
    .label b = $a
    lda b
    cmp #0
    bpl b1
    lda #'-'
    jsr print_char
    lda b
    eor #$ff
    clc
    adc #1
    sta b
  b1:
    jsr print_byte
    rts
}
mul8su: {
    .const b = sin8u_table.amplitude+1
    .label m = $f
    .label return = $f
    tya
    tax
    lda #b
    jsr mul8u
    cpy #0
    bpl b1
    lda m+1
    sec
    sbc #b
    sta m+1
  b1:
    rts
}
mul8u: {
    .label mb = $b
    .label res = $f
    .label return = $f
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
sin8s: {
    .const DIV_6 = $2b
    .label _6 = $b
    .label x = $b
    .label x1 = $14
    .label x3 = $15
    .label usinx = $16
    .label isUpper = $a
    lda x+1
    cmp #>PI_u4f12
    bcc b5
    bne !+
    lda x
    cmp #<PI_u4f12
    bcc b5
  !:
    lda x
    sec
    sbc #<PI_u4f12
    sta x
    lda x+1
    sbc #>PI_u4f12
    sta x+1
    lda #1
    sta isUpper
    jmp b1
  b5:
    lda #0
    sta isUpper
  b1:
    lda x+1
    cmp #>PI_HALF_u4f12
    bcc b2
    bne !+
    lda x
    cmp #<PI_HALF_u4f12
    bcc b2
  !:
    sec
    lda #<PI_u4f12
    sbc x
    sta x
    lda #>PI_u4f12
    sbc x+1
    sta x+1
  b2:
    asl _6
    rol _6+1
    asl _6
    rol _6+1
    asl _6
    rol _6+1
    lda _6+1
    sta x1
    tax
    tay
    lda #0
    sta mulu8_sel.select
    jsr mulu8_sel
    tax
    ldy x1
    lda #1
    sta mulu8_sel.select
    jsr mulu8_sel
    sta x3
    tax
    lda #1
    sta mulu8_sel.select
    ldy #DIV_6
    jsr mulu8_sel
    eor #$ff
    sec
    adc x1
    sta usinx
    ldx x3
    ldy x1
    lda #0
    sta mulu8_sel.select
    jsr mulu8_sel
    tax
    ldy x1
    lda #0
    sta mulu8_sel.select
    jsr mulu8_sel
    lsr
    lsr
    lsr
    lsr
    clc
    adc usinx
    tax
    cpx #$80
    bcc b3
    dex
  b3:
    lda isUpper
    beq b18
    txa
    eor #$ff
    clc
    adc #1
  b4:
    rts
  b18:
    txa
    jmp b4
}
mulu8_sel: {
    .label _0 = $f
    .label _1 = $f
    .label select = $11
    tya
    jsr mul8u
    ldy select
    beq !e+
  !:
    asl _1
    rol _1+1
    dey
    bne !-
  !e:
    lda _1+1
    rts
}
div16u: {
    .label return = $12
    jsr divr16u
    rts
}
divr16u: {
    .label rem = 2
    .label dividend = 4
    .label quotient = $12
    .label return = $12
    ldx #0
    txa
    sta quotient
    sta quotient+1
    lda #<PI2_u4f12
    sta dividend
    lda #>PI2_u4f12
    sta dividend+1
    txa
    sta rem
    sta rem+1
  b1:
    asl rem
    rol rem+1
    lda dividend+1
    and #$80
    cmp #0
    beq b2
    lda #1
    ora rem
    sta rem
  b2:
    asl dividend
    rol dividend+1
    asl quotient
    rol quotient+1
    lda rem+1
    cmp #>main.tabsize
    bcc b3
    bne !+
    lda rem
    cmp #<main.tabsize
    bcc b3
  !:
    inc quotient
    bne !+
    inc quotient+1
  !:
    lda rem
    sec
    sbc #<main.tabsize
    sta rem
    lda rem+1
    sbc #>main.tabsize
    sta rem+1
  b3:
    inx
    cpx #$10
    bne b1
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
