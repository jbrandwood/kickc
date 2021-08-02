// Test initialization of array of struct with char* elements
  // Commodore 64 PRG executable file
.file [name="weeip-bbslist.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const LIGHT_BLUE = $e
  .const SIZEOF_STRUCT_BBS = 6
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const OFFSET_STRUCT_MOS6569_VICII_MEMORY = $18
  .const OFFSET_STRUCT_BBS_HOST_NAME = 2
  .const OFFSET_STRUCT_BBS_PORT_NUMBER = 4
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
  /// Color Ram
  .label COLORRAM = $d800
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = 9
  // The current cursor y-position
  .label conio_cursor_y = $a
  // The current text cursor line start
  .label conio_line_text = $b
  // The current color cursor line start
  .label conio_line_color = $d
.segment Code
__start: {
    // __ma char conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // __ma char conio_cursor_y = 0
    sta.z conio_cursor_y
    // __ma char *conio_line_text = CONIO_SCREEN_TEXT
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    // __ma char *conio_line_color = CONIO_SCREEN_COLORS
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
    // char line = *BASIC_CURSOR_LINE
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
    .label bbs = 2
    // VICII->MEMORY = 0x17
    lda #$17
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_MEMORY
    lda #<bbs_list
    sta.z bbs
    lda #>bbs_list
    sta.z bbs+1
  __b1:
    // for(struct bbs * bbs = bbs_list; bbs->name; bbs++)
    ldy #0
    tya
    cmp (bbs),y
    bne __b2
    iny
    cmp (bbs),y
    bne __b2
    // }
    rts
  __b2:
    // printf("%s %s %u\n", bbs->name, bbs->host_name, bbs->port_number)
    ldy #0
    lda (bbs),y
    sta.z printf_string.str
    iny
    lda (bbs),y
    sta.z printf_string.str+1
    jsr printf_string
    // printf("%s %s %u\n", bbs->name, bbs->host_name, bbs->port_number)
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("%s %s %u\n", bbs->name, bbs->host_name, bbs->port_number)
    ldy #OFFSET_STRUCT_BBS_HOST_NAME
    lda (bbs),y
    sta.z printf_string.str
    iny
    lda (bbs),y
    sta.z printf_string.str+1
    jsr printf_string
    // printf("%s %s %u\n", bbs->name, bbs->host_name, bbs->port_number)
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("%s %s %u\n", bbs->name, bbs->host_name, bbs->port_number)
    ldy #OFFSET_STRUCT_BBS_PORT_NUMBER
    lda (bbs),y
    sta.z printf_uint.uvalue
    iny
    lda (bbs),y
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("%s %s %u\n", bbs->name, bbs->host_name, bbs->port_number)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // for(struct bbs * bbs = bbs_list; bbs->name; bbs++)
    lda #SIZEOF_STRUCT_BBS
    clc
    adc.z bbs
    sta.z bbs
    bcc !+
    inc.z bbs+1
  !:
    jmp __b1
  .segment Data
    s: .text " "
    .byte 0
    s2: .text @"\n"
    .byte 0
}
.segment Code
// Set the cursor to the specified position
// gotoxy(byte register(X) y)
gotoxy: {
    .const x = 0
    .label __5 = $13
    .label __6 = $f
    .label __7 = $f
    .label line_offset = $f
    .label __8 = $11
    .label __9 = $f
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
    // unsigned int line_offset = (unsigned int)y*CONIO_WIDTH
    txa
    sta.z __7
    lda #0
    sta.z __7+1
    lda.z __7
    asl
    sta.z __8
    lda.z __7+1
    rol
    sta.z __8+1
    asl.z __8
    rol.z __8+1
    clc
    lda.z __9
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
    lda.z line_offset
    clc
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
    lda.z __6
    clc
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
// Print a string value using a specific format
// Handles justification and min length 
// printf_string(byte* zp(5) str)
printf_string: {
    .label str = 5
    // cputs(str)
    jsr cputs
    // }
    rts
}
// Output a NUL-terminated string at the current cursor position
// cputs(const byte* zp(5) s)
cputs: {
    .label s = 5
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
// Print an unsigned int using a specific format
// printf_uint(word zp(5) uvalue)
printf_uint: {
    .label uvalue = 5
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
// utoa(word zp(5) value, byte* zp($17) buffer)
utoa: {
    .const max_digits = 5
    .label digit_value = $15
    .label buffer = $17
    .label digit = 4
    .label value = 5
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
    cmp #max_digits-1
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
// utoa_append(byte* zp($17) buffer, word zp(5) value, word zp($15) sub)
utoa_append: {
    .label buffer = $17
    .label value = 5
    .label sub = $15
    .label return = 5
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
// memcpy(void* zp(7) destination, void* zp($17) source)
memcpy: {
    .label src_end = $15
    .label dst = 7
    .label src = $17
    .label source = $17
    .label destination = 7
    // char* src_end = (char*)source+num
    lda.z source
    clc
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
// memset(void* zp(7) str, byte register(X) c)
memset: {
    .label end = $17
    .label dst = 7
    .label str = 7
    // char* end = (char*)str + num
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
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  bbs_list: .word bbs_name, bbs_host_name, $fa80, bbs_name1, bbs_host_name1, $fa80, bbs_name2, bbs_host_name2, $fa80, bbs_name3, bbs_host_name3, $17, bbs_name4, bbs_host_name4, $fa80, bbs_name5, bbs_host_name5, $1900, bbs_name6, bbs_host_name6, $17, bbs_name7, bbs_host_name7, $1900, bbs_name8, bbs_host_name8, $1900, bbs_name9, bbs_host_name9, $1900, bbs_name10, bbs_host_name10, $17, bbs_name11, bbs_host_name11, $1900, bbs_name12, bbs_host_name12, $8fc, bbs_name13, bbs_host_name13, $1900, bbs_name14, bbs_host_name14, $1900, bbs_name15, bbs_host_name15, $1966, bbs_name16, bbs_host_name8, $1904, bbs_name17, bbs_host_name1, $fa80, bbs_name18, bbs_host_name18, $1900, bbs_name19, bbs_host_name19, $1900, bbs_name20, bbs_host_name20, $1966, bbs_name21, bbs_host_name21, $1900, bbs_name22, bbs_host_name22, $1900, bbs_name23, bbs_host_name23, $fa80, bbs_name24, bbs_host_name24, $605, bbs_name25, bbs_host_name25, $fa80, 0, 0, 0
  bbs_name: .text "Boar's Head"
  .byte 0
  bbs_host_name: .text "byob.hopto.org"
  .byte 0
  bbs_name1: .text "RapidFire"
  .byte 0
  bbs_host_name1: .text "rapidfire.hopto.org"
  .byte 0
  bbs_name2: .text "Antidote by Triad"
  .byte 0
  bbs_host_name2: .text "antidote.hopto.org"
  .byte 0
  bbs_name3: .text "Wizards's Realm"
  .byte 0
  bbs_host_name3: .text "wizardsrealm.c64bbs.org"
  .byte 0
  bbs_name4: .text "The Hidden"
  .byte 0
  bbs_host_name4: .text "the-hidden.hopto.org"
  .byte 0
  bbs_name5: .text "Eaglewing BBS"
  .byte 0
  bbs_host_name5: .text "eagelbird.ddns.net"
  .byte 0
  bbs_name6: .text "Scorps Portal"
  .byte 0
  bbs_host_name6: .text "scorp.us.to"
  .byte 0
  bbs_name7: .text "My C=ult BBS"
  .byte 0
  bbs_host_name7: .text "maraud.dynalias.com"
  .byte 0
  bbs_name8: .text "Commodore Image"
  .byte 0
  bbs_host_name8: .text "cib.dyndns.org"
  .byte 0
  bbs_name9: .text "64 Vintag Remic"
  .byte 0
  bbs_host_name9: .text "64vintageremixbbs.dyndns.org"
  .byte 0
  bbs_name10: .text "Jamming Signal"
  .byte 0
  bbs_host_name10: .text "bbs.jammingsignal.com"
  .byte 0
  bbs_name11: .text "Centronian BBS"
  .byte 0
  bbs_host_name11: .text "centronian.servebeer.com"
  .byte 0
  bbs_name12: .text "Anrchy Undergrnd"
  .byte 0
  bbs_host_name12: .text "aubbs.dyndns.org"
  .byte 0
  bbs_name13: .text "The Oasis BBS"
  .byte 0
  bbs_host_name13: .text "oasisbbs.hopto.org"
  .byte 0
  bbs_name14: .text "The Disk Box"
  .byte 0
  bbs_host_name14: .text "bbs.thediskbox.com"
  .byte 0
  bbs_name15: .text "Cottonwood"
  .byte 0
  bbs_host_name15: .text "cottonwoodbbs.dyndns.org"
  .byte 0
  bbs_name16: .text "Wrong Number ]["
  .byte 0
  bbs_name17: .text "RabidFire"
  .byte 0
  bbs_name18: .text "Mad World"
  .byte 0
  bbs_host_name18: .text "madworld.bounceme.net"
  .byte 0
  bbs_name19: .text "Citadel 64"
  .byte 0
  bbs_host_name19: .text "bbs.thejlab.com"
  .byte 0
  bbs_name20: .text "Hotwire BBS"
  .byte 0
  bbs_host_name20: .text "hotwirebbs.zapto.org"
  .byte 0
  bbs_name21: .text "Endless Chaos"
  .byte 0
  bbs_host_name21: .text "endlesschaos.dyndns.org"
  .byte 0
  bbs_name22: .text "Borderline"
  .byte 0
  bbs_host_name22: .text "borderlinebbs.dyndns.org"
  .byte 0
  bbs_name23: .text "RAVELOUTION"
  .byte 0
  bbs_host_name23: .text "raveolution.hopto.org"
  .byte 0
  bbs_name24: .text "The Edge BBS"
  .byte 0
  bbs_host_name24: .text "theedgebbs.dyndns.org"
  .byte 0
  bbs_name25: .text "PGS Test"
  .byte 0
  bbs_host_name25: .text "F96NG92-L.fritz.box"
  .byte 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
