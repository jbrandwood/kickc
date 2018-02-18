.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label char_cursor = 5
  .label line_cursor = 3
  .label rem16u = 5
  jsr main
main: {
    .label i = 2
    jsr lin16u_gen
    jsr print_cls
    lda #<SCREEN
    sta line_cursor
    lda #>SCREEN
    sta line_cursor+1
    lda #<SCREEN
    sta char_cursor
    lda #>SCREEN
    sta char_cursor+1
    lda #0
    sta i
  b1:
    ldx i
    jsr print_byte
    jsr print_str
    ldy i
    lda lintab,y
    sta print_word.w
    lda lintab+1,y
    sta print_word.w+1
    jsr print_word
    jsr print_ln
    lda #2
    clc
    adc i
    sta i
    cmp #$14*2
    bcc b9
    rts
  b9:
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    jmp b1
    str: .text " @"
    lintab: .fill $28, 0
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
    .label w = 7
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
    .label str = 7
    lda #<main.str
    sta str
    lda #>main.str
    sta str+1
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
    .const min = $22d
    .const max = $7461
    .label length = $14
    .label ampl = max-min
    .label _5 = 7
    .label stepi = $f
    .label stepf = $d
    .label step = $11
    .label val = 9
    .label lintab = 3
    .label i = 5
    jsr div16u
    lda div16u.return
    sta stepi
    lda div16u.return+1
    sta stepi+1
    lda #<length-1
    sta divr16u.divisor
    lda #>length-1
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
    sta i
    sta i+1
    lda #<main.lintab
    sta lintab
    lda #>main.lintab
    sta lintab+1
    lda #<min*$10000+0
    sta val
    lda #>min*$10000+0
    sta val+1
    lda #<min*$10000+0>>$10
    sta val+2
    lda #>min*$10000+0>>$10
    sta val+3
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
    cmp #>length
    bcc b1
    bne !+
    lda i
    cmp #<length
    bcc b1
  !:
    rts
}
divr16u: {
    .label return = $d
    .label rem = 5
    .label dividend = 7
    .label quotient = $d
    .label divisor = 3
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
    inc rem
    bne !+
    inc rem+1
  !:
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
div16u: {
    .label divisor = lin16u_gen.length-1
    .label return = $d
    lda #<divisor
    sta divr16u.divisor
    lda #>divisor
    sta divr16u.divisor+1
    lda #<lin16u_gen.ampl
    sta divr16u.dividend
    lda #>lin16u_gen.ampl
    sta divr16u.dividend+1
    lda #<0
    sta divr16u.rem
    sta divr16u.rem+1
    jsr divr16u
    rts
}
