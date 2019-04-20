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
  .label print_char_cursor = 5
  .label print_line_cursor = 2
// Initialize some points and print them
main: {
    jsr init_points
    jsr print_points
    rts
}
// Print points
print_points: {
    .label pointXpos1__0 = 9
    .label pointYpos1_return = 9
    jsr print_cls
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    ldx #0
  b1:
    txa
    asl
    clc
    adc #<points
    sta pointXpos1__0
    lda #>points
    adc #0
    sta pointXpos1__0+1
    ldy #0
    lda (pointXpos1__0),y
    sta print_byte.b
    jsr print_byte
    jsr print_str
    inc pointYpos1_return
    bne !+
    inc pointYpos1_return+1
  !:
    ldy #0
    lda (pointYpos1_return),y
    sta print_byte.b
    jsr print_byte
    jsr print_ln
    inx
    cpx #NUM_POINTS-1+1
    bne b7
    rts
  b7:
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jmp b1
    str: .text " @"
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
// Print a byte as HEX
// print_byte(byte zeropage(4) b)
print_byte: {
    .label b = 4
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
// Print a zero-terminated string
// print_str(byte* zeropage(7) str)
print_str: {
    .label str = 7
    lda #<print_points.str
    sta str
    lda #>print_points.str
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
// Initialize points
init_points: {
    .label pointXpos1__0 = 2
    .label pointYpos1_return = 2
    .label i = 4
    ldx #$a
    lda #0
    sta i
  b1:
    lda i
    asl
    clc
    adc #<points
    sta pointXpos1__0
    lda #>points
    adc #0
    sta pointXpos1__0+1
    txa
    ldy #0
    sta (pointXpos1__0),y
    txa
    axs #-[$a]
    inc pointYpos1_return
    bne !+
    inc pointYpos1_return+1
  !:
    txa
    ldy #0
    sta (pointYpos1_return),y
    txa
    axs #-[$a]
    inc i
    lda #NUM_POINTS-1+1
    cmp i
    bne b1
    rts
}
  print_hextab: .text "0123456789abcdef"
  // All points
  points: .fill NUM_POINTS*SIZEOF_POINT, 0
