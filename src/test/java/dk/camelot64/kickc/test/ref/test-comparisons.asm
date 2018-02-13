.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label char_cursor = 9
  .label line_cursor = 4
  jsr main
main: {
    .label b = $c
    .label a = 2
    .label i = 3
    jsr print_cls
    lda #<SCREEN
    sta line_cursor
    lda #>SCREEN
    sta line_cursor+1
    lda #0
    sta i
    lda #<SCREEN
    sta char_cursor
    lda #>SCREEN
    sta char_cursor+1
    lda #7
    sta a
  b1:
    lda #$ce
    sec
    sbc a
    sta b
    lda a
    cmp b
    bcs b23
    ldx #'+'
    jmp b2
  b23:
    ldx #'-'
  b2:
    lda b
    sta printu.b
    lda #<op
    sta printu.op
    lda #>op
    sta printu.op+1
    jsr printu
    lda a
    cmp #$37
    bcs b24
    ldx #'+'
    jmp b3
  b24:
    ldx #'-'
  b3:
    lda #$37
    sta printu.b
    lda #<op1
    sta printu.op
    lda #>op1
    sta printu.op+1
    jsr printu
    lda a
    ldy i
    cmp cs,y
    bcs b25
    ldx #'+'
    jmp b4
  b25:
    ldx #'-'
  b4:
    ldy i
    lda cs,y
    sta printu.b
    lda #<op2
    sta printu.op
    lda #>op2
    sta printu.op+1
    jsr printu
    lda a
    cmp a
    bcs b26
    ldx #'+'
    jmp b5
  b26:
    ldx #'-'
  b5:
    lda a
    sta printu.b
    lda #<op3
    sta printu.op
    lda #>op3
    sta printu.op+1
    jsr printu
    jsr print_ln
    lda b
    cmp a
    bcs b27
    ldx #'+'
    jmp b6
  b27:
    ldx #'-'
  b6:
    lda b
    sta printu.b
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    lda #<op4
    sta printu.op
    lda #>op4
    sta printu.op+1
    jsr printu
    lda #$37
    cmp a
    bcs b28
    ldx #'+'
    jmp b7
  b28:
    ldx #'-'
  b7:
    lda #$37
    sta printu.b
    lda #<op5
    sta printu.op
    lda #>op5
    sta printu.op+1
    jsr printu
    ldy i
    lda cs,y
    cmp a
    bcs b29
    ldx #'+'
    jmp b8
  b29:
    ldx #'-'
  b8:
    ldy i
    lda cs,y
    sta printu.b
    lda #<op6
    sta printu.op
    lda #>op6
    sta printu.op+1
    jsr printu
    lda a
    cmp a
    bcs b30
    ldx #'+'
    jmp b9
  b30:
    ldx #'-'
  b9:
    lda a
    sta printu.b
    lda #<op7
    sta printu.op
    lda #>op7
    sta printu.op+1
    jsr printu
    jsr print_ln
    lda b
    cmp a
    bcc b31
    ldx #'+'
    jmp b10
  b31:
    ldx #'-'
  b10:
    lda b
    sta printu.b
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    lda #<op8
    sta printu.op
    lda #>op8
    sta printu.op+1
    jsr printu
    lda a
    cmp #$37
    beq !+
    bcs b32
  !:
    ldx #'+'
    jmp b11
  b32:
    ldx #'-'
  b11:
    lda #$37
    sta printu.b
    lda #<op9
    sta printu.op
    lda #>op9
    sta printu.op+1
    jsr printu
    ldy i
    lda cs,y
    cmp a
    bcc b33
    ldx #'+'
    jmp b12
  b33:
    ldx #'-'
  b12:
    ldy i
    lda cs,y
    sta printu.b
    lda #<op10
    sta printu.op
    lda #>op10
    sta printu.op+1
    jsr printu
    lda a
    cmp a
    bcc b34
    ldx #'+'
    jmp b13
  b34:
    ldx #'-'
  b13:
    lda a
    sta printu.b
    lda #<op11
    sta printu.op
    lda #>op11
    sta printu.op+1
    jsr printu
    jsr print_ln
    lda a
    cmp b
    bcc b35
    ldx #'+'
    jmp b14
  b35:
    ldx #'-'
  b14:
    lda b
    sta printu.b
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    lda #<op12
    sta printu.op
    lda #>op12
    sta printu.op+1
    jsr printu
    lda a
    cmp #$37
    bcc b36
    ldx #'+'
    jmp b15
  b36:
    ldx #'-'
  b15:
    lda #$37
    sta printu.b
    lda #<op13
    sta printu.op
    lda #>op13
    sta printu.op+1
    jsr printu
    lda a
    ldy i
    cmp cs,y
    bcc b37
    ldx #'+'
    jmp b16
  b37:
    ldx #'-'
  b16:
    ldy i
    lda cs,y
    sta printu.b
    lda #<op14
    sta printu.op
    lda #>op14
    sta printu.op+1
    jsr printu
    lda a
    cmp a
    bcc b38
    ldx #'+'
    jmp b17
  b38:
    ldx #'-'
  b17:
    lda a
    sta printu.b
    lda #<op15
    sta printu.op
    lda #>op15
    sta printu.op+1
    jsr printu
    jsr print_ln
    lda a
    cmp b
    bne b39
    ldx #'+'
    jmp b18
  b39:
    ldx #'-'
  b18:
    lda b
    sta printu.b
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    lda #<op16
    sta printu.op
    lda #>op16
    sta printu.op+1
    jsr printu
    lda a
    cmp #$37
    bne b40
    ldx #'+'
    jmp b19
  b40:
    ldx #'-'
  b19:
    lda #$37
    sta printu.b
    lda #<op17
    sta printu.op
    lda #>op17
    sta printu.op+1
    jsr printu
    lda a
    ldy i
    cmp cs,y
    bne b41
    ldx #'+'
    jmp b20
  b41:
    ldx #'-'
  b20:
    ldy i
    lda cs,y
    sta printu.b
    lda #<op18
    sta printu.op
    lda #>op18
    sta printu.op+1
    jsr printu
    lda a
    cmp a
    bne b42
    ldx #'+'
    jmp b21
  b42:
    ldx #'-'
  b21:
    lda a
    sta printu.b
    lda #<op19
    sta printu.op
    lda #>op19
    sta printu.op+1
    jsr printu
    jsr print_ln
    lda #$30
    clc
    adc a
    sta a
    inc i
    lda i
    cmp #5
    bne b71
  b22:
    jmp b22
  b71:
    lda line_cursor
    sta char_cursor
    lda line_cursor+1
    sta char_cursor+1
    jmp b1
    op: .text "< @"
    op1: .text "< @"
    op2: .text "< @"
    op3: .text "< @"
    op4: .text "> @"
    op5: .text "> @"
    op6: .text "> @"
    op7: .text "> @"
    op8: .text "<=@"
    op9: .text "<=@"
    op10: .text "<=@"
    op11: .text "<=@"
    op12: .text ">=@"
    op13: .text ">=@"
    op14: .text ">=@"
    op15: .text ">=@"
    op16: .text "==@"
    op17: .text "==@"
    op18: .text "==@"
    op19: .text "==@"
    cs: .byte 7, $c7, $37, $97, $67
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
printu: {
    .label a = 2
    .label b = 8
    .label op = 6
    lda #' '
    jsr print_char
    lda a
    sta print_byte.b
    jsr print_byte
    jsr print_str
    lda b
    sta print_byte.b
    jsr print_byte
    lda #' '
    jsr print_char
    txa
    jsr print_char
    rts
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
print_byte: {
    .label b = $b
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
print_cls: {
    .label sc = 4
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
