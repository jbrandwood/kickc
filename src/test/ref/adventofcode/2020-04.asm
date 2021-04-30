// https://adventofcode.com/2020/day/3
  // Atari XL/XE executable XEX file with a single segment
// https://www.atarimax.com/jindroush.atari.org/afmtexe.html
.plugin "dk.camelot64.kickass.xexplugin.AtariXex"
.file [name="2020-04.xex", type="bin", segments="XexFile"]
.segmentdef XexFile [segments="Program", modify="XexFormat", _RunAddr=main]
.segmentdef Program [segments="Code, Data"]
.segmentdef Code [start=$2000]
.segmentdef Data [startAfter="Code"]
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  // 2-byte saved memory scan counter
  .label SAVMSC = $58
  // data under cursor
  .label OLDCHR = $5d
  // 2-byte saved cursor memory address
  .label OLDADR = $5e
  // Cursor inhibit flag, 0 turns on, any other number turns off. Cursor doesn't change until it moves next.
  .label CRSINH = $2f0
  // Atari ZP registers
  // 1-byte cursor row
  .label ROWCRS = $54
  // 2-byte cursor column
  .label COLCRS = $55
.segment Code
main: {
    .label pass = $80
    .label valid = $82
    .label total = $84
    .label i1 = $89
    .label match = $8a
    // Read a tag - and examine whether it is one of the required tags
    .label required_tag = $87
    .label tag_idx = $86
    // clrscr()
    jsr clrscr
    lda #<0
    sta.z total
    sta.z total+1
    sta.z valid
    sta.z valid+1
    lda #<passports
    sta.z pass
    lda #>passports
    sta.z pass+1
  __b1:
    // while(*pass)
    ldy #0
    lda (pass),y
    cmp #0
    bne __b2
    // printf("\nValid %u Total %u\n", valid, total)
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("\nValid %u Total %u\n", valid, total)
    jsr printf_uint
    // printf("\nValid %u Total %u\n", valid, total)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // printf("\nValid %u Total %u\n", valid, total)
    lda.z total
    sta.z printf_uint.uvalue
    lda.z total+1
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("\nValid %u Total %u\n", valid, total)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
  __b27:
    jmp __b27
  __b2:
    // if(*pass==' ')
  .encoding "ascii"
    ldy #0
    lda (pass),y
    cmp #' '
    bne __b4
    // pass++;
    inc.z pass
    bne !+
    inc.z pass+1
  !:
    jmp __b1
  __b4:
    // if(*pass=='\n')
    ldy #0
    lda (pass),y
    cmp #'\$9b'
    bne __b7
    // pass++;
    inc.z pass
    bne !+
    inc.z pass+1
  !:
    // if(*pass=='\n')
    ldy #0
    lda (pass),y
    cmp #'\$9b'
    bne __b1
    // pass++;
    inc.z pass
    bne !+
    inc.z pass+1
  !:
    ldy #0
    ldx #0
  __b5:
    // for(char i=0;i<NUM_REQUIRED_TAGS;i++)
    cpx #7
    bcc __b6
    // if(num_found==NUM_REQUIRED_TAGS)
    cpy #7
    beq __b11
    // printf(".")
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
  __b12:
    // total++;
    inc.z total
    bne !+
    inc.z total+1
  !:
    jmp __b1
  __b11:
    // valid++;
    inc.z valid
    bne !+
    inc.z valid+1
  !:
    // printf("+")
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    jmp __b12
  __b6:
    // if(tags_found[i])
    lda tags_found,x
    cmp #0
    beq __b8
    // num_found++;
    iny
  __b8:
    // tags_found[i] = 0
    lda #0
    sta tags_found,x
    // for(char i=0;i<NUM_REQUIRED_TAGS;i++)
    inx
    jmp __b5
  __b7:
    lda #<required_tags
    sta.z required_tag
    lda #>required_tags
    sta.z required_tag+1
    lda #0
    sta.z tag_idx
  __b13:
    // for(char tag_idx=0;tag_idx<NUM_REQUIRED_TAGS;tag_idx++)
    lda.z tag_idx
    cmp #7
    bcc __b10
  __b21:
    // pass +=3
    lda #3
    clc
    adc.z pass
    sta.z pass
    bcc !+
    inc.z pass+1
  !:
  __b9:
  // Skip letters until we hit another whitespace
    // while(*pass && *pass!=' ' && *pass!='\n')
    ldy #0
    lda (pass),y
    cmp #0
    bne !__b1+
    jmp __b1
  !__b1:
    lda #' '
    cmp (pass),y
    bne !__b1+
    jmp __b1
  !__b1:
    lda (pass),y
    cmp #'\$9b'
    bne __b23
    jmp __b1
  __b23:
    // pass++;
    inc.z pass
    bne !+
    inc.z pass+1
  !:
    jmp __b9
  __b10:
    lda #0
    sta.z match
    sta.z i1
  __b14:
    // for(char i=0;i<3;i++)
    lda.z i1
    cmp #3
    bcc __b15
    // if(match==3)
    lda #3
    cmp.z match
    bne __b20
    // tags_found[tag_idx] = 1
    lda #1
    ldy.z tag_idx
    sta tags_found,y
    jmp __b21
  __b20:
    // required_tag += 3
    lda #3
    clc
    adc.z required_tag
    sta.z required_tag
    bcc !+
    inc.z required_tag+1
  !:
    // for(char tag_idx=0;tag_idx<NUM_REQUIRED_TAGS;tag_idx++)
    inc.z tag_idx
    jmp __b13
  __b15:
    // if(required_tag[i]==pass[i])
    ldy.z i1
    lda (required_tag),y
    tax
    lda (pass),y
    tay
    stx.z $ff
    cpy.z $ff
    bne __b17
    // match++;
    inc.z match
  __b17:
    // for(char i=0;i<3;i++)
    inc.z i1
    jmp __b14
  .segment Data
    tags_found: .fill 7, 0
    s: .text @"\$9bValid "
    .byte 0
    s1: .text " Total "
    .byte 0
    s2: .text @"\$9b"
    .byte 0
    s3: .text "+"
    .byte 0
    s4: .text "."
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
// Output a NUL-terminated string at the current cursor position
// cputs(const byte* zp($8c) s)
cputs: {
    .label s = $8c
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
// printf_uint(word zp($82) uvalue)
printf_uint: {
    .label uvalue = $82
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
// memset(byte* zp($91) str, word zp($8e) num)
memset: {
    .label end = $8e
    .label dst = $91
    .label str = $91
    .label num = $8e
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // end = (char*)str + num
    lda.z end
    clc
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
    lda #0
    sta COLCRS+1
    lda #<x
    sta COLCRS
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
// cputc(byte zp($90) c)
cputc: {
    .label convertToScreenCode1_v = c
    .label c = $90
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
    lda #0
    sta COLCRS+1
    sta COLCRS
    // newline()
    jsr newline
    rts
  __b2:
    // *COLCRS = 0
    // 0x0a LF, or atascii EOL
    lda #0
    sta COLCRS+1
    sta COLCRS
    // newline()
    jsr newline
    rts
  __b1:
    // *COLCRS = 0
    // 0x0d, CR = just set the cursor x value to 0
    lda #0
    sta COLCRS+1
    sta COLCRS
    // setcursor()
    jsr setcursor
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp($82) value, byte* zp($8c) buffer)
utoa: {
    .label digit_value = $91
    .label buffer = $8c
    .label digit = $8b
    .label value = $82
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
    .label loc = $93
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
    // loc = cursorLocation()
    // c = *loc
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
    .label loc = $93
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
    // loc = cursorLocation()
    // newChar = code | conio_reverse_value
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
    .label start = $91
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
    // start = *SAVMSC
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
// utoa_append(byte* zp($8c) buffer, word zp($82) value, word zp($91) sub)
utoa_append: {
    .label buffer = $8c
    .label value = $82
    .label sub = $91
    .label return = $82
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
    .label __0 = $93
    .label __1 = $93
    .label __3 = $93
    .label return = $93
    .label __4 = $95
    .label __5 = $93
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
    lda.z __5
    clc
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
    lda COLCRS
    adc.z return
    sta.z return
    lda COLCRS+1
    adc.z return+1
    sta.z return+1
    // }
    rts
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zp($93) destination, byte* zp($8e) source)
memcpy: {
    .const num = $28*$17
    .label src_end = $95
    .label dst = $93
    .label src = $8e
    .label destination = $93
    .label source = $8e
    // src_end = (char*)source+num
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

  // The required tags
  required_tags: .text "byriyreyrhgthcleclpid"
  .byte 0
  passports: .text @"ecl:grn\$9bcid:315 iyr:2012 hgt:192cm eyr:2023 pid:873355140 byr:1925 hcl:#cb2c03\$9b\$9bbyr:2027 hcl:ec0cfd ecl:blu cid:120\$9beyr:1937 pid:106018766 iyr:2010 hgt:154cm\$9b\$9bbyr:1965 eyr:2028 hgt:157cm\$9bcid:236 iyr:2018 ecl:brn\$9bhcl:#cfa07d pid:584111467\$9b\$9beyr:2029 ecl:hzl\$9biyr:1972 byr:1966\$9bpid:2898897192\$9bhgt:59cm hcl:z\$9b\$9bpid:231652013 hcl:#602927 hgt:166\$9becl:grn eyr:2025\$9bbyr:2008 iyr:1986\$9b\$9bbyr:1928 hgt:167cm\$9bhcl:#18171d iyr:2012\$9becl:oth pid:237657808 eyr:1944\$9b\$9bhgt:73in ecl:grn byr:1931 pid:358388825 iyr:2020\$9bhcl:#602927 eyr:2020\$9b\$9bhcl:#efcc98 eyr:2024 ecl:hzl\$9bbyr:2030 hgt:192cm\$9biyr:2013 pid:7479289410\$9b\$9bpid:053467220 iyr:2012 hgt:169cm\$9bcid:149 hcl:#866857\$9beyr:2030\$9bbyr:1995 ecl:oth\$9b\$9bhgt:162cm hcl:#efcc98 ecl:grn byr:1985 pid:419840766\$9beyr:2022\$9biyr:2020\$9b\$9bpid:22086957 hcl:c69235 ecl:#c458c5 eyr:1986 byr:2014 hgt:72cm iyr:1934\$9b\$9bhcl:#866857\$9becl:brn eyr:2024\$9biyr:2017\$9bpid:505225484 cid:144\$9bbyr:1980\$9bhgt:170cm\$9b\$9bhcl:#866857 ecl:gry\$9bbyr:1972 iyr:2019 eyr:2023\$9bcid:234 pid:721290041 hgt:191cm\$9b\$9bpid:346301363\$9beyr:2020\$9bhcl:#733820 iyr:2019 hgt:177cm\$9bbyr:1998\$9b\$9bhgt:157cm byr:1963\$9bpid:898055805\$9bhcl:#fffffd ecl:blu iyr:2017 cid:87\$9beyr:2030\$9b\$9bpid:605900764 iyr:2011\$9bhgt:73in ecl:hzl eyr:2024\$9bhcl:#888785\$9bcid:281\$9b\$9biyr:2010 eyr:2026 hcl:#4f7e76 pid:883386029 byr:1946 ecl:brn\$9b\$9bhcl:z\$9biyr:2020 pid:9121928466 byr:2014 ecl:zzz eyr:2025\$9bhgt:172in\$9b\$9bhgt:151cm cid:163 pid:670884417 iyr:2012\$9becl:oth hcl:#ceb3a1\$9beyr:2028\$9b\$9bhcl:z cid:92 hgt:69cm\$9bbyr:2008 pid:492284612\$9beyr:2020 iyr:2023\$9becl:hzl\$9b\$9bbyr:1933\$9bhcl:#7d3b0c eyr:2020 hgt:170cm\$9bpid:949064511 iyr:2010\$9becl:oth\$9b\$9beyr:2025 byr:1989 ecl:oth cid:100 hgt:182cm\$9bpid:629190040 iyr:2017 hcl:#b6652a\$9b\$9becl:hzl cid:76 hcl:#e71392 eyr:2021 iyr:2013 byr:1995\$9bpid:762177473\$9bhgt:179cm\$9b\$9bpid:198500564 eyr:2029 hcl:#733820 cid:51 iyr:2012\$9bhgt:70in byr:1938 ecl:oth\$9b\$9bhgt:190cm ecl:brn byr:1952 iyr:2015 hcl:#623a2f\$9beyr:2023\$9b\$9bhgt:169cm hcl:#602927 byr:2001 pid:823979592 iyr:2016 eyr:2029\$9b\$9biyr:2010 ecl:gry\$9beyr:2022 hgt:156cm byr:1953 pid:434063393\$9bhcl:#733820\$9b\$9bpid:091724580 hcl:a7069e eyr:1984 ecl:#95d01e byr:2012 iyr:2005\$9b\$9beyr:2022 byr:1972 hcl:#866857 ecl:hzl pid:227453248\$9bhgt:153cm cid:324 iyr:2018\$9b\$9bcid:195 pid:049871343\$9beyr:2024 hgt:169cm\$9bbyr:1952 iyr:2010 ecl:grn\$9b\$9beyr:2035 pid:189cm\$9bhgt:77 iyr:1973 ecl:#dc83d5\$9bhcl:z byr:2004\$9b\$9bbyr:2027\$9bpid:89338932 hcl:1de39e ecl:grn hgt:159in eyr:2034 iyr:1937\$9b\$9bpid:076534920\$9bhgt:152cm\$9bbyr:1969\$9becl:blu\$9bhcl:#866857 iyr:2011 eyr:2024\$9b\$9biyr:2019 eyr:2028\$9becl:blu hgt:169cm\$9bhcl:#888785 pid:332202163 byr:1923\$9b\$9bhgt:65in byr:1964 iyr:2019\$9bpid:287612987 ecl:hzl cid:213 eyr:2023 hcl:#ceb3a1\$9b\$9bhcl:#623a2f pid:182484027\$9biyr:2016 ecl:brn byr:1943\$9bhgt:71in eyr:2021 cid:344\$9b\$9bhcl:#cdee64 iyr:2011 ecl:brn eyr:2026 hgt:176cm\$9bbyr:1985 pid:978641227\$9b\$9beyr:2029 ecl:brn hgt:173cm byr:1920 cid:211\$9bhcl:#866857\$9biyr:2016 pid:289769625\$9b\$9bhcl:#7d3b0c pid:770938833 iyr:2010 byr:1941 ecl:oth eyr:2029 hgt:161cm\$9b\$9bhgt:172cm iyr:2015 ecl:gry byr:1948\$9beyr:2029\$9bpid:466359109 hcl:#341e13\$9b\$9bcid:74 pid:405199325 ecl:blu\$9bhcl:#6b5442\$9beyr:1980 byr:2024 hgt:174cm iyr:2011\$9b\$9bhgt:183cm pid:075760048 cid:78 byr:1960 ecl:hzl eyr:2030 hcl:#6b5442 iyr:2014\$9b\$9bcid:264 hcl:#7d3b0c\$9becl:blu iyr:2011 eyr:2020 hgt:182cm\$9bbyr:1929\$9b\$9bpid:435338286 byr:1931\$9bhcl:z ecl:amb iyr:2013 hgt:73in\$9bcid:165 eyr:2027\$9b\$9bpid:511898552 eyr:2025 hgt:184cm hcl:#602927\$9biyr:2018 byr:1989 ecl:hzl\$9b\$9biyr:2016\$9bhgt:168in\$9bhcl:#623a2f\$9beyr:2025 pid:310738569 ecl:#0c3039\$9bbyr:2027\$9b\$9bpid:158cm byr:1946 ecl:grt\$9biyr:1920 cid:189\$9bhcl:389bce hgt:165cm\$9b\$9bpid:973732906 hcl:#cfa07d iyr:2010 eyr:2020 hgt:180cm\$9bbyr:1930\$9becl:brn\$9b\$9bpid:930994364 byr:1967 hgt:151cm\$9biyr:2011 eyr:2022\$9b\$9beyr:1968 hgt:75cm cid:241\$9biyr:2011 pid:5493866745\$9becl:grt\$9bbyr:1976 hcl:#a97842\$9b\$9beyr:2026 ecl:oth\$9biyr:2016 hcl:#c0946f\$9bbyr:1929\$9bhgt:175cm\$9bpid:9421898537\$9b\$9beyr:2028 iyr:2016 byr:1962\$9becl:grn hgt:186cm hcl:#cfa07d pid:432962396\$9b\$9biyr:2010 byr:1934 eyr:2023 hgt:180cm hcl:#cfa07d ecl:gry\$9b\$9bcid:168\$9bbyr:1978\$9beyr:2027 hgt:189cm pid:802710287\$9bhcl:#2f980b iyr:2014\$9becl:grn\$9b\$9beyr:1970\$9bpid:576329104\$9becl:xry iyr:1954 hcl:#341e13 byr:2026\$9bhgt:74in\$9b\$9beyr:2027 hgt:153cm\$9becl:oth\$9bhcl:#866857\$9bpid:290407832 byr:1956 iyr:2017\$9b\$9biyr:2011\$9bcid:128\$9becl:amb hcl:#7d3b0c hgt:68in pid:743606119 eyr:2020\$9b\$9becl:oth hcl:#cfa07d\$9bbyr:2016 pid:#de98ae iyr:1984 cid:194\$9bhgt:170cm\$9beyr:2034\$9b\$9bpid:526098672 hgt:168cm\$9bhcl:#7d3b0c cid:167 byr:1923 ecl:blu iyr:2016\$9beyr:2030\$9b\$9bpid:495569197 hcl:#866857 hgt:193cm\$9biyr:2013 eyr:2021 byr:1921 ecl:amb\$9b\$9becl:amb\$9bhcl:#a97842 pid:862249915 iyr:2012 byr:1964\$9bcid:325\$9beyr:2021\$9b\$9biyr:1958\$9bbyr:2003\$9bhgt:160 hcl:#18171d\$9becl:hzl eyr:2020\$9b\$9biyr:2019 byr:1997 ecl:brn\$9bpid:342735713 hcl:#efcc98\$9bhgt:181cm cid:307\$9beyr:2027\$9b\$9bpid:817121616 eyr:2020\$9biyr:2012\$9bhgt:185cm\$9bhcl:#18171d byr:1969 ecl:hzl\$9b\$9bpid:381399203\$9becl:oth byr:1930\$9biyr:2014 hcl:#6b5442 hgt:71in cid:156 eyr:2025\$9b\$9bbyr:2002 hcl:#18171d iyr:2017\$9bpid:398245854 hgt:64in ecl:gry eyr:2025 cid:127\$9b\$9beyr:2028 hcl:#341e13\$9becl:amb iyr:2012\$9bpid:079796480 hgt:69cm\$9bbyr:1995\$9b\$9bcid:315 iyr:2028\$9bpid:775929239\$9bhgt:162cm ecl:dne byr:1940 eyr:1952 hcl:#c0946f\$9b\$9biyr:2015\$9bhgt:154cm byr:1997\$9becl:grn\$9bcid:125 eyr:2024 pid:834780229\$9bhcl:#18171d\$9b\$9becl:hzl hcl:#a97842 pid:553710574 eyr:2028\$9bhgt:183cm cid:196\$9biyr:2014\$9b\$9bpid:377912488 hgt:159cm ecl:amb eyr:2024 byr:1974\$9biyr:2014\$9bhcl:#ceb3a1\$9b\$9beyr:2024\$9bbyr:1947 hgt:63in ecl:brn\$9bcid:69\$9bpid:185228911 hcl:#b6652a iyr:2016\$9b\$9beyr:2024\$9bhgt:168cm hcl:#602927\$9biyr:2013\$9bbyr:1993\$9bpid:681091728 ecl:gry cid:203\$9b\$9bpid:037922164 iyr:2020\$9bbyr:1990 hgt:156cm eyr:2023 hcl:#866857\$9bcid:97 ecl:grn\$9b\$9bhgt:170cm pid:980455250\$9biyr:2011 ecl:hzl byr:1957\$9beyr:2030 hcl:#cfa07d\$9b\$9bhgt:158cm\$9bhcl:#602927\$9bbyr:2002 ecl:hzl iyr:2013\$9bcid:99\$9beyr:2020 pid:48646993\$9b\$9bbyr:1955 pid:814033843 eyr:2030 hcl:#a97842\$9bhgt:191cm iyr:2019\$9b\$9bpid:111196491 hgt:191cm iyr:2012 ecl:blu hcl:#a97842\$9beyr:2026 cid:131 byr:1979\$9b\$9bhcl:#fffffd hgt:68in\$9bcid:121 ecl:oth eyr:2024 pid:343836937\$9bbyr:1955\$9biyr:2020\$9b\$9beyr:2025 byr:1954\$9bpid:737517118\$9bcid:343 hcl:#b6652a\$9biyr:2017 ecl:hzl\$9bhgt:175cm\$9b\$9becl:brn\$9biyr:2011 hgt:171cm cid:102 pid:066348279 byr:1981\$9b\$9becl:oth iyr:2018 byr:1975\$9beyr:2029\$9bhgt:185cm cid:226\$9bpid:978243407 hcl:#341e13\$9b\$9biyr:2015 pid:918017915 hcl:#3e52b7\$9bbyr:1999 ecl:brn cid:314\$9beyr:2025 hgt:192cm\$9b\$9bhcl:#19d1fa byr:1984 ecl:dne hgt:76in\$9biyr:2015 cid:118 pid:417075672\$9beyr:2020\$9b\$9biyr:2019\$9bcid:120 hgt:186cm\$9bhcl:#733820 eyr:2024 pid:423238982 ecl:brn byr:1968\$9b\$9bhgt:70cm cid:173 pid:767014975\$9bhcl:#866857 eyr:2039 ecl:brn byr:1985\$9b\$9bpid:340424924\$9beyr:2027 hcl:#7d3b0c\$9bhgt:168cm ecl:hzl iyr:2016\$9bbyr:1994\$9b\$9becl:hzl byr:1933 pid:580425691\$9biyr:2010 hcl:#c0946f eyr:2024\$9bhgt:64in\$9b\$9bhcl:#9fe6b0 pid:913184461 ecl:grn eyr:2030\$9bcid:262 iyr:2014\$9b\$9becl:amb pid:640007768 eyr:2030 byr:2017 iyr:1988 hcl:z\$9b\$9bbyr:1977 cid:54\$9beyr:1939 pid:882762394 iyr:2030 hcl:#ceb3a1 ecl:blu\$9b\$9biyr:2011 hcl:#7d3b0c byr:1928\$9bpid:340969354 cid:199 hgt:168cm eyr:2029 ecl:hzl\$9b\$9bpid:729464282\$9biyr:2012 hcl:baae60\$9beyr:2026 ecl:hzl hgt:166cm byr:2019\$9b\$9bpid:930997801 iyr:2019 eyr:2030\$9bhcl:#866857 ecl:oth byr:1960 cid:235 hgt:73in\$9b\$9becl:brn\$9bbyr:1988 hgt:179cm iyr:2017\$9bpid:864768439 cid:305 hcl:#c0946f\$9beyr:2029\$9b\$9bhcl:#7d3b0c ecl:grn\$9bhgt:182cm eyr:2021 pid:719891314\$9bbyr:1920 iyr:2017\$9b\$9bhgt:62cm\$9bcid:71 ecl:brn hcl:#fffffd iyr:2025 eyr:1997\$9bpid:175cm byr:2022\$9b\$9bhcl:#cfa07d cid:239 eyr:2025 ecl:hzl hgt:189in byr:1980 iyr:2020\$9bpid:703047050\$9b\$9bbyr:1951\$9beyr:2030\$9becl:hzl\$9bpid:130992467 hgt:157cm hcl:#341e13\$9b\$9bhgt:175cm\$9bhcl:#623a2f\$9bcid:68 eyr:2025\$9bbyr:2001 ecl:oth pid:253618704 iyr:2016\$9b\$9bhcl:#fffffd pid:379344553 ecl:grn\$9beyr:2026\$9bhgt:72in byr:1974 iyr:2013\$9b\$9becl:#b4e952 byr:1970 hcl:z\$9beyr:2039 pid:6056894636 iyr:2021 hgt:165cm\$9bcid:328\$9b\$9bhcl:#602927 iyr:2014 pid:890429537 byr:1957 hgt:68in eyr:2020 ecl:hzl\$9b\$9bcid:265 byr:1961 hcl:#ceb3a1 eyr:2022 iyr:2016 hgt:184cm pid:921615309\$9b\$9bbyr:1951 eyr:2024\$9bhcl:#341e13\$9becl:amb pid:414644982\$9biyr:2010 hgt:159cm\$9b\$9biyr:2015 cid:319\$9beyr:2029 ecl:brn pid:380237898\$9bhcl:#efcc98 hgt:157cm byr:1972\$9b\$9bpid:237156579 ecl:#312a91\$9bhgt:167cm iyr:2011 hcl:#c0946f eyr:2021 byr:1953\$9b\$9becl:hzl iyr:2015 pid:10160221 eyr:2025 hgt:175cm hcl:z byr:1939\$9b\$9bhgt:59in hcl:#18171d byr:1962 ecl:hzl\$9biyr:2019 eyr:2025\$9bcid:337 pid:491938615\$9b\$9becl:utc hgt:82 pid:51674655 byr:2020\$9beyr:1954 iyr:2029 hcl:z\$9b\$9bpid:119530189\$9bcid:103\$9biyr:2010 byr:1979\$9bhgt:168cm hcl:#a97842 ecl:brn eyr:2029\$9b\$9bhgt:177cm ecl:brn\$9bbyr:1990\$9bpid:015089628 eyr:2028 hcl:#733820 iyr:2020\$9b\$9becl:blu iyr:2020 hgt:189cm\$9bhcl:#efcc98 byr:1982 pid:346500376 eyr:2021 cid:160\$9b\$9becl:brn hgt:173cm iyr:2011 cid:259 hcl:#6b5442 eyr:2026\$9bbyr:1995\$9bpid:654875035\$9b\$9becl:grn eyr:2025 pid:147155222 byr:1942\$9bcid:341 hcl:#602927\$9bhgt:165cm\$9biyr:2016\$9b\$9bpid:543171646\$9bhgt:153cm\$9biyr:2019 hcl:#fffffd byr:1985 cid:266\$9beyr:2027\$9becl:hzl\$9b\$9becl:blu\$9beyr:2022\$9bpid:667939101 byr:1974\$9bcid:259 hcl:#888785\$9b\$9beyr:2030 byr:2016 iyr:2022\$9bpid:86902982\$9becl:zzz hgt:72 hcl:ceb867\$9b\$9bhcl:#fffffd\$9becl:grn pid:046978329\$9bbyr:1924\$9beyr:2025 hgt:158cm iyr:2011\$9b\$9bhgt:150cm eyr:2028 byr:1985 ecl:gry hcl:#866857 pid:340615189\$9biyr:2017\$9bcid:50\$9b\$9bcid:171 hcl:#18171d pid:009562218 byr:1981 hgt:175cm eyr:2024 ecl:oth iyr:2017\$9b\$9biyr:2019\$9beyr:2022\$9becl:brn hcl:#cfa07d pid:050270380 cid:159\$9bhgt:151cm\$9bbyr:1951\$9b\$9bhcl:#7d3b0c hgt:176cm iyr:2015 byr:1923 pid:348188421 ecl:blu eyr:2029\$9b\$9bbyr:1997 hgt:162cm eyr:2023 pid:445685977\$9biyr:2012 ecl:amb hcl:#efcc98\$9b\$9biyr:2017 ecl:oth eyr:2028 pid:791977055 hgt:170cm byr:1991\$9bhcl:#623a2f\$9b\$9bbyr:1998 hcl:#fffffd\$9beyr:2020\$9becl:gry pid:039483695 hgt:163cm iyr:2020\$9bcid:165\$9b\$9becl:hzl hgt:74in iyr:2016 pid:026214321\$9bcid:152 hcl:#a1f179\$9beyr:2036 byr:2001\$9b\$9bpid:257900949 cid:80 byr:1956 iyr:2012 hgt:165cm eyr:2030\$9b\$9bpid:918371363\$9becl:xry\$9biyr:2012\$9bbyr:2012 hgt:65cm\$9beyr:2029\$9b\$9bpid:041789006 iyr:2018 byr:1945 eyr:2024 ecl:blu\$9bhcl:#5ab31e hgt:171cm\$9b\$9becl:gry\$9bbyr:1956 cid:318 iyr:2020 hcl:#623a2f\$9beyr:2030 pid:020576506 hgt:184cm\$9b\$9bhgt:173cm iyr:2025\$9beyr:2023\$9becl:amb pid:958983168 hcl:#866857 byr:1935\$9b\$9bbyr:1974\$9beyr:2040 pid:57104308 iyr:1980 hcl:z\$9bhgt:192in cid:295 ecl:amb\$9b\$9bpid:180cm hcl:1109f7 eyr:2039 byr:2020\$9becl:dne hgt:189in iyr:1921\$9b\$9biyr:2013 byr:1961\$9bhcl:#866857\$9beyr:2025 hgt:158cm ecl:gry\$9b\$9becl:brn iyr:2013 eyr:2021 pid:978650418 byr:1980\$9bhcl:#ceb3a1 cid:110\$9bhgt:166cm\$9b\$9bpid:864880558 ecl:hzl hcl:#c0946f byr:1955 eyr:2027 hgt:169cm iyr:2011\$9b\$9beyr:2023 hgt:191cm hcl:#866857\$9bpid:454509887\$9becl:grn byr:1938 iyr:2015\$9b\$9bpid:793008846 eyr:2025 ecl:grn hcl:#341e13\$9bhgt:187cm\$9bbyr:1973 cid:224\$9biyr:2013\$9b\$9bhcl:#866857 eyr:2022 pid:802335395 hgt:171cm ecl:amb\$9biyr:2015 byr:1991\$9b\$9bhcl:#888785 pid:768625886\$9bhgt:180cm\$9beyr:2026 ecl:oth cid:178 byr:1958\$9b\$9bpid:921387245 cid:82 hgt:190cm hcl:#c0946f ecl:grn\$9biyr:2015 eyr:2023\$9b\$9bpid:0704550258 hcl:1ba8f6 iyr:2010 byr:1978 cid:130\$9beyr:2030 ecl:dne hgt:66cm\$9b\$9bpid:626293279 hcl:#7d3b0c hgt:185cm ecl:oth\$9beyr:2020 byr:1937 iyr:2012\$9b\$9bhgt:175\$9beyr:1933 ecl:gry\$9bhcl:#7d3b0c byr:2003 pid:#5d8fcc\$9biyr:2012\$9b\$9beyr:2027\$9bbyr:1927 cid:154\$9becl:gry pid:683668809 hgt:164cm\$9bhcl:#a97842 iyr:2011\$9b\$9bbyr:1940 iyr:2014 hgt:172cm eyr:2024 pid:033678324 hcl:#10fded\$9bcid:292 ecl:oth\$9b\$9biyr:1970 ecl:#201515 pid:#4cd485 eyr:2034 hgt:162\$9bbyr:2005 cid:67\$9bhcl:#c0946f\$9b\$9bcid:306\$9bbyr:1948\$9bhcl:#efcc98\$9beyr:2024 hgt:171cm pid:440657854 iyr:2015 ecl:brn\$9b\$9bhgt:172cm ecl:brn byr:1958 pid:054926969 hcl:#4b8065 iyr:2019\$9b\$9bpid:45977569 ecl:amb byr:2002 hgt:71cm hcl:z iyr:1983\$9b\$9bpid:811407848 hcl:#866857 cid:112 hgt:180cm byr:1986\$9becl:brn eyr:2026\$9b\$9becl:amb\$9bbyr:1992\$9bcid:288 pid:417117245 hcl:#623a2f\$9biyr:2011 hgt:181cm\$9beyr:2021\$9b\$9bbyr:1974 hgt:192cm cid:172\$9beyr:2022\$9becl:blu\$9bhcl:#cfa07d iyr:2014\$9b\$9beyr:2024 ecl:gry\$9bpid:874569675 byr:1960 iyr:2017 hgt:186cm\$9bhcl:#6b5442\$9b\$9bbyr:1988 eyr:2024 iyr:2020 ecl:oth hcl:#866857 pid:227304269 hgt:170cm\$9b\$9becl:grn iyr:2019 byr:2002 cid:150 hcl:#efcc98\$9bpid:600740993\$9bhgt:167cm eyr:2027\$9b\$9bpid:553824537 iyr:2019 ecl:blu eyr:2025 hcl:#e21269 hgt:193cm\$9bbyr:1923\$9b\$9bbyr:2030 iyr:2019 ecl:#cb0911\$9bhcl:#cfa07d hgt:74in eyr:2012\$9bpid:7647207386\$9b\$9bcid:289 hgt:128 pid:178cm iyr:2025 ecl:#4ad977 byr:2020 eyr:2036 hcl:#efcc98\$9b\$9bcid:119 hgt:150in\$9bhcl:z\$9biyr:2012\$9becl:brn eyr:1975\$9bbyr:2007 pid:#0dcd32\$9b\$9bhcl:8a1ce7 pid:0434291854\$9beyr:2034 iyr:2005\$9bhgt:62cm byr:2029 ecl:utc\$9b\$9becl:gry hcl:#ceb3a1 byr:1976 eyr:2024 iyr:2010 hgt:188cm\$9bpid:636312902\$9b\$9bhcl:#888785 byr:2027 hgt:178in iyr:2017 pid:973095872 eyr:1952\$9b\$9bhgt:179cm iyr:2015 hcl:#ceb3a1\$9bbyr:1944 pid:182079308 cid:317\$9beyr:2025 ecl:hzl\$9b\$9bhcl:#6b5442 ecl:grn eyr:2023 hgt:71in pid:829794667 byr:2000\$9biyr:2014 cid:192\$9b\$9biyr:2014 pid:096659610 hcl:#c0946f ecl:oth byr:1991 cid:180\$9bhgt:177cm\$9beyr:2023\$9b\$9bbyr:2017\$9beyr:2036 iyr:1933\$9bcid:225 ecl:gmt hgt:179in\$9bhcl:b5c44d pid:99932231\$9b\$9bhcl:#18171d\$9bhgt:187cm eyr:2023 byr:1934 cid:286 pid:878541119 iyr:2020 ecl:amb\$9b\$9bhgt:185cm\$9bpid:754207134 ecl:oth eyr:2023\$9bhcl:#a97842 cid:313 byr:1966\$9biyr:2015\$9b\$9bhcl:#ceb3a1 byr:1921 eyr:2022 pid:799265846 cid:285\$9bhgt:67in iyr:2015\$9b\$9biyr:2011 byr:1941\$9bhcl:#341e13 cid:65 pid:413556937\$9bhgt:169cm\$9becl:amb eyr:2020\$9b\$9biyr:2016\$9bhgt:158cm ecl:grn byr:1931 hcl:#7d3b0c\$9b\$9bpid:574299170 iyr:2013 byr:1961 ecl:hzl hcl:#866857 hgt:168cm eyr:2022\$9b\$9beyr:2022 pid:245416405\$9biyr:2019 hgt:173cm hcl:#c0946f\$9becl:brn\$9bbyr:1965\$9b\$9bbyr:1980 hgt:162cm ecl:brn pid:239318191\$9bhcl:#fffffd\$9bcid:58 eyr:2025 iyr:2020\$9b\$9bpid:892646915\$9biyr:2012 hcl:#733820 byr:1991 eyr:2021\$9bhgt:157cm ecl:oth\$9b\$9bpid:310597466 eyr:2025\$9bhcl:#cfa07d byr:1944 iyr:2018 ecl:oth\$9bhgt:183cm\$9b\$9biyr:2010 hgt:187cm ecl:oth\$9bpid:975763328\$9bhcl:#866857 eyr:2023 cid:283 byr:1997\$9b\$9biyr:2020 cid:225 hcl:#efcc98 pid:424680047 ecl:blu\$9bhgt:154cm\$9bbyr:1968 eyr:2027\$9b\$9becl:oth eyr:2020 hgt:183cm hcl:#623a2f\$9bpid:771851807\$9bbyr:1990\$9biyr:2017\$9b\$9bhcl:#efcc98 ecl:blu byr:1991 hgt:191cm pid:266021118\$9bcid:124\$9beyr:2025\$9b\$9bbyr:1993\$9becl:hzl eyr:2020\$9bhgt:163cm\$9biyr:2015 pid:831538073 hcl:#18171d\$9b\$9bhgt:74in hcl:#420afb eyr:2028\$9becl:grn pid:264469103\$9bbyr:1993\$9b\$9beyr:2020\$9bcid:79\$9bbyr:1972\$9bpid:084953331 hcl:#a97842 ecl:brn iyr:2010\$9bhgt:170cm\$9b\$9biyr:2014 ecl:gry pid:094812116 eyr:2026 hgt:190cm byr:1965 hcl:#944667\$9b\$9bhcl:#fffffd byr:1953 iyr:2014 ecl:hzl hgt:164cm\$9bcid:123 eyr:2023 pid:546394433\$9b\$9biyr:2012 hgt:155cm byr:1998 pid:#2c9be6 eyr:2023 hcl:#ceb3a1 ecl:gry\$9b\$9beyr:2029 ecl:gry pid:752489331 iyr:2015 hgt:167cm hcl:#18171d cid:70 byr:2002\$9b\$9bbyr:1938\$9becl:gry\$9bpid:764937909 iyr:2014\$9bhcl:#7d3b0c\$9beyr:2022 cid:145 hgt:184cm\$9b\$9bcid:340\$9bbyr:1924 hgt:169cm eyr:2026\$9biyr:2013 ecl:amb\$9bpid:499844992 hcl:#18171d\$9b\$9bpid:838417672 hgt:175cm\$9becl:grt iyr:2017 eyr:2025 hcl:17aa1a\$9b\$9beyr:2020\$9bbyr:1925 hcl:#341e13\$9becl:brn cid:342 pid:047426814 hgt:156cm iyr:2012\$9b\$9biyr:2011 hcl:#341e13 byr:1959\$9becl:amb pid:969679865\$9b\$9bbyr:1978 cid:320 hgt:180cm hcl:#435ceb pid:363518544 eyr:2023 iyr:2016 ecl:blu\$9b\$9biyr:2010 eyr:2028\$9bpid:183cm byr:1948\$9becl:oth cid:133\$9bhcl:#8d3298 hgt:190cm\$9b\$9bhcl:#6b5442 byr:1929 iyr:2019 pid:207713865 eyr:2029\$9bhgt:166cm ecl:gry\$9b\$9becl:blu iyr:2019\$9bbyr:1985 eyr:2030 hcl:#866857 hgt:155cm pid:659180287\$9b\$9becl:hzl\$9beyr:2020 iyr:2016 pid:440624039\$9bcid:147\$9bhgt:61in byr:1976 hcl:#733820\$9b\$9bhcl:#341e13 pid:178082907 eyr:2023\$9biyr:2015 byr:1956\$9becl:amb hgt:163cm\$9b\$9beyr:2023\$9biyr:2011 hcl:#cfa07d hgt:164cm\$9bpid:291621559 byr:1960 ecl:gry\$9b\$9bhcl:#efcc98 byr:1976\$9biyr:2017 pid:394566091 cid:248\$9bhgt:176cm ecl:hzl eyr:2026\$9b\$9biyr:2013 eyr:2029 hgt:152cm ecl:gry byr:1984 hcl:#623a2f pid:511780941\$9b\$9bpid:953716819 iyr:2010 hgt:156cm ecl:amb\$9bbyr:1947\$9bhcl:#18171d eyr:2025\$9b\$9beyr:2025 ecl:amb\$9biyr:2016\$9bhcl:#cfa07d byr:1925 pid:322787273 hgt:168cm\$9b\$9bhgt:59in iyr:2012\$9bpid:916978929 byr:1959\$9bhcl:#c0946f eyr:2021\$9becl:brn\$9b\$9bbyr:2018 eyr:1929 hgt:187in\$9bhcl:z\$9biyr:2003 pid:0377361331 ecl:utc\$9b\$9bbyr:1949 hcl:#fffffd pid:071791776 eyr:2030 iyr:2015 hgt:71in ecl:hzl\$9b\$9bhcl:#341e13\$9bhgt:154cm byr:1927 eyr:2023 ecl:blu iyr:2017\$9bpid:639867283\$9b\$9bhcl:z pid:315276249 byr:2026\$9bhgt:151cm\$9biyr:2028 eyr:2020\$9becl:hzl\$9b\$9bhcl:#341e13 eyr:2027 byr:1981 cid:342 pid:999898177 hgt:187cm\$9becl:blu iyr:2011\$9b\$9bbyr:2009\$9bhgt:73cm iyr:1921 hcl:z\$9bpid:181cm\$9becl:xry\$9b\$9becl:hzl\$9bbyr:1925\$9bpid:034183103 hcl:#341e13 hgt:158cm eyr:2029 iyr:2010\$9b\$9bbyr:1976\$9biyr:2011 hgt:177cm pid:833479839 hcl:#dcab9d ecl:blu eyr:2020\$9b\$9bcid:230 hcl:#7d3b0c byr:1954\$9biyr:2014 eyr:2026 pid:122150889\$9becl:brn hgt:182cm\$9b\$9bhcl:#a97842\$9becl:brn hgt:187cm\$9beyr:2028\$9bpid:427631634 iyr:2002 byr:2004\$9b\$9bpid:912516995 ecl:hzl iyr:2017 hcl:#ceb3a1 byr:1929 eyr:2028\$9bhgt:155cm\$9b\$9bpid:019809181\$9bcid:128 iyr:2013 hcl:#f5b9f7 byr:1931\$9bhgt:161cm\$9becl:amb\$9b\$9bhgt:64in byr:1924\$9biyr:2016 eyr:2029 ecl:hzl pid:474940085 hcl:#c0946f\$9b\$9bpid:172419213\$9becl:grn\$9bhgt:193cm iyr:2010 byr:1973 hcl:#6b5442\$9beyr:2027\$9b\$9becl:#7b5cfd iyr:2019\$9bbyr:2016\$9beyr:2040 hgt:191in\$9bcid:187 hcl:z pid:#c61084\$9b\$9beyr:2032 iyr:2014 pid:430247344 byr:1967\$9bhcl:#ceb3a1\$9bcid:241\$9becl:brn hgt:178in\$9b\$9bhcl:#623a2f iyr:2017 cid:235\$9beyr:2020 byr:1978 ecl:blu hgt:175cm\$9b\$9biyr:2013 ecl:amb hgt:174cm hcl:#866857 pid:285533942 byr:1954\$9b\$9bhgt:152cm ecl:blu pid:952587262 eyr:2024\$9biyr:2019 cid:268 hcl:#602927 byr:1947\$9b\$9bhgt:176in cid:245 byr:2011 iyr:2018\$9beyr:1987\$9bhcl:z\$9bpid:346518170\$9becl:utc\$9b\$9bhgt:180cm\$9biyr:2015 ecl:brn eyr:2027 pid:807494368 cid:324 byr:1980\$9b\$9bbyr:1936 hcl:#866857 ecl:blu\$9beyr:2021 hgt:187cm\$9biyr:2016 pid:244556968\$9b\$9bbyr:1950 cid:125\$9biyr:2020 hgt:168cm hcl:#c0946f eyr:2030 pid:758313758 ecl:blu\$9b\$9beyr:2021\$9bpid:618915663 hcl:#cfa07d iyr:2018 byr:2002\$9bhgt:157cm ecl:blu\$9b\$9bbyr:1967\$9becl:brn hcl:#c0946f pid:200495802 eyr:2021 iyr:2020\$9bcid:335\$9bhgt:181cm\$9b\$9bbyr:1996\$9becl:brn iyr:2015\$9beyr:2030\$9bhcl:#fffffd cid:207\$9bpid:022460311 hgt:158cm\$9b\$9beyr:2022 hgt:59cm iyr:2023\$9bbyr:1974 pid:354098699 hcl:b244f7\$9becl:#219505\$9b\$9bhcl:#866857 eyr:2025\$9bpid:370874666\$9bbyr:1947\$9bcid:162 ecl:oth hgt:186cm iyr:2011\$9b\$9becl:hzl eyr:2029\$9bbyr:1981\$9biyr:2012 pid:433430792 cid:252\$9bhgt:171cm\$9b\$9bpid:512473844 hgt:186cm iyr:2012 eyr:2028 byr:1949 ecl:hzl hcl:#18171d\$9b\$9bhgt:60cm iyr:1934\$9becl:#4a4017 pid:3067366202 hcl:1161df\$9beyr:1938 byr:2008\$9b\$9bpid:119509757 hcl:#cfa07d eyr:2022 hgt:174cm byr:1983\$9biyr:2015\$9becl:blu\$9b\$9bbyr:1955 eyr:2023\$9bcid:114\$9bhcl:f1aa8a pid:609049659 ecl:grn hgt:177cm\$9biyr:2015\$9b\$9beyr:2027 cid:284\$9bpid:654627982 byr:1964 iyr:2018 hgt:168cm\$9bhcl:#fffffd ecl:oth\$9b\$9biyr:1988\$9bhgt:191cm hcl:b87a62 byr:1990 ecl:xry\$9bpid:996624367 eyr:1960\$9b\$9bpid:641466821 eyr:2028 hcl:#7d3b0c\$9biyr:2010 hgt:175cm ecl:gry\$9b\$9bhcl:#b6652a\$9becl:oth\$9bbyr:1926 eyr:2030 iyr:2019 hgt:183cm\$9bpid:057196056\$9b\$9biyr:2017\$9beyr:2022 pid:936841429\$9becl:blu hcl:#6b5442 cid:179 byr:1927 hgt:161cm\$9b\$9beyr:2021\$9bcid:289 hgt:174cm iyr:2013\$9becl:grn pid:329574701 byr:1970\$9b\$9beyr:2021 byr:1939 ecl:gry pid:933505139 iyr:2014 hgt:173cm hcl:#7d3b0c\$9b\$9bcid:116 hcl:045bff eyr:2030 iyr:1920\$9becl:brn\$9bbyr:2030\$9bpid:#38f7f3\$9bhgt:155in\$9b\$9beyr:2028\$9bpid:225829241 byr:1928 hcl:#cfa07d iyr:2019\$9becl:oth\$9bhgt:166cm\$9b\$9bcid:80 byr:1936\$9biyr:2017\$9bhgt:94 hcl:#2e7503 ecl:oth eyr:2030\$9bpid:597284996\$9b\$9becl:oth\$9biyr:2019 hgt:76in\$9bbyr:1956 pid:821874039\$9b\$9beyr:2026 hgt:168cm\$9bpid:019015588\$9biyr:2010\$9becl:amb byr:2009 hcl:#623a2f cid:159\$9b\$9biyr:1980 hgt:167in\$9bpid:380644909 eyr:1966 ecl:blu byr:2004 hcl:z\$9b\$9beyr:2020 iyr:2013\$9bhcl:#08ad66 pid:540886868\$9becl:oth byr:1980 hgt:158cm\$9b\$9beyr:2026 hgt:186cm byr:1995\$9bcid:275\$9bhcl:z iyr:1958 ecl:blu\$9b\$9beyr:2026 iyr:2012\$9bhgt:61in byr:1936 pid:390833536 cid:298 ecl:grn hcl:#623a2f\$9b\$9bpid:393878498 eyr:2023 ecl:gry byr:1943 iyr:2010 hcl:#888785 hgt:158cm\$9b\$9bhgt:191cm cid:197 iyr:2014 byr:1945\$9bhcl:#fffffd\$9beyr:2020\$9bpid:183948344 ecl:amb\$9b\$9becl:gmt hgt:88\$9bcid:260 iyr:2024 byr:2022 eyr:2031 hcl:z pid:#532c6e\$9b\$9bhcl:#a97842\$9bhgt:160cm eyr:2024 ecl:blu iyr:2015 byr:1970\$9b\$9bbyr:1964 hgt:178cm\$9beyr:2025\$9bpid:813643223 ecl:brn iyr:2014\$9bhcl:#ceb3a1\$9b\$9bbyr:1965 eyr:2024 iyr:2018\$9bhgt:165cm hcl:#18171d ecl:grn pid:475669993\$9b\$9bhgt:116\$9biyr:2024 eyr:1974 hcl:504345 byr:2010 cid:206 pid:166cm ecl:zzz\$9b\$9biyr:2014 eyr:2020 pid:096460673 byr:1948\$9bhgt:153cm\$9becl:blu hcl:#341e13\$9b\$9bhcl:#ceb3a1\$9biyr:2017 hgt:67cm\$9bpid:178cm byr:2028 ecl:brn\$9bcid:293\$9b\$9bhgt:157cm\$9bhcl:#602927 byr:1941\$9biyr:2012 pid:611003211 eyr:2029\$9b\$9biyr:2019 byr:2000 pid:083917767 eyr:2024 hgt:172cm\$9bcid:248 hcl:#7e4d15\$9b\$9bbyr:1946\$9bhgt:160cm iyr:2020 hcl:#559278 pid:989139577\$9becl:amb eyr:2020\$9b\$9bpid:165cm byr:1927 cid:178 hcl:#733820 iyr:2017 hgt:156in\$9beyr:2029 ecl:brn\$9b\$9bhcl:#18171d hgt:163cm eyr:2022 byr:1962 pid:639124940 cid:258 ecl:hzl\$9biyr:2015\$9b\$9bcid:123 pid:4542006033\$9beyr:1987 byr:2010 iyr:2029 ecl:amb\$9bhgt:191cm hcl:#18171d\$9b\$9bhcl:z\$9bbyr:1928 iyr:1965\$9beyr:2022 hgt:75 ecl:oth pid:400765046\$9b\$9bhcl:#c0946f hgt:62in\$9becl:blu byr:1978 iyr:1923\$9bcid:260 eyr:2021 pid:404628742\$9b\$9bpid:#bf1611 ecl:grn\$9biyr:2018 cid:146 byr:1948\$9beyr:2025 hcl:#fffffd hgt:87\$9b\$9bpid:767547618\$9biyr:2018 hcl:#b6652a eyr:2029 hgt:165cm ecl:hzl byr:1937\$9b\$9becl:blu iyr:2019 pid:960083875 eyr:2027 hgt:71in hcl:#c0946f\$9bbyr:1921\$9b\$9biyr:2011\$9bpid:9562042482\$9bhcl:z hgt:59cm\$9beyr:1994 cid:258 ecl:#6c1bcc byr:2025\$9b\$9beyr:2028 pid:494999718 byr:1928 hgt:176cm\$9biyr:2015 ecl:oth hcl:#733820\$9b\$9bcid:78 eyr:2020 hgt:160cm byr:1947 ecl:blu\$9bhcl:#b6652a iyr:2016 pid:069457741\$9b\$9bhcl:#6b5442 iyr:2010\$9bbyr:1971\$9beyr:2028 hgt:169cm ecl:brn pid:528961949\$9b\$9beyr:2028\$9bhcl:#7d3b0c\$9bbyr:1952\$9becl:hzl\$9bcid:317 iyr:2016\$9bpid:832169844\$9b\$9bhcl:#c0946f\$9becl:brn\$9biyr:2017 eyr:2028\$9bpid:161390075 byr:1993 cid:50\$9bhgt:171cm\$9b\$9becl:#ae12d3 hgt:74cm cid:239 hcl:z pid:345439730 iyr:1924 byr:2029 eyr:2031\$9b\$9b"
  .byte 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
