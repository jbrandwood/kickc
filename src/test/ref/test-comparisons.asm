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
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    lda #0
    sta i
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #7
    sta a
  b1:
    lda #$ce
    sec
    sbc a
    sta b
    lda a
    cmp b
    bcs b22
    ldx #'+'
    jmp b2
  b22:
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
    bcs b23
    ldx #'+'
    jmp b3
  b23:
    ldx #'-'
  b3:
    lda #$37
    sta printu.b
    lda #<op
    sta printu.op
    lda #>op
    sta printu.op+1
    jsr printu
    lda a
    ldy i
    cmp cs,y
    bcs b24
    ldx #'+'
    jmp b4
  b24:
    ldx #'-'
  b4:
    ldy i
    lda cs,y
    sta printu.b
    lda #<op
    sta printu.op
    lda #>op
    sta printu.op+1
    jsr printu
    lda a
    cmp a
    bcs b25
    ldx #'+'
    jmp b5
  b25:
    ldx #'-'
  b5:
    lda a
    sta printu.b
    lda #<op
    sta printu.op
    lda #>op
    sta printu.op+1
    jsr printu
    jsr print_ln
    lda b
    cmp a
    bcs b26
    ldx #'+'
    jmp b6
  b26:
    ldx #'-'
  b6:
    lda b
    sta printu.b
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<op4
    sta printu.op
    lda #>op4
    sta printu.op+1
    jsr printu
    lda a
    cmp #$37+1
    bcc b27
    ldx #'+'
    jmp b7
  b27:
    ldx #'-'
  b7:
    lda #$37
    sta printu.b
    lda #<op4
    sta printu.op
    lda #>op4
    sta printu.op+1
    jsr printu
    ldy i
    lda cs,y
    cmp a
    bcs b28
    ldx #'+'
    jmp b8
  b28:
    ldx #'-'
  b8:
    ldy i
    lda cs,y
    sta printu.b
    lda #<op4
    sta printu.op
    lda #>op4
    sta printu.op+1
    jsr printu
    lda a
    cmp a
    bcs b29
    ldx #'+'
    jmp b9
  b29:
    ldx #'-'
  b9:
    lda a
    sta printu.b
    lda #<op4
    sta printu.op
    lda #>op4
    sta printu.op+1
    jsr printu
    jsr print_ln
    lda b
    cmp a
    bcc b30
    ldx #'+'
    jmp b10
  b30:
    ldx #'-'
  b10:
    lda b
    sta printu.b
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<op8
    sta printu.op
    lda #>op8
    sta printu.op+1
    jsr printu
    lda a
    cmp #$37+1
    bcs b31
    ldx #'+'
    jmp b11
  b31:
    ldx #'-'
  b11:
    lda #$37
    sta printu.b
    lda #<op8
    sta printu.op
    lda #>op8
    sta printu.op+1
    jsr printu
    ldy i
    lda cs,y
    cmp a
    bcc b32
    ldx #'+'
    jmp b12
  b32:
    ldx #'-'
  b12:
    ldy i
    lda cs,y
    sta printu.b
    lda #<op8
    sta printu.op
    lda #>op8
    sta printu.op+1
    jsr printu
    lda a
    cmp a
    bcc b33
    ldx #'+'
    jmp b13
  b33:
    ldx #'-'
  b13:
    lda a
    sta printu.b
    lda #<op8
    sta printu.op
    lda #>op8
    sta printu.op+1
    jsr printu
    jsr print_ln
    lda a
    cmp b
    bcc b34
    ldx #'+'
    jmp b14
  b34:
    ldx #'-'
  b14:
    lda b
    sta printu.b
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<op12
    sta printu.op
    lda #>op12
    sta printu.op+1
    jsr printu
    lda a
    cmp #$37
    bcc b35
    ldx #'+'
    jmp b15
  b35:
    ldx #'-'
  b15:
    lda #$37
    sta printu.b
    lda #<op12
    sta printu.op
    lda #>op12
    sta printu.op+1
    jsr printu
    lda a
    ldy i
    cmp cs,y
    bcc b36
    ldx #'+'
    jmp b16
  b36:
    ldx #'-'
  b16:
    ldy i
    lda cs,y
    sta printu.b
    lda #<op12
    sta printu.op
    lda #>op12
    sta printu.op+1
    jsr printu
    lda a
    cmp a
    bcc b37
    ldx #'+'
    jmp b17
  b37:
    ldx #'-'
  b17:
    lda a
    sta printu.b
    lda #<op12
    sta printu.op
    lda #>op12
    sta printu.op+1
    jsr printu
    jsr print_ln
    lda a
    cmp b
    bne b38
    ldx #'+'
    jmp b18
  b38:
    ldx #'-'
  b18:
    lda b
    sta printu.b
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<op16
    sta printu.op
    lda #>op16
    sta printu.op+1
    jsr printu
    lda #$37
    cmp a
    bne b39
    ldx #'+'
    jmp b19
  b39:
    ldx #'-'
  b19:
    lda #$37
    sta printu.b
    lda #<op16
    sta printu.op
    lda #>op16
    sta printu.op+1
    jsr printu
    lda a
    ldy i
    cmp cs,y
    bne b40
    ldx #'+'
    jmp b20
  b40:
    ldx #'-'
  b20:
    ldy i
    lda cs,y
    sta printu.b
    lda #<op16
    sta printu.op
    lda #>op16
    sta printu.op+1
    jsr printu
    lda a
    cmp a
    bne b41
    ldx #'+'
    jmp b21
  b41:
    ldx #'-'
  b21:
    lda a
    sta printu.b
    lda #<op16
    sta printu.op
    lda #>op16
    sta printu.op+1
    jsr printu
    jsr print_ln
    lax a
    axs #-[$30]
    stx a
    inc i
    lda #5
    cmp i
    bne b68
  b42:
    jmp b42
  b68:
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jmp b1
    op: .text "< @"
    op4: .text "> @"
    op8: .text "<=@"
    op12: .text ">=@"
    op16: .text "==@"
    cs: .byte 7, $c7, $37, $97, $67
}
// Print a newline
print_ln: {
  b1:
    lda #$28
    clc
    adc print_line_cursor
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
// printu(byte zeropage(2) a, byte[] zeropage(4) op, byte zeropage(6) b, byte register(X) res)
printu: {
    .label a = 2
    .label b = 6
    .label op = 4
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
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    rts
}
// Print a byte as HEX
// print_byte(byte zeropage(9) b)
print_byte: {
    .label b = 9
    lda b
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    jsr print_char
    lda #$f
    and b
    tay
    lda print_hextab,y
    jsr print_char
    rts
}
// Print a zero-terminated string
// print_str(byte* zeropage(4) str)
print_str: {
    .label str = 4
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
    sta dst
    lda #>str
    sta dst+1
  b1:
    lda dst+1
    cmp #>end
    bne b2
    lda dst
    cmp #<end
    bne b2
    rts
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    jmp b1
}
  print_hextab: .text "0123456789abcdef"
