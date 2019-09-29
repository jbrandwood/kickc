.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label print_char_cursor = 7
  .label print_line_cursor = $a
main: {
    .label b = $c
    .label a = 2
    .label i = 3
    jsr print_cls
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    lda #0
    sta.z i
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #7
    sta.z a
  __b1:
    lda #$ce
    sec
    sbc.z a
    sta.z b
    lda.z a
    cmp.z b
    bcs b1
    ldx #'+'
    jmp __b2
  b1:
    ldx #'-'
  __b2:
    lda.z b
    sta.z printu.b
    lda #<op
    sta.z printu.op
    lda #>op
    sta.z printu.op+1
    jsr printu
    lda.z a
    cmp #$37
    bcs b2
    ldx #'+'
    jmp __b3
  b2:
    ldx #'-'
  __b3:
    lda #$37
    sta.z printu.b
    lda #<op
    sta.z printu.op
    lda #>op
    sta.z printu.op+1
    jsr printu
    lda.z a
    ldy.z i
    cmp cs,y
    bcs b3
    ldx #'+'
    jmp __b4
  b3:
    ldx #'-'
  __b4:
    ldy.z i
    lda cs,y
    sta.z printu.b
    lda #<op
    sta.z printu.op
    lda #>op
    sta.z printu.op+1
    jsr printu
    lda.z a
    cmp.z a
    bcs b4
    ldx #'+'
    jmp __b5
  b4:
    ldx #'-'
  __b5:
    lda.z a
    sta.z printu.b
    lda #<op
    sta.z printu.op
    lda #>op
    sta.z printu.op+1
    jsr printu
    jsr print_ln
    lda.z b
    cmp.z a
    bcs b5
    ldx #'+'
    jmp __b6
  b5:
    ldx #'-'
  __b6:
    lda.z b
    sta.z printu.b
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #<op4
    sta.z printu.op
    lda #>op4
    sta.z printu.op+1
    jsr printu
    lda.z a
    cmp #$37+1
    bcc b6
    ldx #'+'
    jmp __b7
  b6:
    ldx #'-'
  __b7:
    lda #$37
    sta.z printu.b
    lda #<op4
    sta.z printu.op
    lda #>op4
    sta.z printu.op+1
    jsr printu
    ldy.z i
    lda cs,y
    cmp.z a
    bcs b7
    ldx #'+'
    jmp __b8
  b7:
    ldx #'-'
  __b8:
    ldy.z i
    lda cs,y
    sta.z printu.b
    lda #<op4
    sta.z printu.op
    lda #>op4
    sta.z printu.op+1
    jsr printu
    lda.z a
    cmp.z a
    bcs b8
    ldx #'+'
    jmp __b9
  b8:
    ldx #'-'
  __b9:
    lda.z a
    sta.z printu.b
    lda #<op4
    sta.z printu.op
    lda #>op4
    sta.z printu.op+1
    jsr printu
    jsr print_ln
    lda.z b
    cmp.z a
    bcc b9
    ldx #'+'
    jmp __b10
  b9:
    ldx #'-'
  __b10:
    lda.z b
    sta.z printu.b
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #<op8
    sta.z printu.op
    lda #>op8
    sta.z printu.op+1
    jsr printu
    lda.z a
    cmp #$37+1
    bcs b10
    ldx #'+'
    jmp __b11
  b10:
    ldx #'-'
  __b11:
    lda #$37
    sta.z printu.b
    lda #<op8
    sta.z printu.op
    lda #>op8
    sta.z printu.op+1
    jsr printu
    ldy.z i
    lda cs,y
    cmp.z a
    bcc b11
    ldx #'+'
    jmp __b12
  b11:
    ldx #'-'
  __b12:
    ldy.z i
    lda cs,y
    sta.z printu.b
    lda #<op8
    sta.z printu.op
    lda #>op8
    sta.z printu.op+1
    jsr printu
    lda.z a
    cmp.z a
    bcc b12
    ldx #'+'
    jmp __b13
  b12:
    ldx #'-'
  __b13:
    lda.z a
    sta.z printu.b
    lda #<op8
    sta.z printu.op
    lda #>op8
    sta.z printu.op+1
    jsr printu
    jsr print_ln
    lda.z a
    cmp.z b
    bcc b13
    ldx #'+'
    jmp __b14
  b13:
    ldx #'-'
  __b14:
    lda.z b
    sta.z printu.b
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #<op12
    sta.z printu.op
    lda #>op12
    sta.z printu.op+1
    jsr printu
    lda.z a
    cmp #$37
    bcc b14
    ldx #'+'
    jmp __b15
  b14:
    ldx #'-'
  __b15:
    lda #$37
    sta.z printu.b
    lda #<op12
    sta.z printu.op
    lda #>op12
    sta.z printu.op+1
    jsr printu
    lda.z a
    ldy.z i
    cmp cs,y
    bcc b15
    ldx #'+'
    jmp __b16
  b15:
    ldx #'-'
  __b16:
    ldy.z i
    lda cs,y
    sta.z printu.b
    lda #<op12
    sta.z printu.op
    lda #>op12
    sta.z printu.op+1
    jsr printu
    lda.z a
    cmp.z a
    bcc b16
    ldx #'+'
    jmp __b17
  b16:
    ldx #'-'
  __b17:
    lda.z a
    sta.z printu.b
    lda #<op12
    sta.z printu.op
    lda #>op12
    sta.z printu.op+1
    jsr printu
    jsr print_ln
    lda.z a
    cmp.z b
    bne b17
    ldx #'+'
    jmp __b18
  b17:
    ldx #'-'
  __b18:
    lda.z b
    sta.z printu.b
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #<op16
    sta.z printu.op
    lda #>op16
    sta.z printu.op+1
    jsr printu
    lda #$37
    cmp.z a
    bne b18
    ldx #'+'
    jmp __b19
  b18:
    ldx #'-'
  __b19:
    lda #$37
    sta.z printu.b
    lda #<op16
    sta.z printu.op
    lda #>op16
    sta.z printu.op+1
    jsr printu
    lda.z a
    ldy.z i
    cmp cs,y
    bne b19
    ldx #'+'
    jmp __b20
  b19:
    ldx #'-'
  __b20:
    ldy.z i
    lda cs,y
    sta.z printu.b
    lda #<op16
    sta.z printu.op
    lda #>op16
    sta.z printu.op+1
    jsr printu
    lda.z a
    cmp.z a
    bne b20
    ldx #'+'
    jmp __b21
  b20:
    ldx #'-'
  __b21:
    lda.z a
    sta.z printu.b
    lda #<op16
    sta.z printu.op
    lda #>op16
    sta.z printu.op+1
    jsr printu
    jsr print_ln
    lax.z a
    axs #-[$30]
    stx.z a
    inc.z i
    lda #5
    cmp.z i
    bne __b68
  __b42:
    jmp __b42
  __b68:
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    jmp __b1
    op: .text "< "
    .byte 0
    op4: .text "> "
    .byte 0
    op8: .text "<="
    .byte 0
    op12: .text ">="
    .byte 0
    op16: .text "=="
    .byte 0
    cs: .byte 7, $c7, $37, $97, $67
}
// Print a newline
print_ln: {
  __b1:
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    rts
}
// printu(byte zeropage(2) a, byte[] zeropage(4) op, byte zeropage(6) b, byte register(X) res)
printu: {
    .label a = 2
    .label b = 6
    .label op = 4
    lda #' '
    jsr print_char
    lda.z a
    sta.z print_byte.b
    jsr print_byte
    jsr print_str
    lda.z b
    sta.z print_byte.b
    jsr print_byte
    lda #' '
    jsr print_char
    txa
    jsr print_char
    rts
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    rts
}
// Print a byte as HEX
// print_byte(byte zeropage(9) b)
print_byte: {
    .label b = 9
    lda.z b
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    jsr print_char
    lda #$f
    and.z b
    tay
    lda print_hextab,y
    jsr print_char
    rts
}
// Print a zero-terminated string
// print_str(byte* zeropage(4) str)
print_str: {
    .label str = 4
  __b1:
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    rts
  __b2:
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = $400
    .label end = str+num
    .label dst = $a
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    rts
  __b2:
    lda #c
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
  print_hextab: .text "0123456789abcdef"
