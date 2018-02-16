.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label BGCOL = $d021
  .label char_cursor = $e
  .label line_cursor = 6
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
    str: .text "signed word multiply results match!@"
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
mul16s_error: {
    .label a = 2
    .label b = 4
    .label ms = $a
    .label mn = $10
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
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
    sta (char_cursor),y
    inc char_cursor
    bne !+
    inc char_cursor+1
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
    str: .text "word multiply results match!@"
}
mul16u_error: {
    .label a = 2
    .label b = $14
    .label ms = $a
    .label mn = $10
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
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
mul8s_compare: {
    .label ms = 2
    .label mf = $14
    .label mn = 4
    .label b = $1b
    .label a = $1a
    lda #-$80
    sta a
  b1:
    lda #-$80
    sta b
  b2:
    ldx b
    jsr muls8s
    ldy a
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
mul8s_error: {
    .label b = $1b
    .label ms = 2
    .label mn = 4
    .label mf = $14
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
    .label m = 4
    .label a = $1a
    .label return = 4
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
    .label mb = 8
    .label res = 4
    .label return = 4
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
    .label m = $14
    .label b = $1b
    .label return = $14
    tya
    ldx b
    jsr mulf8u
    cpy #0
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
    sty $ff
    sec
    sbc $ff
    sta m+1
  b2:
    rts
}
mulf8u: {
    .label memA = $fe
    .label memB = $ff
    .label return = $14
    sta memA
    stx memB
    sta sm1+1
    sta sm3+1
    eor #$ff
    sta sm2+1
    sta sm4+1
    sec
  sm1:
    lda mulf_sqr1_lo,x
  sm2:
    sbc mulf_sqr2_lo,x
    sta memA
  sm3:
    lda mulf_sqr1_hi,x
  sm4:
    sbc mulf_sqr2_hi,x
    sta memB
    lda memA
    sta return
    lda memB
    sta return+1
    rts
}
muls8s: {
    .label m = 2
    .label return = 2
    .label a = $1a
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
    lda #<0
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
mul8u_compare: {
    .label ms = 2
    .label mf = $14
    .label mn = 4
    .label b = $1b
    .label a = $1a
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
    .label b = $1b
    .label ms = 2
    .label mn = 4
    .label mf = $14
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
muls8u: {
    .label return = 2
    .label m = 2
    .label a = $1a
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
    .label asm_sqr = 2
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
    lda #<SCREEN
    sta char_cursor
    lda #>SCREEN
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
    lda #<SCREEN
    sta line_cursor
    lda #>SCREEN
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
    cmp #>mulf_sqr1_lo+$200*4
    bcc b1
    bne !+
    lda kc_sqr
    cmp #<mulf_sqr1_lo+$200*4
    bcc b1
  !:
    lda #<SCREEN
    sta char_cursor
    lda #>SCREEN
    sta char_cursor+1
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    lda #<SCREEN
    sta line_cursor
    lda #>SCREEN
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
