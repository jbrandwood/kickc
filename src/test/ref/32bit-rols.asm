// Tests different rotate left commands
// Functions for performing input and output.
  // Commodore 64 PRG executable file
.file [name="32bit-rols.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const LIGHT_BLUE = $e
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const SIZEOF_BYTE = 1
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  // Color Ram
  .label COLORRAM = $d800
  // Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = $13
  // The current cursor y-position
  .label conio_cursor_y = $14
  // The current text cursor line start
  .label conio_line_text = $15
  // The current color cursor line start
  .label conio_line_color = $17
.segment Code
__start: {
    // conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y = 0
    sta.z conio_cursor_y
    // conio_line_text = CONIO_SCREEN_TEXT
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    // conio_line_color = CONIO_SCREEN_COLORS
    lda #<COLORRAM
    sta.z conio_line_color
    lda #>COLORRAM
    sta.z conio_line_color+1
    // #pragma constructor_for(conio_c64_init, cputc, clrscr, cscroll)
    jsr conio_c64_init
    jsr main
    rts
}
// Set initial cursor position
conio_c64_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    // line = *BASIC_CURSOR_LINE
    ldx BASIC_CURSOR_LINE
    // if(line>=CONIO_HEIGHT)
    cpx #$19
    bcc __b1
    ldx #$19-1
  __b1:
    // gotoxy(0, line)
    jsr gotoxy
    // }
    rts
}
main: {
    .label __19 = $19
    .label i = 2
    lda #0
    sta.z i
  __b2:
    // clrscr()
    jsr clrscr
    // rol_fixed(vals[i])
    lda.z i
    asl
    asl
    sta.z __19
    tay
    lda vals,y
    sta.z rol_fixed.val
    lda vals+1,y
    sta.z rol_fixed.val+1
    lda vals+2,y
    sta.z rol_fixed.val+2
    lda vals+3,y
    sta.z rol_fixed.val+3
    jsr rol_fixed
  __b3:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b3
    // clrscr()
    jsr clrscr
    // ror_fixed(vals[i])
    ldy.z __19
    lda vals,y
    sta.z ror_fixed.val
    lda vals+1,y
    sta.z ror_fixed.val+1
    lda vals+2,y
    sta.z ror_fixed.val+2
    lda vals+3,y
    sta.z ror_fixed.val+3
    jsr ror_fixed
  __b5:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b5
    // clrscr()
    jsr clrscr
    // rol_var(vals[i])
    ldy.z __19
    lda vals,y
    sta.z rol_var.val
    lda vals+1,y
    sta.z rol_var.val+1
    lda vals+2,y
    sta.z rol_var.val+2
    lda vals+3,y
    sta.z rol_var.val+3
    jsr rol_var
  __b7:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b7
    // clrscr()
    jsr clrscr
    // ror_var(vals[i])
    ldy.z __19
    lda vals,y
    sta.z ror_var.val
    lda vals+1,y
    sta.z ror_var.val+1
    lda vals+2,y
    sta.z ror_var.val+2
    lda vals+3,y
    sta.z ror_var.val+3
    jsr ror_var
  __b9:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b9
    // i+1
    ldx.z i
    inx
    // i = (i+1)&1
    lda #1
    sax.z i
    jmp __b2
  .segment Data
    vals: .dword $deadbeef, $facefeed
}
.segment Code
// Set the cursor to the specified position
// gotoxy(byte register(X) y)
gotoxy: {
    .const x = 0
    .label __5 = $22
    .label __6 = $1e
    .label __7 = $1e
    .label line_offset = $1e
    .label __8 = $20
    .label __9 = $1e
    // if(y>CONIO_HEIGHT)
    cpx #$19+1
    bcc __b2
    ldx #0
  __b2:
    // conio_cursor_x = x
    lda #x
    sta.z conio_cursor_x
    // conio_cursor_y = y
    stx.z conio_cursor_y
    // (unsigned int)y*CONIO_WIDTH
    txa
    sta.z __7
    lda #0
    sta.z __7+1
    // line_offset = (unsigned int)y*CONIO_WIDTH
    lda.z __7
    asl
    sta.z __8
    lda.z __7+1
    rol
    sta.z __8+1
    asl.z __8
    rol.z __8+1
    lda.z __9
    clc
    adc.z __8
    sta.z __9
    lda.z __9+1
    adc.z __8+1
    sta.z __9+1
    asl.z line_offset
    rol.z line_offset+1
    asl.z line_offset
    rol.z line_offset+1
    asl.z line_offset
    rol.z line_offset+1
    // CONIO_SCREEN_TEXT + line_offset
    clc
    lda.z line_offset
    adc #<DEFAULT_SCREEN
    sta.z __5
    lda.z line_offset+1
    adc #>DEFAULT_SCREEN
    sta.z __5+1
    // conio_line_text = CONIO_SCREEN_TEXT + line_offset
    lda.z __5
    sta.z conio_line_text
    lda.z __5+1
    sta.z conio_line_text+1
    // CONIO_SCREEN_COLORS + line_offset
    clc
    lda.z __6
    adc #<COLORRAM
    sta.z __6
    lda.z __6+1
    adc #>COLORRAM
    sta.z __6+1
    // conio_line_color = CONIO_SCREEN_COLORS + line_offset
    lda.z __6
    sta.z conio_line_color
    lda.z __6+1
    sta.z conio_line_color+1
    // }
    rts
}
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = $c
    .label line_cols = 4
    lda #<COLORRAM
    sta.z line_cols
    lda #>COLORRAM
    sta.z line_cols+1
    lda #<DEFAULT_SCREEN
    sta.z line_text
    lda #>DEFAULT_SCREEN
    sta.z line_text+1
    ldx #0
  __b1:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    cpx #$19
    bcc __b2
    // conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y = 0
    sta.z conio_cursor_y
    // conio_line_text = CONIO_SCREEN_TEXT
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    // conio_line_color = CONIO_SCREEN_COLORS
    lda #<COLORRAM
    sta.z conio_line_color
    lda #>COLORRAM
    sta.z conio_line_color+1
    // }
    rts
  __b2:
    ldy #0
  __b3:
    // for( char c=0;c<CONIO_WIDTH; c++ )
    cpy #$28
    bcc __b4
    // line_text += CONIO_WIDTH
    lda #$28
    clc
    adc.z line_text
    sta.z line_text
    bcc !+
    inc.z line_text+1
  !:
    // line_cols += CONIO_WIDTH
    lda #$28
    clc
    adc.z line_cols
    sta.z line_cols
    bcc !+
    inc.z line_cols+1
  !:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    inx
    jmp __b1
  __b4:
    // line_text[c] = ' '
    lda #' '
    sta (line_text),y
    // line_cols[c] = conio_textcolor
    lda #LIGHT_BLUE
    sta (line_cols),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    iny
    jmp __b3
}
// rol_fixed(dword zp($1a) val)
rol_fixed: {
    .label val = $1a
    // printf("rol fixed\n")
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 0, val<<0)
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    lda #<0
    sta.z printf_sint.value
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 0, val<<0)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 0, val<<0)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 0, val<<0)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 1, val<<1)
    lda.z val
    asl
    sta.z printf_ulong.uvalue
    lda.z val+1
    rol
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    rol
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    rol
    sta.z printf_ulong.uvalue+3
    lda #<1
    sta.z printf_sint.value
    lda #>1
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 1, val<<1)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 1, val<<1)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 1, val<<1)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 2, val<<2)
    lda.z val
    asl
    sta.z printf_ulong.uvalue
    lda.z val+1
    rol
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    rol
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    rol
    sta.z printf_ulong.uvalue+3
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    lda #<2
    sta.z printf_sint.value
    lda #>2
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 2, val<<2)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 2, val<<2)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 2, val<<2)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 3, val<<3)
    lda.z val
    asl
    sta.z printf_ulong.uvalue
    lda.z val+1
    rol
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    rol
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    rol
    sta.z printf_ulong.uvalue+3
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    lda #<3
    sta.z printf_sint.value
    lda #>3
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 3, val<<3)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 3, val<<3)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 3, val<<3)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 4, val<<4)
    lda.z val
    asl
    sta.z printf_ulong.uvalue
    lda.z val+1
    rol
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    rol
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    rol
    sta.z printf_ulong.uvalue+3
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    lda #<4
    sta.z printf_sint.value
    lda #>4
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 4, val<<4)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 4, val<<4)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 4, val<<4)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 5, val<<5)
    lda.z val
    asl
    sta.z printf_ulong.uvalue
    lda.z val+1
    rol
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    rol
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    rol
    sta.z printf_ulong.uvalue+3
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    lda #<5
    sta.z printf_sint.value
    lda #>5
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 5, val<<5)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 5, val<<5)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 5, val<<5)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 6, val<<6)
    lda.z val+3
    lsr
    sta.z $ff
    lda.z val+2
    ror
    sta.z printf_ulong.uvalue+3
    lda.z val+1
    ror
    sta.z printf_ulong.uvalue+2
    lda.z val
    ror
    sta.z printf_ulong.uvalue+1
    lda #0
    ror
    sta.z printf_ulong.uvalue
    lsr.z $ff
    ror.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    lda #<6
    sta.z printf_sint.value
    lda #>6
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 6, val<<6)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 6, val<<6)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 6, val<<6)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 7, val<<7)
    lda.z val+3
    lsr
    lda.z val+2
    ror
    sta.z printf_ulong.uvalue+3
    lda.z val+1
    ror
    sta.z printf_ulong.uvalue+2
    lda.z val
    ror
    sta.z printf_ulong.uvalue+1
    lda #0
    ror
    sta.z printf_ulong.uvalue
    lda #<7
    sta.z printf_sint.value
    lda #>7
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 7, val<<7)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 7, val<<7)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 7, val<<7)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 8, val<<8)
    lda #0
    sta.z printf_ulong.uvalue
    lda.z val
    sta.z printf_ulong.uvalue+1
    lda.z val+1
    sta.z printf_ulong.uvalue+2
    lda.z val+2
    sta.z printf_ulong.uvalue+3
    lda #<8
    sta.z printf_sint.value
    lda #>8
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 8, val<<8)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 8, val<<8)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 8, val<<8)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 9, val<<9)
    lda #0
    sta.z printf_ulong.uvalue
    lda.z val
    asl
    sta.z printf_ulong.uvalue+1
    lda.z val+1
    rol
    sta.z printf_ulong.uvalue+2
    lda.z val+2
    rol
    sta.z printf_ulong.uvalue+3
    lda #<9
    sta.z printf_sint.value
    lda #>9
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 9, val<<9)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 9, val<<9)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 9, val<<9)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 12, val<<12)
    ldy #$c
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpy #0
    beq !e+
  !:
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    dey
    bne !-
  !e:
    lda #<$c
    sta.z printf_sint.value
    lda #>$c
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 12, val<<12)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 12, val<<12)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 12, val<<12)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 15, val<<15)
    ldy #$f
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpy #0
    beq !e+
  !:
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    dey
    bne !-
  !e:
    lda #<$f
    sta.z printf_sint.value
    lda #>$f
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 15, val<<15)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 15, val<<15)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 15, val<<15)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 16, val<<16)
    lda #0
    sta.z printf_ulong.uvalue
    sta.z printf_ulong.uvalue+1
    lda.z val
    sta.z printf_ulong.uvalue+2
    lda.z val+1
    sta.z printf_ulong.uvalue+3
    lda #<$10
    sta.z printf_sint.value
    lda #>$10
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 16, val<<16)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 16, val<<16)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 16, val<<16)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 17, val<<17)
    ldy #$11
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpy #0
    beq !e+
  !:
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    dey
    bne !-
  !e:
    lda #<$11
    sta.z printf_sint.value
    lda #>$11
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 17, val<<17)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 17, val<<17)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 17, val<<17)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 20, val<<20)
    ldy #$14
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpy #0
    beq !e+
  !:
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    dey
    bne !-
  !e:
    lda #<$14
    sta.z printf_sint.value
    lda #>$14
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 20, val<<20)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 20, val<<20)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 20, val<<20)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 23, val<<23)
    ldy #$17
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpy #0
    beq !e+
  !:
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    dey
    bne !-
  !e:
    lda #<$17
    sta.z printf_sint.value
    lda #>$17
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 23, val<<23)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 23, val<<23)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 23, val<<23)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 24, val<<24)
    lda #0
    sta.z printf_ulong.uvalue
    sta.z printf_ulong.uvalue+1
    sta.z printf_ulong.uvalue+2
    lda.z val
    sta.z printf_ulong.uvalue+3
    lda #<$18
    sta.z printf_sint.value
    lda #>$18
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 24, val<<24)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 24, val<<24)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 24, val<<24)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 25, val<<25)
    ldy #$19
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpy #0
    beq !e+
  !:
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    dey
    bne !-
  !e:
    lda #<$19
    sta.z printf_sint.value
    lda #>$19
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 25, val<<25)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 25, val<<25)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 25, val<<25)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 28, val<<28)
    ldy #$1c
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpy #0
    beq !e+
  !:
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    dey
    bne !-
  !e:
    lda #<$1c
    sta.z printf_sint.value
    lda #>$1c
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 28, val<<28)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 28, val<<28)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 28, val<<28)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 31, val<<31)
    ldy #$1f
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpy #0
    beq !e+
  !:
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    dey
    bne !-
  !e:
    lda #<$1f
    sta.z printf_sint.value
    lda #>$1f
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 31, val<<31)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 31, val<<31)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 31, val<<31)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 32, val<<32)
    lda #0
    sta.z printf_ulong.uvalue
    sta.z printf_ulong.uvalue+1
    sta.z printf_ulong.uvalue+2
    sta.z printf_ulong.uvalue+3
    lda #<$20
    sta.z printf_sint.value
    lda #>$20
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 32, val<<32)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 32, val<<32)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 32, val<<32)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
  .segment Data
    s: .text @"rol fixed\n"
    .byte 0
}
.segment Code
// Return true if there's a key waiting, return false if not
kbhit: {
    // CIA#1 Port A: keyboard matrix columns and joystick #2
    .label CIA1_PORT_A = $dc00
    // CIA#1 Port B: keyboard matrix rows and joystick #1.
    .label CIA1_PORT_B = $dc01
    // *CIA1_PORT_A = 0
    lda #0
    sta CIA1_PORT_A
    // ~*CIA1_PORT_B
    lda CIA1_PORT_B
    eor #$ff
    // }
    rts
}
// ror_fixed(dword zp($1a) val)
ror_fixed: {
    .label val = $1a
    // printf("ror fixed\n")
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 0, val>>0)
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    lda #<0
    sta.z printf_sint.value
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 0, val>>0)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 0, val>>0)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 0, val>>0)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 1, val>>1)
    lda.z val+3
    lsr
    sta.z printf_ulong.uvalue+3
    lda.z val+2
    ror
    sta.z printf_ulong.uvalue+2
    lda.z val+1
    ror
    sta.z printf_ulong.uvalue+1
    lda.z val
    ror
    sta.z printf_ulong.uvalue
    lda #<1
    sta.z printf_sint.value
    lda #>1
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 1, val>>1)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 1, val>>1)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 1, val>>1)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 2, val>>2)
    lda.z val+3
    lsr
    sta.z printf_ulong.uvalue+3
    lda.z val+2
    ror
    sta.z printf_ulong.uvalue+2
    lda.z val+1
    ror
    sta.z printf_ulong.uvalue+1
    lda.z val
    ror
    sta.z printf_ulong.uvalue
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    lda #<2
    sta.z printf_sint.value
    lda #>2
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 2, val>>2)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 2, val>>2)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 2, val>>2)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 3, val>>3)
    lda.z val+3
    lsr
    sta.z printf_ulong.uvalue+3
    lda.z val+2
    ror
    sta.z printf_ulong.uvalue+2
    lda.z val+1
    ror
    sta.z printf_ulong.uvalue+1
    lda.z val
    ror
    sta.z printf_ulong.uvalue
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    lda #<3
    sta.z printf_sint.value
    lda #>3
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 3, val>>3)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 3, val>>3)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 3, val>>3)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 4, val>>4)
    lda.z val+3
    lsr
    sta.z printf_ulong.uvalue+3
    lda.z val+2
    ror
    sta.z printf_ulong.uvalue+2
    lda.z val+1
    ror
    sta.z printf_ulong.uvalue+1
    lda.z val
    ror
    sta.z printf_ulong.uvalue
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    lda #<4
    sta.z printf_sint.value
    lda #>4
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 4, val>>4)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 4, val>>4)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 4, val>>4)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 5, val>>5)
    lda.z val+3
    lsr
    sta.z printf_ulong.uvalue+3
    lda.z val+2
    ror
    sta.z printf_ulong.uvalue+2
    lda.z val+1
    ror
    sta.z printf_ulong.uvalue+1
    lda.z val
    ror
    sta.z printf_ulong.uvalue
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    lda #<5
    sta.z printf_sint.value
    lda #>5
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 5, val>>5)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 5, val>>5)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 5, val>>5)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 6, val>>6)
    lda.z val
    asl
    sta.z $ff
    lda.z val+1
    rol
    sta.z printf_ulong.uvalue
    lda.z val+2
    rol
    sta.z printf_ulong.uvalue+1
    lda.z val+3
    rol
    sta.z printf_ulong.uvalue+2
    lda #0
    rol
    sta.z printf_ulong.uvalue+3
    asl.z $ff
    rol.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    lda #<6
    sta.z printf_sint.value
    lda #>6
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 6, val>>6)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 6, val>>6)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 6, val>>6)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 7, val>>7)
    lda.z val
    asl
    lda.z val+1
    rol
    sta.z printf_ulong.uvalue
    lda.z val+2
    rol
    sta.z printf_ulong.uvalue+1
    lda.z val+3
    rol
    sta.z printf_ulong.uvalue+2
    lda #0
    rol
    sta.z printf_ulong.uvalue+3
    lda #<7
    sta.z printf_sint.value
    lda #>7
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 7, val>>7)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 7, val>>7)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 7, val>>7)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 8, val>>8)
    lda #0
    sta.z printf_ulong.uvalue+3
    lda.z val+3
    sta.z printf_ulong.uvalue+2
    lda.z val+2
    sta.z printf_ulong.uvalue+1
    lda.z val+1
    sta.z printf_ulong.uvalue
    lda #<8
    sta.z printf_sint.value
    lda #>8
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 8, val>>8)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 8, val>>8)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 8, val>>8)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 9, val>>9)
    lda #0
    sta.z printf_ulong.uvalue+3
    lda.z val+3
    lsr
    sta.z printf_ulong.uvalue+2
    lda.z val+2
    ror
    sta.z printf_ulong.uvalue+1
    lda.z val+1
    ror
    sta.z printf_ulong.uvalue
    lda #<9
    sta.z printf_sint.value
    lda #>9
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 9, val>>9)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 9, val>>9)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 9, val>>9)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 12, val>>12)
    ldx #$c
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpx #0
    beq !e+
  !:
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    dex
    bne !-
  !e:
    lda #<$c
    sta.z printf_sint.value
    lda #>$c
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 12, val>>12)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 12, val>>12)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 12, val>>12)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 15, val>>15)
    ldx #$f
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpx #0
    beq !e+
  !:
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    dex
    bne !-
  !e:
    lda #<$f
    sta.z printf_sint.value
    lda #>$f
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 15, val>>15)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 15, val>>15)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 15, val>>15)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 16, val>>16)
    lda #0
    sta.z printf_ulong.uvalue+3
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue
    lda #<$10
    sta.z printf_sint.value
    lda #>$10
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 16, val>>16)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 16, val>>16)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 16, val>>16)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 17, val>>17)
    ldx #$11
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpx #0
    beq !e+
  !:
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    dex
    bne !-
  !e:
    lda #<$11
    sta.z printf_sint.value
    lda #>$11
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 17, val>>17)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 17, val>>17)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 17, val>>17)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 20, val>>20)
    ldx #$14
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpx #0
    beq !e+
  !:
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    dex
    bne !-
  !e:
    lda #<$14
    sta.z printf_sint.value
    lda #>$14
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 20, val>>20)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 20, val>>20)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 20, val>>20)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 23, val>>23)
    ldx #$17
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpx #0
    beq !e+
  !:
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    dex
    bne !-
  !e:
    lda #<$17
    sta.z printf_sint.value
    lda #>$17
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 23, val>>23)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 23, val>>23)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 23, val>>23)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 24, val>>24)
    lda #0
    sta.z printf_ulong.uvalue+3
    sta.z printf_ulong.uvalue+2
    sta.z printf_ulong.uvalue+1
    lda.z val+3
    sta.z printf_ulong.uvalue
    lda #<$18
    sta.z printf_sint.value
    lda #>$18
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 24, val>>24)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 24, val>>24)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 24, val>>24)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 25, val>>25)
    ldx #$19
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpx #0
    beq !e+
  !:
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    dex
    bne !-
  !e:
    lda #<$19
    sta.z printf_sint.value
    lda #>$19
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 25, val>>25)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 25, val>>25)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 25, val>>25)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 28, val>>28)
    ldx #$1c
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpx #0
    beq !e+
  !:
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    dex
    bne !-
  !e:
    lda #<$1c
    sta.z printf_sint.value
    lda #>$1c
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 28, val>>28)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 28, val>>28)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 28, val>>28)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 31, val>>31)
    ldx #$1f
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpx #0
    beq !e+
  !:
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    dex
    bne !-
  !e:
    lda #<$1f
    sta.z printf_sint.value
    lda #>$1f
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 31, val>>31)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 31, val>>31)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 31, val>>31)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 32, val>>32)
    lda #0
    sta.z printf_ulong.uvalue+3
    sta.z printf_ulong.uvalue+2
    sta.z printf_ulong.uvalue+1
    sta.z printf_ulong.uvalue
    lda #<$20
    sta.z printf_sint.value
    lda #>$20
    sta.z printf_sint.value+1
    jsr printf_sint
    // printf("%2d: %08lx\n", 32, val>>32)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2d: %08lx\n", 32, val>>32)
    jsr printf_ulong
    // printf("%2d: %08lx\n", 32, val>>32)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
  .segment Data
    s: .text @"ror fixed\n"
    .byte 0
}
.segment Code
// rol_var(dword zp($1a) val)
rol_var: {
    .label val = $1a
    .label i = 3
    // printf("rol var\n")
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    lda #0
    sta.z i
  __b1:
    // for(char i=0;i<sizeof(rols);i++)
    lda.z i
    cmp #$15*SIZEOF_BYTE
    bcc __b2
    // }
    rts
  __b2:
    // printf("%2u: %08lx\n", rols[i], val<<rols[i])
    ldx.z i
    ldy rols,x
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpy #0
    beq !e+
  !:
    asl.z printf_ulong.uvalue
    rol.z printf_ulong.uvalue+1
    rol.z printf_ulong.uvalue+2
    rol.z printf_ulong.uvalue+3
    dey
    bne !-
  !e:
    ldy.z i
    ldx rols,y
    jsr printf_uchar
    // printf("%2u: %08lx\n", rols[i], val<<rols[i])
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2u: %08lx\n", rols[i], val<<rols[i])
    jsr printf_ulong
    // printf("%2u: %08lx\n", rols[i], val<<rols[i])
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // for(char i=0;i<sizeof(rols);i++)
    inc.z i
    jmp __b1
  .segment Data
    s: .text @"rol var\n"
    .byte 0
}
.segment Code
// ror_var(dword zp($1a) val)
ror_var: {
    .label val = $1a
    .label i = 3
    // printf("ror var\n")
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    lda #0
    sta.z i
  __b1:
    // for(char i=0;i<sizeof(rols);i++)
    lda.z i
    cmp #$15*SIZEOF_BYTE
    bcc __b2
    // }
    rts
  __b2:
    // printf("%2u: %08lx\n", rols[i], val>>rols[i])
    ldy.z i
    ldx rols,y
    lda.z val
    sta.z printf_ulong.uvalue
    lda.z val+1
    sta.z printf_ulong.uvalue+1
    lda.z val+2
    sta.z printf_ulong.uvalue+2
    lda.z val+3
    sta.z printf_ulong.uvalue+3
    cpx #0
    beq !e+
  !:
    lsr.z printf_ulong.uvalue+3
    ror.z printf_ulong.uvalue+2
    ror.z printf_ulong.uvalue+1
    ror.z printf_ulong.uvalue
    dex
    bne !-
  !e:
    ldy.z i
    ldx rols,y
    jsr printf_uchar
    // printf("%2u: %08lx\n", rols[i], val>>rols[i])
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("%2u: %08lx\n", rols[i], val>>rols[i])
    jsr printf_ulong
    // printf("%2u: %08lx\n", rols[i], val>>rols[i])
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // for(char i=0;i<sizeof(rols);i++)
    inc.z i
    jmp __b1
  .segment Data
    s: .text @"ror var\n"
    .byte 0
}
.segment Code
// Output a NUL-terminated string at the current cursor position
// cputs(const byte* zp($c) s)
cputs: {
    .label s = $c
  __b1:
    // while(c=*s++)
    ldy #0
    lda (s),y
    inc.z s
    bne !+
    inc.z s+1
  !:
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // cputc(c)
    jsr cputc
    jmp __b1
}
// Print a signed integer using a specific format
// printf_sint(signed word zp(4) value)
printf_sint: {
    .label value = 4
    // printf_buffer.sign = 0
    // Handle any sign
    lda #0
    sta printf_buffer
    // if(value<0)
    lda.z value+1
    bmi __b1
    jmp __b2
  __b1:
    // value = -value
    sec
    lda #0
    sbc.z value
    sta.z value
    lda #0
    sbc.z value+1
    sta.z value+1
    // printf_buffer.sign = '-'
    lda #'-'
    sta printf_buffer
  __b2:
    // utoa(uvalue, printf_buffer.digits, format.radix)
    jsr utoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #0
    sta.z printf_number_buffer.format_zero_padding
    ldx #2
    jsr printf_number_buffer
    // }
    rts
}
// Print an unsigned int using a specific format
// printf_ulong(dword zp(6) uvalue)
printf_ulong: {
    .label uvalue = 6
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // ultoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    jsr ultoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #1
    sta.z printf_number_buffer.format_zero_padding
    ldx #8
    jsr printf_number_buffer
    // }
    rts
}
// Print an unsigned char using a specific format
// printf_uchar(byte register(X) uvalue)
printf_uchar: {
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    jsr uctoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #0
    sta.z printf_number_buffer.format_zero_padding
    ldx #2
    jsr printf_number_buffer
    // }
    rts
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte register(A) c)
cputc: {
    // if(c=='\n')
    cmp #'\n'
    beq __b1
    // conio_line_text[conio_cursor_x] = c
    ldy.z conio_cursor_x
    sta (conio_line_text),y
    // conio_line_color[conio_cursor_x] = conio_textcolor
    lda #LIGHT_BLUE
    sta (conio_line_color),y
    // if(++conio_cursor_x==CONIO_WIDTH)
    inc.z conio_cursor_x
    lda #$28
    cmp.z conio_cursor_x
    bne __breturn
    // cputln()
    jsr cputln
  __breturn:
    // }
    rts
  __b1:
    // cputln()
    jsr cputln
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp(4) value, byte* zp($c) buffer)
utoa: {
    .label digit_value = $24
    .label buffer = $c
    .label digit = $a
    .label value = 4
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    ldx #0
    txa
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #5-1
    bcc __b2
    // *buffer++ = DIGITS[(char)value]
    lda.z value
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    lda #0
    tay
    sta (buffer),y
    // }
    rts
  __b2:
    // digit_value = digit_values[digit]
    lda.z digit
    asl
    tay
    lda RADIX_DECIMAL_VALUES,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES+1,y
    sta.z digit_value+1
    // if (started || value >= digit_value)
    cpx #0
    bne __b5
    cmp.z value+1
    bne !+
    lda.z digit_value
    cmp.z value
    beq __b5
  !:
    bcc __b5
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
    jmp __b1
  __b5:
    // utoa_append(buffer++, value, digit_value)
    jsr utoa_append
    // utoa_append(buffer++, value, digit_value)
    // value = utoa_append(buffer++, value, digit_value)
    // value = utoa_append(buffer++, value, digit_value);
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    ldx #1
    jmp __b4
}
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte zp($b) buffer_sign, byte register(X) format_min_length, byte zp($a) format_zero_padding)
printf_number_buffer: {
    .label __19 = $24
    .label buffer_sign = $b
    .label padding = $e
    .label format_zero_padding = $a
    // if(format.min_length)
    cpx #0
    beq __b5
    // strlen(buffer.digits)
    jsr strlen
    // strlen(buffer.digits)
    // len = (signed char)strlen(buffer.digits)
    // There is a minimum length - work out the padding
    ldy.z __19
    // if(buffer.sign)
    lda.z buffer_sign
    beq __b10
    // len++;
    iny
  __b10:
    // padding = (signed char)format.min_length - len
    txa
    sty.z $ff
    sec
    sbc.z $ff
    sta.z padding
    // if(padding<0)
    cmp #0
    bpl __b1
  __b5:
    lda #0
    sta.z padding
  __b1:
    // if(!format.justify_left && !format.zero_padding && padding)
    lda.z format_zero_padding
    bne __b2
    lda.z padding
    cmp #0
    bne __b7
    jmp __b2
  __b7:
    // printf_padding(' ',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __b2:
    // if(buffer.sign)
    lda.z buffer_sign
    beq __b3
    // cputc(buffer.sign)
    jsr cputc
  __b3:
    // if(format.zero_padding && padding)
    lda.z format_zero_padding
    beq __b4
    lda.z padding
    cmp #0
    bne __b9
    jmp __b4
  __b9:
    // printf_padding('0',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #'0'
    sta.z printf_padding.pad
    jsr printf_padding
  __b4:
    // cputs(buffer.digits)
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z cputs.s
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// ultoa(dword zp(6) value, byte* zp($c) buffer)
ultoa: {
    .label digit_value = $26
    .label buffer = $c
    .label digit = $b
    .label value = 6
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    ldx #0
    txa
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #8-1
    bcc __b2
    // *buffer++ = DIGITS[(char)value]
    lda.z value
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    lda #0
    tay
    sta (buffer),y
    // }
    rts
  __b2:
    // digit_value = digit_values[digit]
    lda.z digit
    asl
    asl
    tay
    lda RADIX_HEXADECIMAL_VALUES_LONG,y
    sta.z digit_value
    lda RADIX_HEXADECIMAL_VALUES_LONG+1,y
    sta.z digit_value+1
    lda RADIX_HEXADECIMAL_VALUES_LONG+2,y
    sta.z digit_value+2
    lda RADIX_HEXADECIMAL_VALUES_LONG+3,y
    sta.z digit_value+3
    // if (started || value >= digit_value)
    cpx #0
    bne __b5
    lda.z value+3
    cmp.z digit_value+3
    bcc !+
    bne __b5
    lda.z value+2
    cmp.z digit_value+2
    bcc !+
    bne __b5
    lda.z value+1
    cmp.z digit_value+1
    bcc !+
    bne __b5
    lda.z value
    cmp.z digit_value
    bcs __b5
  !:
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
    jmp __b1
  __b5:
    // ultoa_append(buffer++, value, digit_value)
    jsr ultoa_append
    // ultoa_append(buffer++, value, digit_value)
    // value = ultoa_append(buffer++, value, digit_value)
    // value = ultoa_append(buffer++, value, digit_value);
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    ldx #1
    jmp __b4
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte register(X) value, byte* zp($11) buffer)
uctoa: {
    .label digit_value = $2a
    .label buffer = $11
    .label digit = $e
    .label started = $f
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    lda #0
    sta.z started
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #3-1
    bcc __b2
    // *buffer++ = DIGITS[(char)value]
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    lda #0
    tay
    sta (buffer),y
    // }
    rts
  __b2:
    // digit_value = digit_values[digit]
    ldy.z digit
    lda RADIX_DECIMAL_VALUES_CHAR,y
    sta.z digit_value
    // if (started || value >= digit_value)
    lda.z started
    bne __b5
    cpx.z digit_value
    bcs __b5
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
    jmp __b1
  __b5:
    // uctoa_append(buffer++, value, digit_value)
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // value = uctoa_append(buffer++, value, digit_value)
    // value = uctoa_append(buffer++, value, digit_value);
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    lda #1
    sta.z started
    jmp __b4
}
// Print a newline
cputln: {
    // conio_line_text +=  CONIO_WIDTH
    lda #$28
    clc
    adc.z conio_line_text
    sta.z conio_line_text
    bcc !+
    inc.z conio_line_text+1
  !:
    // conio_line_color += CONIO_WIDTH
    lda #$28
    clc
    adc.z conio_line_color
    sta.z conio_line_color
    bcc !+
    inc.z conio_line_color+1
  !:
    // conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y++;
    inc.z conio_cursor_y
    // cscroll()
    jsr cscroll
    // }
    rts
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// utoa_append(byte* zp($c) buffer, word zp(4) value, word zp($24) sub)
utoa_append: {
    .label buffer = $c
    .label value = 4
    .label sub = $24
    .label return = 4
    ldx #0
  __b1:
    // while (value >= sub)
    lda.z sub+1
    cmp.z value+1
    bne !+
    lda.z sub
    cmp.z value
    beq __b2
  !:
    bcc __b2
    // *buffer = DIGITS[digit]
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    inx
    // value -= sub
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    jmp __b1
}
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp($11) str)
strlen: {
    .label len = $24
    .label str = $11
    .label return = $24
    lda #<0
    sta.z len
    sta.z len+1
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z str
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
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
    // len++;
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Print a padding char a number of times
// printf_padding(byte zp($2a) pad, byte zp($f) length)
printf_padding: {
    .label i = $10
    .label length = $f
    .label pad = $2a
    lda #0
    sta.z i
  __b1:
    // for(char i=0;i<length; i++)
    lda.z i
    cmp.z length
    bcc __b2
    // }
    rts
  __b2:
    // cputc(pad)
    lda.z pad
    jsr cputc
    // for(char i=0;i<length; i++)
    inc.z i
    jmp __b1
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// ultoa_append(byte* zp($c) buffer, dword zp(6) value, dword zp($26) sub)
ultoa_append: {
    .label buffer = $c
    .label value = 6
    .label sub = $26
    .label return = 6
    ldx #0
  __b1:
    // while (value >= sub)
    lda.z value+3
    cmp.z sub+3
    bcc !+
    bne __b2
    lda.z value+2
    cmp.z sub+2
    bcc !+
    bne __b2
    lda.z value+1
    cmp.z sub+1
    bcc !+
    bne __b2
    lda.z value
    cmp.z sub
    bcs __b2
  !:
    // *buffer = DIGITS[digit]
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    inx
    // value -= sub
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    lda.z value+2
    sbc.z sub+2
    sta.z value+2
    lda.z value+3
    sbc.z sub+3
    sta.z value+3
    jmp __b1
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// uctoa_append(byte* zp($11) buffer, byte register(X) value, byte zp($2a) sub)
uctoa_append: {
    .label buffer = $11
    .label sub = $2a
    ldy #0
  __b1:
    // while (value >= sub)
    cpx.z sub
    bcs __b2
    // *buffer = DIGITS[digit]
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    iny
    // value -= sub
    txa
    sec
    sbc.z sub
    tax
    jmp __b1
}
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y==CONIO_HEIGHT)
    lda #$19
    cmp.z conio_cursor_y
    bne __breturn
    // memcpy(CONIO_SCREEN_TEXT, CONIO_SCREEN_TEXT+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH)
    lda #<DEFAULT_SCREEN
    sta.z memcpy.destination
    lda #>DEFAULT_SCREEN
    sta.z memcpy.destination+1
    lda #<DEFAULT_SCREEN+$28
    sta.z memcpy.source
    lda #>DEFAULT_SCREEN+$28
    sta.z memcpy.source+1
    jsr memcpy
    // memcpy(CONIO_SCREEN_COLORS, CONIO_SCREEN_COLORS+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH)
    lda #<COLORRAM
    sta.z memcpy.destination
    lda #>COLORRAM
    sta.z memcpy.destination+1
    lda #<COLORRAM+$28
    sta.z memcpy.source
    lda #>COLORRAM+$28
    sta.z memcpy.source+1
    jsr memcpy
    // memset(CONIO_SCREEN_TEXT+CONIO_BYTES-CONIO_WIDTH, ' ', CONIO_WIDTH)
    ldx #' '
    lda #<DEFAULT_SCREEN+$19*$28-$28
    sta.z memset.str
    lda #>DEFAULT_SCREEN+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    // memset(CONIO_SCREEN_COLORS+CONIO_BYTES-CONIO_WIDTH, conio_textcolor, CONIO_WIDTH)
    ldx #LIGHT_BLUE
    lda #<COLORRAM+$19*$28-$28
    sta.z memset.str
    lda #>COLORRAM+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    // conio_line_text -= CONIO_WIDTH
    sec
    lda.z conio_line_text
    sbc #$28
    sta.z conio_line_text
    lda.z conio_line_text+1
    sbc #0
    sta.z conio_line_text+1
    // conio_line_color -= CONIO_WIDTH
    sec
    lda.z conio_line_color
    sbc #$28
    sta.z conio_line_color
    lda.z conio_line_color+1
    sbc #0
    sta.z conio_line_color+1
    // conio_cursor_y--;
    dec.z conio_cursor_y
  __breturn:
    // }
    rts
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zp($2d) destination, void* zp($11) source)
memcpy: {
    .label src_end = $2b
    .label dst = $2d
    .label src = $11
    .label source = $11
    .label destination = $2d
    // src_end = (char*)source+num
    clc
    lda.z source
    adc #<$19*$28-$28
    sta.z src_end
    lda.z source+1
    adc #>$19*$28-$28
    sta.z src_end+1
  __b1:
    // while(src!=src_end)
    lda.z src+1
    cmp.z src_end+1
    bne __b2
    lda.z src
    cmp.z src_end
    bne __b2
    // }
    rts
  __b2:
    // *dst++ = *src++
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    inc.z src
    bne !+
    inc.z src+1
  !:
    jmp __b1
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($11) str, byte register(X) c)
memset: {
    .label end = $2d
    .label dst = $11
    .label str = $11
    // end = (char*)str + num
    lda #$28
    clc
    adc.z str
    sta.z end
    lda #0
    adc.z str+1
    sta.z end+1
  __b2:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
    // }
    rts
  __b3:
    // *dst = c
    txa
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_CHAR: .byte $64, $a
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_LONG: .dword $10000000, $1000000, $100000, $10000, $1000, $100, $10
  // The different ROL/ROR values
  rols: .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, $c, $f, $10, $11, $14, $17, $18, $19, $1c, $1f, $20
  s1: .text ": "
  .byte 0
  s2: .text @"\n"
  .byte 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
