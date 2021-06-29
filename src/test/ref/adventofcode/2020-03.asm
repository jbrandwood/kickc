// https://adventofcode.com/2020/day/3
  // Atari XL/XE executable XEX file with a single segment
// https://www.atarimax.com/jindroush.atari.org/afmtexe.html
.plugin "dk.camelot64.kickass.xexplugin.AtariXex"
.file [name="2020-03.xex", type="bin", segments="XexFile"]
.segmentdef XexFile [segments="Program", modify="XexFormat", _RunAddr=main]
.segmentdef Program [segments="Code, Data"]
.segmentdef Code [start=$2000]
.segmentdef Data [startAfter="Code"]
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  /// 2-byte saved memory scan counter
  .label SAVMSC = $58
  /// data under cursor
  .label OLDCHR = $5d
  /// 2-byte saved cursor memory address
  .label OLDADR = $5e
  /// Cursor inhibit flag, 0 turns on, any other number turns off. Cursor doesn't change until it moves next.
  .label CRSINH = $2f0
  /// Atari ZP registers
  /// 1-byte cursor row
  .label ROWCRS = $54
  /// 2-byte cursor column
  .label COLCRS = $55
.segment Code
main: {
    // clrscr()
    jsr clrscr
    // test_slope(3,1)
    lda #1
    sta.z test_slope.y_inc
    lda #3
    sta.z test_slope.x_inc
    jsr test_slope
    // test_slope(3,1)
    // printf("1: encountered %u trees\n",test_slope(3,1))
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("1: encountered %u trees\n",test_slope(3,1))
    jsr printf_uint
    // printf("1: encountered %u trees\n",test_slope(3,1))
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // test_slope(1,1)
    lda #1
    sta.z test_slope.y_inc
    sta.z test_slope.x_inc
    jsr test_slope
    // test_slope(1,1)
    // printf("2a: encountered %u trees\n",test_slope(1,1))
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("2a: encountered %u trees\n",test_slope(1,1))
    jsr printf_uint
    // printf("2a: encountered %u trees\n",test_slope(1,1))
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // test_slope(3,1)
    lda #1
    sta.z test_slope.y_inc
    lda #3
    sta.z test_slope.x_inc
    jsr test_slope
    // test_slope(3,1)
    // printf("2b: encountered %u trees\n",test_slope(3,1))
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // printf("2b: encountered %u trees\n",test_slope(3,1))
    jsr printf_uint
    // printf("2b: encountered %u trees\n",test_slope(3,1))
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // test_slope(5,1)
    lda #1
    sta.z test_slope.y_inc
    lda #5
    sta.z test_slope.x_inc
    jsr test_slope
    // test_slope(5,1)
    // printf("2c: encountered %u trees\n",test_slope(5,1))
    lda #<s6
    sta.z cputs.s
    lda #>s6
    sta.z cputs.s+1
    jsr cputs
    // printf("2c: encountered %u trees\n",test_slope(5,1))
    jsr printf_uint
    // printf("2c: encountered %u trees\n",test_slope(5,1))
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // test_slope(7,1)
    lda #1
    sta.z test_slope.y_inc
    lda #7
    sta.z test_slope.x_inc
    jsr test_slope
    // test_slope(7,1)
    // printf("2d: encountered %u trees\n",test_slope(7,1))
    lda #<s8
    sta.z cputs.s
    lda #>s8
    sta.z cputs.s+1
    jsr cputs
    // printf("2d: encountered %u trees\n",test_slope(7,1))
    jsr printf_uint
    // printf("2d: encountered %u trees\n",test_slope(7,1))
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // test_slope(1,2)
    lda #2
    sta.z test_slope.y_inc
    lda #1
    sta.z test_slope.x_inc
    jsr test_slope
    // test_slope(1,2)
    // printf("2e: encountered %u trees\n",test_slope(1,2))
    lda #<s10
    sta.z cputs.s
    lda #>s10
    sta.z cputs.s+1
    jsr cputs
    // printf("2e: encountered %u trees\n",test_slope(1,2))
    jsr printf_uint
    // printf("2e: encountered %u trees\n",test_slope(1,2))
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
  __b1:
    jmp __b1
  .segment Data
  .encoding "ascii"
    s: .text "1: encountered "
    .byte 0
    s1: .text @" trees\$9b"
    .byte 0
    s2: .text "2a: encountered "
    .byte 0
    s4: .text "2b: encountered "
    .byte 0
    s6: .text "2c: encountered "
    .byte 0
    s8: .text "2d: encountered "
    .byte 0
    s10: .text "2e: encountered "
    .byte 0
}
.segment Code
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    lda SAVMSC
    sta.z memset.str
    lda SAVMSC+1
    sta.z memset.str+1
    // memset(*SAVMSC, 0x00, CONIO_WIDTH * CONIO_HEIGHT)
  // Fill entire screen with spaces
    lda #<$28*$18
    sta.z memset.num
    lda #>$28*$18
    sta.z memset.num+1
    jsr memset
    // *OLDCHR = 0x00
    // 0x00 is screencode for space character
    // set the old character to a space so the cursor doesn't reappear at the last position it was at
    lda #0
    sta OLDCHR
    // gotoxy(0,0)
    jsr gotoxy
    // }
    rts
}
// Count the number of trees on a specific slope
// test_slope(byte zp($85) x_inc, byte zp($80) y_inc)
test_slope: {
    .label return = $81
    .label trees = $81
    .label mapline = $89
    .label y = $83
    .label x_inc = $85
    .label y_inc = $80
    lda #<0
    sta.z trees
    sta.z trees+1
    tax
    lda #<map
    sta.z mapline
    lda #>map
    sta.z mapline+1
    txa
    sta.z y
    sta.z y+1
  __b1:
    // for(unsigned int y=0; y<MAP_HEIGHT; y+=y_inc)
    lda.z y+1
    cmp #>$143
    bcc __b2
    bne !+
    lda.z y
    cmp #<$143
    bcc __b2
  !:
    // }
    rts
  __b2:
    // if(mapline[x]=='#')
    txa
    tay
    lda (mapline),y
    cmp #'#'
    bne __b3
    // trees++;
    inc.z trees
    bne !+
    inc.z trees+1
  !:
  __b3:
    // x += x_inc
    txa
    clc
    adc.z x_inc
    tax
    // if(x>=MAP_WIDTH)
    cpx #$1f
    bcc __b4
    // x -= MAP_WIDTH
    txa
    axs #$1f
  __b4:
    // y_inc*MAP_WIDTH
    lda.z y_inc
    asl
    clc
    adc.z y_inc
    asl
    clc
    adc.z y_inc
    asl
    clc
    adc.z y_inc
    asl
    clc
    adc.z y_inc
    // mapline += y_inc*MAP_WIDTH
    clc
    adc.z mapline
    sta.z mapline
    bcc !+
    inc.z mapline+1
  !:
    // y+=y_inc
    lda.z y_inc
    clc
    adc.z y
    sta.z y
    bcc !+
    inc.z y+1
  !:
    jmp __b1
}
// Output a NUL-terminated string at the current cursor position
// cputs(const byte* zp($83) s)
cputs: {
    .label s = $83
  __b1:
    // while (c = *s++)
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
    sta.z cputc.c
    jsr cputc
    jmp __b1
}
// Print an unsigned int using a specific format
// printf_uint(word zp($81) uvalue)
printf_uint: {
    .label uvalue = $81
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    jsr utoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
  // Print using format
    jsr printf_number_buffer
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(byte* zp($86) str, word zp($89) num)
memset: {
    .label end = $89
    .label dst = $86
    .label str = $86
    .label num = $89
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // char* end = (char*)str + num
    clc
    lda.z end
    adc.z str
    sta.z end
    lda.z end+1
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
  __breturn:
    // }
    rts
  __b3:
    // *dst = c
    lda #0
    tay
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// Set the cursor to the specified position
gotoxy: {
    .const x = 0
    .const y = 0
    // *COLCRS = x
    lda #<x
    sta COLCRS
    lda #>x
    sta COLCRS+1
    // *ROWCRS = y
    lda #y
    sta ROWCRS
    // setcursor()
    jsr setcursor
    // }
    rts
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte zp($88) c)
cputc: {
    .label convertToScreenCode1_v = c
    .label c = $88
    // if (c == '\r')
    lda #'\r'
    cmp.z c
    beq __b1
    // if(c == '\n' || c == 0x9b)
    lda #'\$9b'
    cmp.z c
    beq __b2
    lda #$9b
    cmp.z c
    beq __b2
    // return rawmap[*v];
    ldy.z convertToScreenCode1_v
    ldx rawmap,y
    // putchar(convertToScreenCode(&c))
    jsr putchar
    // (*COLCRS)++;
    inc COLCRS
    bne !+
    inc COLCRS+1
  !:
    // if (*COLCRS == CONIO_WIDTH)
    lda COLCRS+1
    bne !+
    lda COLCRS
    cmp #$28
    beq __b5
  !:
    // setcursor()
    jsr setcursor
    // }
    rts
  __b5:
    // *COLCRS = 0
    lda #<0
    sta COLCRS
    sta COLCRS+1
    // newline()
    jsr newline
    rts
  __b2:
    // *COLCRS = 0
    // 0x0a LF, or atascii EOL
    lda #<0
    sta COLCRS
    sta COLCRS+1
    // newline()
    jsr newline
    rts
  __b1:
    // *COLCRS = 0
    // 0x0d, CR = just set the cursor x value to 0
    lda #<0
    sta COLCRS
    sta COLCRS+1
    // setcursor()
    jsr setcursor
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp($81) value, byte* zp($86) buffer)
utoa: {
    .label digit_value = $89
    .label buffer = $86
    .label digit = $85
    .label value = $81
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
    ldx.z value
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
    // unsigned int digit_value = digit_values[digit]
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
// printf_number_buffer(byte register(A) buffer_sign)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // if(buffer.sign)
    cmp #0
    beq __b2
    // cputc(buffer.sign)
    sta.z cputc.c
    jsr cputc
  __b2:
    // cputs(buffer.digits)
    lda #<buffer_digits
    sta.z cputs.s
    lda #>buffer_digits
    sta.z cputs.s+1
    jsr cputs
    // }
    rts
}
// Handles cursor movement, displaying it if required, and inverting character it is over if there is one (and enabled)
setcursor: {
    .label loc = $8b
    // **OLDADR = *OLDCHR
    // save the current oldchr into oldadr
    lda OLDCHR
    ldy OLDADR
    sty.z $fe
    ldy OLDADR+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // cursorLocation()
    jsr cursorLocation
    // char * loc = cursorLocation()
    // char c = *loc
    ldy #0
    lda (loc),y
    tax
    // *OLDCHR = c
    stx OLDCHR
    // *OLDADR = loc
    lda.z loc
    sta OLDADR
    lda.z loc+1
    sta OLDADR+1
    // *CRSINH = 0
    // cursor is on, so invert the inverse bit and turn cursor on
    tya
    sta CRSINH
    // c = c ^ 0x80
    txa
    eor #$80
    // **OLDADR = c
    ldy OLDADR
    sty.z $fe
    ldy OLDADR+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // }
    rts
}
// Puts a character to the screen a the current location. Uses internal screencode. Deals with storing the old cursor value
putchar: {
    .label loc = $8b
    // **OLDADR = *OLDCHR
    lda OLDCHR
    ldy OLDADR
    sty.z $fe
    ldy OLDADR+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // cursorLocation()
    jsr cursorLocation
    // char * loc = cursorLocation()
    // char newChar = code | conio_reverse_value
    txa
    // *loc = newChar
    ldy #0
    sta (loc),y
    // *OLDCHR = newChar
    sta OLDCHR
    // setcursor()
    jsr setcursor
    // }
    rts
}
newline: {
    .label start = $86
    // if ((*ROWCRS)++ == CONIO_HEIGHT)
    inc ROWCRS
    lda #$18
    cmp ROWCRS
    bne __b1
    // **OLDADR ^= 0x80
    ldy OLDADR
    sty.z $fe
    ldy OLDADR+1
    sty.z $ff
    ldy #0
    lda ($fe),y
    eor #$80
    sta ($fe),y
    // char * start = *SAVMSC
    // move screen up 1 line
    lda SAVMSC
    sta.z start
    lda SAVMSC+1
    sta.z start+1
    // start + CONIO_WIDTH
    lda #$28
    clc
    adc.z start
    sta.z memcpy.source
    tya
    adc.z start+1
    sta.z memcpy.source+1
    // memcpy(start, start + CONIO_WIDTH, CONIO_WIDTH * 23)
    lda.z start
    sta.z memcpy.destination
    lda.z start+1
    sta.z memcpy.destination+1
    jsr memcpy
    // start + CONIO_WIDTH * 23
    clc
    lda.z memset.str
    adc #<$28*$17
    sta.z memset.str
    lda.z memset.str+1
    adc #>$28*$17
    sta.z memset.str+1
    // memset(start + CONIO_WIDTH * 23, 0x00, CONIO_WIDTH)
    lda #<$28
    sta.z memset.num
    lda #>$28
    sta.z memset.num+1
    jsr memset
    // *ROWCRS = CONIO_HEIGHT - 1
    lda #$18-1
    sta ROWCRS
  __b1:
    // setcursor()
    jsr setcursor
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
// utoa_append(byte* zp($86) buffer, word zp($81) value, word zp($89) sub)
utoa_append: {
    .label buffer = $86
    .label value = $81
    .label sub = $89
    .label return = $81
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
// Return a pointer to the location of the cursor
cursorLocation: {
    .label __0 = $8b
    .label __1 = $8b
    .label __3 = $8b
    .label return = $8b
    .label __4 = $8d
    .label __5 = $8b
    // (word)(*ROWCRS)*CONIO_WIDTH
    lda ROWCRS
    sta.z __3
    lda #0
    sta.z __3+1
    lda.z __3
    asl
    sta.z __4
    lda.z __3+1
    rol
    sta.z __4+1
    asl.z __4
    rol.z __4+1
    clc
    lda.z __5
    adc.z __4
    sta.z __5
    lda.z __5+1
    adc.z __4+1
    sta.z __5+1
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    // *SAVMSC + (word)(*ROWCRS)*CONIO_WIDTH
    clc
    lda.z __1
    adc SAVMSC
    sta.z __1
    lda.z __1+1
    adc SAVMSC+1
    sta.z __1+1
    // *SAVMSC + (word)(*ROWCRS)*CONIO_WIDTH + *COLCRS
    clc
    lda.z return
    adc COLCRS
    sta.z return
    lda.z return+1
    adc COLCRS+1
    sta.z return+1
    // }
    rts
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zp($8b) destination, byte* zp($89) source)
memcpy: {
    .const num = $28*$17
    .label src_end = $8d
    .label dst = $8b
    .label src = $89
    .label destination = $8b
    .label source = $89
    // char* src_end = (char*)source+num
    clc
    lda.z source
    adc #<num
    sta.z src_end
    lda.z source+1
    adc #>num
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
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // create a static table to map char value to screen value
  // use KickAsm functions to create a table of code -> screen code values, using cc65 algorithm
rawmap:
.var ht = Hashtable().put(0,64, 1,0, 2,32, 3,96) // the table for converting bit 6,7 into ora value
	.for(var i=0; i<256; i++) {
		.var idx = (i & $60) / 32
		.var mask = i & $9f
		.byte mask | ht.get(idx)
	}

  map: .text ".#......##..#.....#....#.#.#....#.#...#.##.#..........#...##...........#.....#.####........#........#.#...#.#.................#....#...#.#...#.#...#.#........#...........#..#.........#.#....#..#....#..#..#.#...#..##..#...........#..#.....#.......#.#..#...#...#.###...#...#.#...#.#...#.#.......#...#...#...##.##..#..................#.#.#....#..#.##....#........##...............#....#....#.#.......#.....##.#..##.#.....###.......#...........#...###....#..#.#...#..................#.........#.##...#......#.............#....#...#.#..#......#.###....#...#.....#..#........#.....#.....#...#..#.......#...#..............#..#...#...#........#...##........#..#........#....#......#......#.....#..#.###.......##....#.#..#..#..###..#..........................#...#....#.........#.#.......#.##................#..#.......#......######.....#.........#......##.......#....#..##.###..#...##.###..#.......#....#.......#.###...#.#.#........#........###...#.......#..........#.#..........#...#..........##.#....#....#........#.....#....#..#..#...#.#....##..#...##....#...........##...#..##.....#.......###.......#.#...#...#.......#.#....#.#....##.###........#..........#..............#....##..###......#.#....#.#......#.....##.....#....#..#......#...#........#.##..#.....#..#....#......#......#.#.#..........##....#.............#..#..........#.#......##..#...#......#.#..#....#....#.#..##.......#.#......##........#.#....#.#.....#..............#.........#.......#..#.#......##.........#..##.#......#......#..#.....#...#.....#.........#...........#..##..##.#..##...###..##.....#...#..##...##.#.#......#..........#.#.....##.#....#..##..#..#.........###.......#........##....#...##....##............#.#.##...............#....#..#......#.....#..#..#.#.....#.....##.#....#.#.....#.#.#.........#..#.#..##....#.....#....#.#...#.....#....#....#.#.#...........#................#.......#.......#..#.#...#.#......#..#.#...........#....#....###...#.#.#.##....##..###.#.#......#.##.#..##...#.#..#..#...#.....#.#.#.#.....###.#..#.#...#.#......#.#..##.#...#...#.#.....#.#.......#....#...#.##......#.#......#....#.....##.....#....................###...##.#...........#.......#..##.....##....#................#..#......#..........#........##..##.#...#...#.#.....#.##.#.....###..###.#...#.#..#....#.#..........#...#..#.#.#..#...#.##.##..#..#....#....####..........#..#.#..........#..........###...#.#..#..#...#..###.......####.#...#....#..#...#..#...........##....#.#...#....##....##.....#.#.##....#.##..#....#.#.#.#......#..#.###....#####.##......##..#.#.#..#........##.##..###.#...#..#..#......#..#.....#...###.....#.#....#.#..##.....#.#....#......#.#...#...#.#....#.#.....#.###.##...................#..........#........#.#...##.#.##......#.#.#..#....##.###..#...#.##....#....#.........#.#..#........#..#..#.#.####.....##..#..#.##.#......#.#..##.#...#..#..#.#.##..#.##..........#......##.#.....#.#.##..#..##.....##.#.##........#..#.....#...#.##.##...#....#.#.#.........##.....#....#....#.#....#...#..#.............#...#..#...#.##......##...##.........#......#..........##.#......#.....##....#.#.#.....#..#.###......#..#.#....#.....#..#.......#...#...#.#.#.#..##......#..............#...###.....#...##......#.#..#.#........#.#...##.#....#..........##...#.#....#...#.....#.######...##...#..#...#...#............#.....#....###..###.##..#.........#.......#........##..#....#...#.#..##.#.#.##.#.#...###.................#.#.#......#.#.#....#.....#.#.#...........#.##.#..#.###......###.#....#...........##.#.#....#...#...........#..##..........#...#.#...........#..###....#..##.......#.....#.....##....#..#.......#........#...##.##..#.#....#..###..#.....##.......#.........###.#...#..#....#.#...#....#..#.......##...#.#.#...#..........#..#.......#.......##.#..#.#....###.....#...#..#...#....#...#.##.#........#..........##.....#.#.##.#.#..#..##.......##.#.#.......##....#.#...........#..##.............##...#.#..#..#...........#.#......#.##.##..#...#...#...........#....###.#.#.##..#.#.#....#....#####.........#...#.....#.#....#............#..#........#.....#.#......#...#.........#...#...#.#.#..#.....##.##......#.#...#.......#...#.##...#..#..........#...#.....##..........#..#...#.#......#.......##......#...##..##..#....#..##.......#...#.#..##..#..#.....#.#................#....#.......#..#..###.......#...............##.....#..#......#....#.........#...###...#....#..##...#.#.#.........#.......#...#....#....#.#...#.#....##....#.#..##.#.....#..#..#....#..#.#..##.....##..#..#.#.#....#...#....#..#..........###.....#...##.#..#.#...#.#.#.#..#.##........#.#....#....#..........#....#.#.......#...#.....#........#........#....#..#.#..#...#...................#....####..#..#..#..#....#..#.#...##.#..........#.##..#.....##...................##..........#....##....###.....#..#...#.#....##.........#..#...................##..###....#.##............#.#...###.#..##...#...........#.....#..#......#.....#...........#..##...#.....#.....#.#............#....###.#..#.#.#....#..##...#.......#.##.....#..........#.#..#...#.............##...........#..............#.....#..#......#......###....#...#...........#.....#...#.......###.....#..........##......##.#.#.....#....#.......#..#......#.......#..#...#.###...........#..#.###......#...#.#...........#.#...##........#.#.#........#.#.....#.....##..##.#.#..#.#....#.#.##....#.#.#......##.....#...#.#...###...#..#......#.#.#..#...#........#..##...........#..#..#..#..#..##...#...#...##.#..#.#....#.#.....####.#..#..#....##..#.#..#....#..#......#.....#.#.#........#..#.....#......#............#.#..###.....#...#...#.....##..#.#...##..#...........####....#.##....##.#......#.....##.#..#.##..#....#.###..........##....###...#......#.#....##...........................#..#.....#..#.#...#.#..#.....#...#..####.##....#.##..##...##.##.....#......#...#.##...........#.......##.###..#.....##...#.........##....###....##...###................#....#####........#.#.#.##.....#.#....####.##........#............#......#........................###.....##......#..##.#......#.#...........##.#....##.#....................#.#.#.......#.#.#........#..#.......##.......#...#...#....#......#....##.##..#..............#......#....#......#.........##..................#.#....##..#.......#............#.......#...........#........#....#.#..##.#....#...#....#.#.#..#..#.#.#.#...#....#....#.#.#....#...#.#..#......#.....#.#...........#.#....##.....#...........#...#....#....##.....###..#..........#..#..#.....#....#.#.###..........#.##....#...##..#................#.##.##.......#...#.##...##...#.........#..#....#......#......#.........#.##...#...##.#.........#......#........#.....#....................#...#.....##.........#.#..#...#......#...#.......#......#.##.......#...#.##.#..##..#.......#.#............#...###..#........#.......##.......#....#..#.......#..#.#....#.#.............#....#...##.##....#....##..............#......#.......#....#....#..#..##......##.#..#.#..##......##......#.##.##......#.............##.#...#.....#.......#...##.#....#..#......#.##.........##.####.#...#.#....#..........#........#.....#..#....#...#.####....##......#..#..#.##..#.............###.#..#..#....#.......#.........#....#.....#....#.#.#...#.#.....##.#...#...#.#..#.....##......##.##.#.....#..#.......#.##...##.......#..##......#..........#..#....#.......#.#...#.....#.................#..............#.#.#.....#.#....#..#.......#..........#.##....#....#..#.....#.......#........#....#.....##..#.........##..#..#.#..##.#...#..........#....#..........#..#.#......#.##..#..#.##.....##.####....#.....#.#...##.....#.#....#.#........#..........#...#.#.##.##....##..#...#...#....#.#.......#..#...#..#..##..#.....#....#........###.....#..........#..#.##....#.#.....#........##....#....#.......#.....#..........#........###...##.....#.#..#...##.........#.#..#....#...##...........#.........#...#......#.#.#.........#..#.#.#...........##.###....#..#.......#.....#.#...#......#..#........##.#....##....#...#.##.........#.####.#..#...........##.#.#........#....#..#.....#..##.####.#...##...#...........#.#.........##.#..#..#...#.#.#.........#..#.#......###............#...#......#.......#....#...#...#..#...##.#.#...##..#...#...#.......##.......#.#.......#..........#.#................#...#..#...#.#...#.#...##.####..##.##....#..##.#..####.......##.#........#...#......###....##...#.#..#.##.....##.....###..#...#.###.###.......#...#.....#...#..#..##..#.......#...##.....##........#.#.##..#...#..#....#....#..###....#.#..#.#.#.#.#..........#.#..#..##.......###.....................##.#......#.##.....#.........#.......................#.#.....##..#........##.......#..##..#.##.#.#.....##.#.##.##.#....##....#...#.....#.........#.....#.....#.........#.##.#.###.#......#.........#..#.##...#.......###......##........#......#...........#.#...##...#........#.##.............##............#.####..#....#...#...#..#....#..#.#.#.#..#.........#......#.##............#.....#........#........#.#.##.#..#.#..#..###......###....#.###.....#.#.#.##........#..###.#..#...##.....#....#...#.#.........#....#.....#...#............#........##.......#.##..####..#..#....#....#..#..#...#.##...##.....#............#...#...........#.......#.....#...#.#.#...........#.....#...##...............#........##...........#...#.#..##.#...#....#....#........#.##..#.#.......#...#......#..............#.#..#..#.....##.#..#....#.##.......#......#.##..#......#........#.##.#...#.....#......###..#.......##....................#.#.#.....#.##.......#.......#....#......#.#.....#...##........#...#..#.#.........#.##...........#.##...##......#....#.###.#.#.#...####..#....###..........#...#.....##....#.#.##.###..###.#.#.....#.##.........#..#...#.#.................##.###.........#.#....#.#...#.###..#.#....#..............#.##.#......#..#....##.#..#.......#..##..#..#.###......##..........#..#.##....#.#....#....#.#..#.............#.....#..#....#.##...#..#.#.#.........###..#..#.....#.....##..##...##....#..#......#............#....#..........#....#..##..#...#......#.....#.#....#..##..#....#.#.#...#................##..#.........#........#..##..#..#......###.....#..#.........#..#.##..........#.#..#..."
  .byte 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
