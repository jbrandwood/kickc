.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label char_cursor = 7
  .label line_cursor = 3
  .label rem16u = 3
  jsr main
main: {
    .label i = 2
    lda #<lintab1
    sta lin16u_gen.lintab
    lda #>lintab1
    sta lin16u_gen.lintab+1
    lda #<0
    sta rem16u
    sta rem16u+1
    lda #<$14
    sta lin16u_gen.length
    lda #>$14
    sta lin16u_gen.length+1
    lda #<$22d
    sta lin16u_gen.min
    lda #>$22d
    sta lin16u_gen.min+1
    lda #<$7461
    sta lin16u_gen.max
    lda #>$7461
    sta lin16u_gen.max+1
    jsr lin16u_gen
    lda #<lintab2
    sta lin16u_gen.lintab
    lda #>lintab2
    sta lin16u_gen.lintab+1
    lda #<$14
    sta lin16u_gen.length
    lda #>$14
    sta lin16u_gen.length+1
    lda #<$79cb
    sta lin16u_gen.min
    lda #>$79cb
    sta lin16u_gen.min+1
    lda #<$f781
    sta lin16u_gen.max
    lda #>$f781
    sta lin16u_gen.max+1
    jsr lin16u_gen
    jsr print_cls
    lda #<SCREEN
    sta char_cursor
    lda #>SCREEN
    sta char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda #<$22d
    sta print_word.w
    lda #>$22d
    sta print_word.w+1
    jsr print_word
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda #<$79cb
    sta print_word.w
    lda #>$79cb
    sta print_word.w+1
    jsr print_word
    lda #<SCREEN
    sta line_cursor
    lda #>SCREEN
    sta line_cursor+1
    jsr print_ln
    lda #0
    sta i
  b1:
    ldx i
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    jsr print_byte
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    ldy i
    lda lintab1,y
    sta print_word.w
    lda lintab1+1,y
    sta print_word.w+1
    jsr print_word
    lda #<str3
    sta print_str.str
    lda #>str3
    sta print_str.str+1
    jsr print_str
    ldy i
    lda lintab2,y
    sta print_word.w
    lda lintab2+1,y
    sta print_word.w+1
    jsr print_word
    jsr print_ln
    lda #2
    clc
    adc i
    sta i
    cmp #$14*2
    bcc b1
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    lda #<str4
    sta print_str.str
    lda #>str4
    sta print_str.str+1
    jsr print_str
    lda #<$7461
    sta print_word.w
    lda #>$7461
    sta print_word.w+1
    jsr print_word
    lda #<str5
    sta print_str.str
    lda #>str5
    sta print_str.str+1
    jsr print_str
    lda #<$f781
    sta print_word.w
    lda #>$f781
    sta print_word.w+1
    jsr print_word
    jsr print_ln
    rts
    str: .text "   @"
    str1: .text " @"
    str2: .text " @"
    str3: .text " @"
    str4: .text "   @"
    str5: .text " @"
    lintab1: .fill $28, 0
    lintab2: .fill $28, 0
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
print_word: {
    .label w = 5
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
print_str: {
    .label str = 5
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
    .label sc = 3
    lda #<SCREEN
    sta sc
    lda #>SCREEN
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
    cmp #>SCREEN+$3e8
    bne b1
    lda sc
    cmp #<SCREEN+$3e8
    bne b1
    rts
}
lin16u_gen: {
    .label _5 = $f
    .label ampl = 3
    .label stepi = $15
    .label stepf = $13
    .label step = $17
    .label val = 9
    .label lintab = $d
    .label i = 5
    .label max = 3
    .label min = 5
    .label length = 7
    lda ampl
    sec
    sbc min
    sta ampl
    lda ampl+1
    sbc min+1
    sta ampl+1
    lda length
    sec
    sbc #1
    sta divr16u.divisor
    lda length+1
    sbc #0
    sta divr16u.divisor+1
    lda ampl
    sta divr16u.dividend
    lda ampl+1
    sta divr16u.dividend+1
    lda #<0
    sta divr16u.rem
    sta divr16u.rem+1
    jsr divr16u
    lda divr16u.return
    sta stepi
    lda divr16u.return+1
    sta stepi+1
    lda length
    sec
    sbc #1
    sta divr16u.divisor
    lda length+1
    sbc #0
    sta divr16u.divisor+1
    lda #<0
    sta divr16u.dividend
    sta divr16u.dividend+1
    jsr divr16u
    lda stepi
    sta step+2
    lda stepi+1
    sta step+3
    lda stepf
    sta step
    lda stepf+1
    sta step+1
    lda #<0
    sta val
    sta val+1
    lda min
    sta val+2
    lda min+1
    sta val+3
    lda #<0
    sta i
    sta i+1
  b1:
    lda val+2
    sta _5
    lda val+3
    sta _5+1
    ldy #0
    lda _5
    sta (lintab),y
    iny
    lda _5+1
    sta (lintab),y
    lda val
    clc
    adc step
    sta val
    lda val+1
    adc step+1
    sta val+1
    lda val+2
    adc step+2
    sta val+2
    lda val+3
    adc step+3
    sta val+3
    clc
    lda lintab
    adc #<2
    sta lintab
    lda lintab+1
    adc #>2
    sta lintab+1
    inc i
    bne !+
    inc i+1
  !:
    lda i+1
    cmp length+1
    bcc b1
    bne !+
    lda i
    cmp length
    bcc b1
  !:
    rts
}
divr16u: {
    .label rem = 3
    .label dividend = $11
    .label quotient = $13
    .label return = $13
    .label divisor = $f
    ldx #0
    txa
    sta quotient
    sta quotient+1
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
    cmp divisor+1
    bcc b3
    bne !+
    lda rem
    cmp divisor
    bcc b3
  !:
    inc quotient
    bne !+
    inc quotient+1
  !:
    lda rem
    sec
    sbc divisor
    sta rem
    lda rem+1
    sbc divisor+1
    sta rem+1
  b3:
    inx
    cpx #$10
    bne b1
    rts
}
