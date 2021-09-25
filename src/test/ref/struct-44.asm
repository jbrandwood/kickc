// Demonstrates nested struct/enum definitions.
  // Commodore 64 PRG executable file
.file [name="struct-44.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const COL_WHITE = 1
  .const COL_RED = 2
  .const OFFSET_STRUCT_CIRCLE_CENTER = 2
  .const OFFSET_STRUCT_CIRCLE_COLOR = 6
  .const OFFSET_STRUCT_POINT_Y = 2
  .label screen_line = 2
.segment Code
main: {
    // print_circle(circle)
    lda circle
    sta.z print_circle.c_radius
    lda circle+1
    sta.z print_circle.c_radius+1
    lda circle+OFFSET_STRUCT_CIRCLE_CENTER
    sta.z print_circle.c_center_x
    lda circle+OFFSET_STRUCT_CIRCLE_CENTER+1
    sta.z print_circle.c_center_x+1
    lda circle+OFFSET_STRUCT_CIRCLE_CENTER+OFFSET_STRUCT_POINT_Y
    sta.z print_circle.c_center_y
    lda circle+OFFSET_STRUCT_CIRCLE_CENTER+OFFSET_STRUCT_POINT_Y+1
    sta.z print_circle.c_center_y+1
    lda circle+OFFSET_STRUCT_CIRCLE_COLOR
    sta.z print_circle.c_color
    lda #<$400+$28*$a
    sta.z screen_line
    lda #>$400+$28*$a
    sta.z screen_line+1
    jsr print_circle
    // print_ln()
    jsr print_ln
    // print_circle(c2)
    lda c2
    sta.z print_circle.c_radius
    lda c2+1
    sta.z print_circle.c_radius+1
    lda c2+OFFSET_STRUCT_CIRCLE_CENTER
    sta.z print_circle.c_center_x
    lda c2+OFFSET_STRUCT_CIRCLE_CENTER+1
    sta.z print_circle.c_center_x+1
    lda c2+OFFSET_STRUCT_CIRCLE_CENTER+OFFSET_STRUCT_POINT_Y
    sta.z print_circle.c_center_y
    lda c2+OFFSET_STRUCT_CIRCLE_CENTER+OFFSET_STRUCT_POINT_Y+1
    sta.z print_circle.c_center_y+1
    lda c2+OFFSET_STRUCT_CIRCLE_COLOR
    sta.z print_circle.c_color
    jsr print_circle
    // }
    rts
}
// void print_circle(__zp(6) unsigned int c_radius, __zp($b) unsigned int c_center_x, __zp(9) unsigned int c_center_y, __zp(8) char c_color)
print_circle: {
    .label c_radius = 6
    .label c_center_x = $b
    .label c_center_y = 9
    .label c_color = 8
    // print_str("r:")
    ldx #0
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_uint(c.radius)
    jsr print_uint
    // print_str(" c:(")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_uint(c.center.x)
    lda.z c_center_x
    sta.z print_uint.i
    lda.z c_center_x+1
    sta.z print_uint.i+1
    jsr print_uint
    // print_str(",")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_uint(c.center.y)
    lda.z c_center_y
    sta.z print_uint.i
    lda.z c_center_y+1
    sta.z print_uint.i+1
    jsr print_uint
    // print_str(") ")
    lda #<str3
    sta.z print_str.str
    lda #>str3
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(c.color)
    jsr print_uchar
    // }
    rts
  .segment Data
    str: .text "r:"
    .byte 0
    str1: .text " c:("
    .byte 0
    str2: .text ","
    .byte 0
    str3: .text ") "
    .byte 0
}
.segment Code
print_ln: {
    // screen_line +=40
    lda #$28
    clc
    adc.z screen_line
    sta.z screen_line
    bcc !+
    inc.z screen_line+1
  !:
    // }
    rts
}
// void print_str(__zp(4) char *str)
print_str: {
    .label str = 4
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // print_char(*(str++))
    ldy #0
    lda (str),y
    jsr print_char
    // print_char(*(str++));
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// void print_uint(__zp(6) unsigned int i)
print_uint: {
    .label i = 6
    // BYTE1(i)
    lda.z i+1
    // BYTE1(i)>>4
    lsr
    lsr
    lsr
    lsr
    // print_char(HEX[BYTE1(i)>>4])
    tay
    lda HEX,y
    jsr print_char
    // BYTE1(i)
    lda.z i+1
    // BYTE1(i)&0x0f
    and #$f
    // print_char(HEX[BYTE1(i)&0x0f])
    tay
    lda HEX,y
    jsr print_char
    // BYTE0(i)
    lda.z i
    // BYTE0(i)>>4
    lsr
    lsr
    lsr
    lsr
    // print_char(HEX[BYTE0(i)>>4])
    tay
    lda HEX,y
    jsr print_char
    // BYTE0(i)
    lda.z i
    // BYTE0(i)&0x0f
    and #$f
    // print_char(HEX[BYTE0(i)&0x0f])
    tay
    lda HEX,y
    jsr print_char
    // }
    rts
}
// void print_uchar(__zp(8) char c)
print_uchar: {
    .label c = 8
    // c>>4
    lda.z c
    lsr
    lsr
    lsr
    lsr
    // print_char(HEX[c>>4])
    tay
    lda HEX,y
    jsr print_char
    // c&0x0f
    lda #$f
    and.z c
    // print_char(HEX[c&0x0f])
    tay
    lda HEX,y
    jsr print_char
    // }
    rts
}
// void print_char(__register(A) char c)
print_char: {
    // screen_line[screen_idx++] = c
    stx.z $ff
    ldy.z $ff
    sta (screen_line),y
    // screen_line[screen_idx++] = c;
    inx
    // if(screen_idx==40)
    cpx #$28
    bne __breturn
    // print_ln()
    jsr print_ln
    ldx #0
    rts
  __breturn:
    // }
    rts
}
.segment Data
  HEX: .text "0123456789abcdef"
  .byte 0
  circle: .word $64, $c8, $12c
  .byte COL_RED
  c2: .word $32, $96, $15e
  .byte COL_WHITE
