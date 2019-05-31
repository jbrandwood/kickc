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
  .label print_line_cursor = 3
// Initialize some points and print them
main: {
    jsr init_points
    jsr print_points
    rts
}
// Print points
print_points: {
    .label point = $c
    .label i = 2
    jsr print_cls
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #0
    sta i
  b1:
    lda i
    asl
    tay
    tya
    clc
    adc #<points
    sta point
    lda #>points
    adc #0
    sta point+1
    ldx points,y
    jsr print_byte
    jsr print_str
    ldy #1
    lda (point),y
    tax
    jsr print_byte
    jsr print_ln
    inc i
    lda #NUM_POINTS-1+1
    cmp i
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
    .label sc = 9
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
    .label getPoint1_return = $e
    .label pos = $b
    lda #$a
    sta pos
    ldx #0
  b1:
    txa
    asl
    tay
    tya
    clc
    adc #<points
    sta getPoint1_return
    lda #>points
    adc #0
    sta getPoint1_return+1
    lda pos
    sta points,y
    lda #$a
    clc
    adc pos
    ldy #1
    sta (getPoint1_return),y
    clc
    adc #$a
    sta pos
    inx
    cpx #NUM_POINTS-1+1
    bne b1
    rts
}
  print_hextab: .text "0123456789abcdef"
  // All points
  points: .fill NUM_POINTS*SIZEOF_POINT, 0
