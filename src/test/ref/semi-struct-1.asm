// Implementing a semi-struct without the struct keyword by using pointer math and inline functions
//
// struct Point {
//    byte xpos; // The x-position
//    byte ypos; // The y-position
// };
// Point points[NUM_POINTS];
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The size of a point
  .const SIZEOF_POINT = 2
  // The number of points
  .const NUM_POINTS = 4
  .label print_char_cursor = 4
  .label print_line_cursor = 2
// Initialize some points and print them
main: {
    // init_points()
    jsr init_points
    // print_points()
    jsr print_points
    // }
    rts
}
// Print points
print_points: {
    .label point = 9
    .label i = 8
    // print_cls()
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
    // idx*SIZEOF_POINT
    lda.z i
    asl
    tay
    // points+idx*SIZEOF_POINT
    tya
    clc
    adc #<points
    sta.z point
    lda #>points
    adc #0
    sta.z point+1
    // print_u8(*pointXpos(point))
    ldx points,y
    jsr print_u8
    // print_str(" ")
    jsr print_str
    // print_u8(*pointYpos(point))
    ldy #1
    lda (point),y
    tax
    jsr print_u8
    // print_ln()
    jsr print_ln
    // for(byte i: 0..NUM_POINTS-1)
    inc.z i
    lda #NUM_POINTS-1+1
    cmp.z i
    bne __b7
    // }
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
    // print_line_cursor + $28
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    // while (print_line_cursor<print_char_cursor)
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    // }
    rts
}
// Print a char as HEX
// print_u8(byte register(X) b)
print_u8: {
    // b>>4
    txa
    lsr
    lsr
    lsr
    lsr
    // print_char(print_hextab[b>>4])
    tay
    lda print_hextab,y
  // Table of hexadecimal digits
    jsr print_char
    // b&$f
    lda #$f
    axs #0
    // print_char(print_hextab[b&$f])
    lda print_hextab,x
    jsr print_char
    // }
    rts
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    // *(print_char_cursor++) = ch
    ldy #0
    sta (print_char_cursor),y
    // *(print_char_cursor++) = ch;
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    // }
    rts
}
// Print a zero-terminated string
// print_str(byte* zp(6) str)
print_str: {
    .label str = 6
    lda #<print_points.str
    sta.z str
    lda #>print_points.str
    sta.z str+1
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // *(print_char_cursor++) = *(str++)
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    // *(print_char_cursor++) = *(str++);
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
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = $400
    .label end = str+num
    .label dst = 6
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
// Initialize points
init_points: {
    .label getPoint1_return = 9
    .label pos = 8
    lda #$a
    sta.z pos
    ldx #0
  __b1:
    // idx*SIZEOF_POINT
    txa
    asl
    tay
    // points+idx*SIZEOF_POINT
    tya
    clc
    adc #<points
    sta.z getPoint1_return
    lda #>points
    adc #0
    sta.z getPoint1_return+1
    // *pointXpos(point) = pos
    lda.z pos
    sta points,y
    // pos +=10
    lda #$a
    clc
    adc.z pos
    // *pointYpos(point) = pos
    ldy #1
    sta (getPoint1_return),y
    // pos +=10
    clc
    adc #$a
    sta.z pos
    // for(byte i: 0..NUM_POINTS-1)
    inx
    cpx #NUM_POINTS-1+1
    bne __b1
    // }
    rts
}
  print_hextab: .text "0123456789abcdef"
  // All points
  points: .fill NUM_POINTS*SIZEOF_POINT, 0
