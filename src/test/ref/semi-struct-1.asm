// Implementing a semi-struct without the struct keyword by using pointer math and inline functions
//
// struct Point {
//    byte xpos; // The x-position
//    byte ypos; // The y-position
// };
// Point[NUM_POINTS] points;
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The size of a point
  .const SIZEOF_POINT = 2
  // The number of points
  .const NUM_POINTS = 4
  .label print_char_cursor = 9
  .label print_line_cursor = 4
// Initialize some points and print them
main: {
    jsr init_points
    jsr print_points
    rts
}
// Print points
print_points: {
    .label point = 7
    .label i = 6
    jsr print_cls
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #0
    sta.z i
  __b1:
    lda.z i
    asl
    tay
    tya
    clc
    adc #<points
    sta.z point
    lda #>points
    adc #0
    sta.z point+1
    ldx points,y
    jsr print_byte
    jsr print_str
    ldy #1
    lda (point),y
    tax
    jsr print_byte
    jsr print_ln
    inc.z i
    lda #NUM_POINTS-1+1
    cmp.z i
    bne __b7
    rts
  __b7:
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    jmp __b1
    str: .text " "
    .byte 0
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
// Print a byte as HEX
// print_byte(byte register(X) b)
print_byte: {
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    jsr print_char
    lda #$f
    axs #0
    lda print_hextab,x
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
// Print a zero-terminated string
// print_str(byte* zeropage(2) str)
print_str: {
    .label str = 2
    lda #<print_points.str
    sta.z str
    lda #>print_points.str
    sta.z str+1
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
    .label dst = 4
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
// Initialize points
init_points: {
    .label getPoint1_return = 9
    .label pos = 6
    lda #$a
    sta.z pos
    ldx #0
  __b1:
    txa
    asl
    tay
    tya
    clc
    adc #<points
    sta.z getPoint1_return
    lda #>points
    adc #0
    sta.z getPoint1_return+1
    lda.z pos
    sta points,y
    lda #$a
    clc
    adc.z pos
    ldy #1
    sta (getPoint1_return),y
    clc
    adc #$a
    sta.z pos
    inx
    cpx #NUM_POINTS-1+1
    bne __b1
    rts
}
  print_hextab: .text "0123456789abcdef"
  // All points
  points: .fill NUM_POINTS*SIZEOF_POINT, 0
