// https://adventofcode.com/2020/day/1/input
// Find 2 entries that give 2020 when added together
// And 3 entries that give 2020 when added together
  // Atari XL/XE executable XEX file with a single segment
// https://www.atarimax.com/jindroush.atari.org/afmtexe.html
.plugin "dk.camelot64.kickass.xexplugin.AtariXex"
.file [name="2020-01.xex", type="bin", segments="XexFile"]
.segmentdef XexFile [segments="Program", modify="XexFormat", _RunAddr=main]
.segmentdef Program [segments="Code, Data"]
.segmentdef Code [start=$2000]
.segmentdef Data [startAfter="Code"]
  .const SIZEOF_WORD = 2
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
    .const num_entries = $c8*SIZEOF_WORD/SIZEOF_WORD
    .label __8 = $9d
    .label __21 = $97
    .label __22 = $9b
    .label __34 = $8e
    .label __35 = $8c
    .label __41 = $8e
    .label __42 = $95
    .label __43 = $8c
    .label j = $88
    .label i = $80
    .label mul = $90
    .label j1 = $84
    .label k = $86
    .label i1 = $82
    .label mul1 = $90
    .label mul2 = $90
    .label __47 = $9d
    .label __48 = $9f
    .label __49 = $8a
    .label __50 = $8a
    .label __51 = $8e
    .label __52 = $8c
    .label __53 = $97
    .label __54 = $99
    .label __55 = $9b
    .label __56 = $8a
    .label __57 = $8a
    .label __58 = $8a
    .label __59 = $8e
    .label __60 = $8c
    .label __61 = $8c
    // clrscr()
    jsr clrscr
    // printf("looking a+b=2020 within %u entries\n",num_entries)
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // printf("looking a+b=2020 within %u entries\n",num_entries)
    lda #<num_entries
    sta.z printf_uint.uvalue
    lda #>num_entries
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("looking a+b=2020 within %u entries\n",num_entries)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // for(unsigned int i=0;i<num_entries;i++)
    lda.z i+1
    cmp #>num_entries
    bcs !__b2+
    jmp __b2
  !__b2:
    bne !+
    lda.z i
    cmp #<num_entries
    bcs !__b2+
    jmp __b2
  !__b2:
  !:
    // printf("\nlooking a+b+c=2020 within %u entries\n",num_entries)
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // printf("\nlooking a+b+c=2020 within %u entries\n",num_entries)
    lda #<num_entries
    sta.z printf_uint.uvalue
    lda #>num_entries
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("\nlooking a+b+c=2020 within %u entries\n",num_entries)
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    lda #<0
    sta.z i1
    sta.z i1+1
  __b9:
    // for(unsigned int i=0;i<num_entries;i++)
    lda.z i1+1
    cmp #>num_entries
    bcc __b10
    bne !+
    lda.z i1
    cmp #<num_entries
    bcc __b10
  !:
    // }
    rts
  __b10:
    // j=i+1
    clc
    lda.z i1
    adc #1
    sta.z j1
    lda.z i1+1
    adc #0
    sta.z j1+1
  __b11:
    // for(unsigned int j=i+1;j<num_entries;j++)
    lda.z j1+1
    cmp #>num_entries
    bcc __b12
    bne !+
    lda.z j1
    cmp #<num_entries
    bcc __b12
  !:
    // printf(".")
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // for(unsigned int i=0;i<num_entries;i++)
    inc.z i1
    bne !+
    inc.z i1+1
  !:
    jmp __b9
  __b12:
    // k=j+1
    clc
    lda.z j1
    adc #1
    sta.z k
    lda.z j1+1
    adc #0
    sta.z k+1
  __b14:
    // for(unsigned int k=j+1;k<num_entries;k++)
    lda.z k+1
    cmp #>num_entries
    bcc __b15
    bne !+
    lda.z k
    cmp #<num_entries
    bcc __b15
  !:
    // for(unsigned int j=i+1;j<num_entries;j++)
    inc.z j1
    bne !+
    inc.z j1+1
  !:
    jmp __b11
  __b15:
    // entries[i]+entries[j]
    lda.z i1
    asl
    sta.z __41
    lda.z i1+1
    rol
    sta.z __41+1
    lda.z j1
    asl
    sta.z __42
    lda.z j1+1
    rol
    sta.z __42+1
    clc
    lda.z __41
    adc #<entries
    sta.z __53
    lda.z __41+1
    adc #>entries
    sta.z __53+1
    clc
    lda.z __42
    adc #<entries
    sta.z __54
    lda.z __42+1
    adc #>entries
    sta.z __54+1
    ldy #0
    clc
    lda (__21),y
    adc (__54),y
    pha
    iny
    lda (__21),y
    adc (__54),y
    sta.z __21+1
    pla
    sta.z __21
    // entries[i]+entries[j]+entries[k]
    lda.z k
    asl
    sta.z __43
    lda.z k+1
    rol
    sta.z __43+1
    clc
    lda.z __43
    adc #<entries
    sta.z __55
    lda.z __43+1
    adc #>entries
    sta.z __55+1
    ldy #0
    clc
    lda (__22),y
    adc.z __21
    pha
    iny
    lda (__22),y
    adc.z __21+1
    sta.z __22+1
    pla
    sta.z __22
    // if(entries[i]+entries[j]+entries[k]==2020)
    lda.z __22+1
    cmp #>$7e4
    beq !__b17+
    jmp __b17
  !__b17:
    lda.z __22
    cmp #<$7e4
    beq !__b17+
    jmp __b17
  !__b17:
    // printf("\n")
    lda #<s5
    sta.z cputs.s
    lda #>s5
    sta.z cputs.s+1
    jsr cputs
    // printf("match found [%u]%u+[%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j], k,entries[k])
    lda #<s6
    sta.z cputs.s
    lda #>s6
    sta.z cputs.s+1
    jsr cputs
    // printf("match found [%u]%u+[%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j], k,entries[k])
    lda.z i1
    sta.z printf_uint.uvalue
    lda.z i1+1
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("match found [%u]%u+[%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j], k,entries[k])
    lda #<s7
    sta.z cputs.s
    lda #>s7
    sta.z cputs.s+1
    jsr cputs
    // printf("match found [%u]%u+[%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j], k,entries[k])
    clc
    lda.z __41
    adc #<entries
    sta.z __56
    lda.z __41+1
    adc #>entries
    sta.z __56+1
    ldy #0
    lda (printf_uint.uvalue),y
    pha
    iny
    lda (printf_uint.uvalue),y
    sta.z printf_uint.uvalue+1
    pla
    sta.z printf_uint.uvalue
    jsr printf_uint
    // printf("match found [%u]%u+[%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j], k,entries[k])
    lda #<s8
    sta.z cputs.s
    lda #>s8
    sta.z cputs.s+1
    jsr cputs
    // printf("match found [%u]%u+[%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j], k,entries[k])
    lda.z j1
    sta.z printf_uint.uvalue
    lda.z j1+1
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("match found [%u]%u+[%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j], k,entries[k])
    lda #<s7
    sta.z cputs.s
    lda #>s7
    sta.z cputs.s+1
    jsr cputs
    // printf("match found [%u]%u+[%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j], k,entries[k])
    clc
    lda.z __42
    adc #<entries
    sta.z __57
    lda.z __42+1
    adc #>entries
    sta.z __57+1
    ldy #0
    lda (printf_uint.uvalue),y
    pha
    iny
    lda (printf_uint.uvalue),y
    sta.z printf_uint.uvalue+1
    pla
    sta.z printf_uint.uvalue
    jsr printf_uint
    // printf("match found [%u]%u+[%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j], k,entries[k])
    lda #<s8
    sta.z cputs.s
    lda #>s8
    sta.z cputs.s+1
    jsr cputs
    // printf("match found [%u]%u+[%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j], k,entries[k])
    lda.z k
    sta.z printf_uint.uvalue
    lda.z k+1
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("match found [%u]%u+[%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j], k,entries[k])
    lda #<s7
    sta.z cputs.s
    lda #>s7
    sta.z cputs.s+1
    jsr cputs
    // printf("match found [%u]%u+[%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j], k,entries[k])
    clc
    lda.z __43
    adc #<entries
    sta.z __58
    lda.z __43+1
    adc #>entries
    sta.z __58+1
    ldy #0
    lda (printf_uint.uvalue),y
    pha
    iny
    lda (printf_uint.uvalue),y
    sta.z printf_uint.uvalue+1
    pla
    sta.z printf_uint.uvalue
    jsr printf_uint
    // printf("match found [%u]%u+[%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j], k,entries[k])
    lda #<s10
    sta.z cputs.s
    lda #>s10
    sta.z cputs.s+1
    jsr cputs
    // mul16u(entries[i],entries[k])
    clc
    lda.z __59
    adc #<entries
    sta.z __59
    lda.z __59+1
    adc #>entries
    sta.z __59+1
    ldy #0
    lda (mul16u.a),y
    pha
    iny
    lda (mul16u.a),y
    sta.z mul16u.a+1
    pla
    sta.z mul16u.a
    clc
    lda.z __60
    adc #<entries
    sta.z __60
    lda.z __60+1
    adc #>entries
    sta.z __60+1
    ldy #0
    lda (mul16u.b),y
    pha
    iny
    lda (mul16u.b),y
    sta.z mul16u.b+1
    pla
    sta.z mul16u.b
    jsr mul16u
    // mul16u(entries[i],entries[k])
    // mul1 = mul16u(entries[i],entries[k])
    // mul16u( <mul1 ,entries[j] )
    lda.z mul1
    sta.z mul16u.a
    lda.z mul1+1
    sta.z mul16u.a+1
    clc
    lda.z __42
    adc #<entries
    sta.z __61
    lda.z __42+1
    adc #>entries
    sta.z __61+1
    ldy #0
    lda (mul16u.b),y
    pha
    iny
    lda (mul16u.b),y
    sta.z mul16u.b+1
    pla
    sta.z mul16u.b
    jsr mul16u
    // mul16u( <mul1 ,entries[j] )
    // mul2 = mul16u( <mul1 ,entries[j] )
    // printf("multiplied %lu\n", mul2)
    lda #<s11
    sta.z cputs.s
    lda #>s11
    sta.z cputs.s+1
    jsr cputs
    // printf("multiplied %lu\n", mul2)
    jsr printf_ulong
    // printf("multiplied %lu\n", mul2)
    lda #<s5
    sta.z cputs.s
    lda #>s5
    sta.z cputs.s+1
    jsr cputs
  __b17:
    // for(unsigned int k=j+1;k<num_entries;k++)
    inc.z k
    bne !+
    inc.z k+1
  !:
    jmp __b14
  __b2:
    // j=i+1
    clc
    lda.z i
    adc #1
    sta.z j
    lda.z i+1
    adc #0
    sta.z j+1
  __b4:
    // for(unsigned int j=i+1;j<num_entries;j++)
    lda.z j+1
    cmp #>num_entries
    bcc __b5
    bne !+
    lda.z j
    cmp #<num_entries
    bcc __b5
  !:
    // printf(".")
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // for(unsigned int i=0;i<num_entries;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
  __b5:
    // entries[i]+entries[j]
    lda.z i
    asl
    sta.z __34
    lda.z i+1
    rol
    sta.z __34+1
    lda.z j
    asl
    sta.z __35
    lda.z j+1
    rol
    sta.z __35+1
    clc
    lda.z __34
    adc #<entries
    sta.z __47
    lda.z __34+1
    adc #>entries
    sta.z __47+1
    clc
    lda.z __35
    adc #<entries
    sta.z __48
    lda.z __35+1
    adc #>entries
    sta.z __48+1
    ldy #0
    clc
    lda (__8),y
    adc (__48),y
    pha
    iny
    lda (__8),y
    adc (__48),y
    sta.z __8+1
    pla
    sta.z __8
    // if(entries[i]+entries[j]==2020)
    lda.z __8+1
    cmp #>$7e4
    beq !__b7+
    jmp __b7
  !__b7:
    lda.z __8
    cmp #<$7e4
    beq !__b7+
    jmp __b7
  !__b7:
    // printf("\n")
    lda #<s5
    sta.z cputs.s
    lda #>s5
    sta.z cputs.s+1
    jsr cputs
    // printf("match found [%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j])
    lda #<s6
    sta.z cputs.s
    lda #>s6
    sta.z cputs.s+1
    jsr cputs
    // printf("match found [%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j])
    lda.z i
    sta.z printf_uint.uvalue
    lda.z i+1
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("match found [%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j])
    lda #<s7
    sta.z cputs.s
    lda #>s7
    sta.z cputs.s+1
    jsr cputs
    // printf("match found [%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j])
    clc
    lda.z __34
    adc #<entries
    sta.z __49
    lda.z __34+1
    adc #>entries
    sta.z __49+1
    ldy #0
    lda (printf_uint.uvalue),y
    pha
    iny
    lda (printf_uint.uvalue),y
    sta.z printf_uint.uvalue+1
    pla
    sta.z printf_uint.uvalue
    jsr printf_uint
    // printf("match found [%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j])
    lda #<s8
    sta.z cputs.s
    lda #>s8
    sta.z cputs.s+1
    jsr cputs
    // printf("match found [%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j])
    lda.z j
    sta.z printf_uint.uvalue
    lda.z j+1
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    // printf("match found [%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j])
    lda #<s7
    sta.z cputs.s
    lda #>s7
    sta.z cputs.s+1
    jsr cputs
    // printf("match found [%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j])
    clc
    lda.z __35
    adc #<entries
    sta.z __50
    lda.z __35+1
    adc #>entries
    sta.z __50+1
    ldy #0
    lda (printf_uint.uvalue),y
    pha
    iny
    lda (printf_uint.uvalue),y
    sta.z printf_uint.uvalue+1
    pla
    sta.z printf_uint.uvalue
    jsr printf_uint
    // printf("match found [%u]%u+[%u]%u=2020\n", i,entries[i], j,entries[j])
    lda #<s10
    sta.z cputs.s
    lda #>s10
    sta.z cputs.s+1
    jsr cputs
    // mul16u(entries[i],entries[j])
    clc
    lda.z __51
    adc #<entries
    sta.z __51
    lda.z __51+1
    adc #>entries
    sta.z __51+1
    ldy #0
    lda (mul16u.a),y
    pha
    iny
    lda (mul16u.a),y
    sta.z mul16u.a+1
    pla
    sta.z mul16u.a
    clc
    lda.z __52
    adc #<entries
    sta.z __52
    lda.z __52+1
    adc #>entries
    sta.z __52+1
    ldy #0
    lda (mul16u.b),y
    pha
    iny
    lda (mul16u.b),y
    sta.z mul16u.b+1
    pla
    sta.z mul16u.b
    jsr mul16u
    // mul16u(entries[i],entries[j])
    // mul = mul16u(entries[i],entries[j])
    // printf("multiplied %lu\n", mul)
    lda #<s11
    sta.z cputs.s
    lda #>s11
    sta.z cputs.s+1
    jsr cputs
    // printf("multiplied %lu\n", mul)
    jsr printf_ulong
    // printf("multiplied %lu\n", mul)
    lda #<s5
    sta.z cputs.s
    lda #>s5
    sta.z cputs.s+1
    jsr cputs
  __b7:
    // for(unsigned int j=i+1;j<num_entries;j++)
    inc.z j
    bne !+
    inc.z j+1
  !:
    jmp __b4
  .segment Data
  .encoding "ascii"
    s: .text "looking a+b=2020 within "
    .byte 0
    s1: .text @" entries\$9b"
    .byte 0
    s2: .text @"\$9blooking a+b+c=2020 within "
    .byte 0
    s4: .text "."
    .byte 0
    s5: .text @"\$9b"
    .byte 0
    s6: .text "match found ["
    .byte 0
    s7: .text "]"
    .byte 0
    s8: .text "+["
    .byte 0
    s10: .text @"=2020\$9b"
    .byte 0
    s11: .text "multiplied "
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
// cputs(byte* zp($8a) s)
cputs: {
    .label s = $8a
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
// printf_uint(word zp($8a) uvalue)
printf_uint: {
    .label uvalue = $8a
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
// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned long
// mul16u(word zp($8e) a, word zp($8c) b)
mul16u: {
    .label mb = $a2
    .label a = $8e
    .label res = $90
    .label b = $8c
    .label return = $90
    // mb = b
    lda.z b
    sta.z mb
    lda.z b+1
    sta.z mb+1
    lda #0
    sta.z mb+2
    sta.z mb+3
    sta.z res
    sta.z res+1
    lda #<0>>$10
    sta.z res+2
    lda #>0>>$10
    sta.z res+3
  __b1:
    // while(a!=0)
    lda.z a
    ora.z a+1
    bne __b2
    // }
    rts
  __b2:
    // a&1
    lda #1
    and.z a
    // if( (a&1) != 0)
    cmp #0
    beq __b3
    // res = res + mb
    lda.z res
    clc
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
    lda.z res+2
    adc.z mb+2
    sta.z res+2
    lda.z res+3
    adc.z mb+3
    sta.z res+3
  __b3:
    // a = a>>1
    lsr.z a+1
    ror.z a
    // mb = mb<<1
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    jmp __b1
}
// Print an unsigned int using a specific format
// printf_ulong(dword zp($90) uvalue)
printf_ulong: {
    .label uvalue = $90
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // ultoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    jsr ultoa
    // printf_number_buffer(printf_buffer, format)
    lda printf_buffer
  // Print using format
    jsr printf_number_buffer
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(byte* zp($9b) str, word zp($97) num)
memset: {
    .label end = $97
    .label dst = $9b
    .label str = $9b
    .label num = $97
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
// cputc(byte zp($a1) c)
cputc: {
    .label convertToScreenCode1_v = c
    .label c = $a1
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
// utoa(word zp($8a) value, byte* zp($97) buffer)
utoa: {
    .label digit_value = $a6
    .label buffer = $97
    .label digit = $94
    .label value = $8a
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
    // if(buffer.sign)
    cmp #0
    beq __b2
    // cputc(buffer.sign)
    sta.z cputc.c
    jsr cputc
  __b2:
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
// ultoa(dword zp($90) value, byte* zp($9b) buffer)
ultoa: {
    .label digit_value = $a2
    .label buffer = $9b
    .label digit = $94
    .label value = $90
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
    cmp #$a-1
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
    lda RADIX_DECIMAL_VALUES_LONG,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES_LONG+1,y
    sta.z digit_value+1
    lda RADIX_DECIMAL_VALUES_LONG+2,y
    sta.z digit_value+2
    lda RADIX_DECIMAL_VALUES_LONG+3,y
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
// Handles cursor movement, displaying it if required, and inverting character it is over if there is one (and enabled)
setcursor: {
    .label loc = $a6
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
    .label loc = $a6
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
    .label start = $9b
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
// utoa_append(byte* zp($97) buffer, word zp($8a) value, word zp($a6) sub)
utoa_append: {
    .label buffer = $97
    .label value = $8a
    .label sub = $a6
    .label return = $8a
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
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// ultoa_append(byte* zp($9b) buffer, dword zp($90) value, dword zp($a2) sub)
ultoa_append: {
    .label buffer = $9b
    .label value = $90
    .label sub = $a2
    .label return = $90
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
// Return a pointer to the location of the cursor
cursorLocation: {
    .label __0 = $a6
    .label __1 = $a6
    .label __3 = $a6
    .label return = $a6
    .label __4 = $a8
    .label __5 = $a6
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
// memcpy(void* zp($99) destination, byte* zp($97) source)
memcpy: {
    .const num = $28*$17
    .label src_end = $a8
    .label dst = $99
    .label src = $97
    .label destination = $99
    .label source = $97
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
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_LONG: .dword $3b9aca00, $5f5e100, $989680, $f4240, $186a0, $2710, $3e8, $64, $a
  // create a static table to map char value to screen value
  // use KickAsm functions to create a table of code -> screen code values, using cc65 algorithm
rawmap:
.var ht = Hashtable().put(0,64, 1,0, 2,32, 3,96) // the table for converting bit 6,7 into ora value
	.for(var i=0; i<256; i++) {
		.var idx = (i & $60) / 32
		.var mask = i & $9f
		.byte mask | ht.get(idx)
	}

  entries: .word $78f, $7a4, $7c7, $591, $687, $601, $7c0, $621, $751, $730, $6b8, $791, $71f, $659, $6bf, $714, $6b2, $76c, $793, $78b, $79f, $6dc, $796, $64b, $7bb, $78a, $7cc, $7d0, $608, $6f4, $697, $6e0, $72c, $716, $69b, $719, $7ac, $76b, $629, $60b, $362, $618, $7c4, $641, $7b2, $6ca, $5e3, $683, $73b, $78d, $5eb, $740, $7b1, $744, $709, $7d7, $74a, $708, $6d5, $733, $6af, $5d7, $771, $2fb, $688, $742, $7c3, $5d4, $739, $7c9, $6c9, $752, $67a, $712, $681, $6e8, $79e, $757, $718, $74c, $7cb, $6e3, $6f7, $729, $7b0, $737, $6d4, $6bd, $763, $6db, $11e, $7b8, $7b9, $677, $710, $7c2, $6f3, $745, $7a1, $760, $700, $713, $750, $6fe, $72f, $7c1, $723, $732, $785, $6c7, $663, $71d, $71c, $7b5, $5fb, $6ea, $3b, $736, $78c, $773, $6c2, $3a5, $573, $6d9, $6d7, $169, $5fa, $6f6, $43f, $635, $789, $703, $717, $6c4, $6e5, $755, $6ba, $20e, $6ad, $6fd, $764, $779, $67e, $711, $686, $79b, $72b, $633, $6de, $7be, $7d9, $6dd, $29e, $7bf, $5f4, $756, $704, $7a0, $236, $782, $75a, $74e, $707, $6c3, $6bc, $70d, $7d3, $63c, $61e, $73d, $777, $741, $6cb, $6d0, $65b, $6c1, $6d1, $735, $62e, $75c, $75b, $795, $6e4, $695, $6ff, $72d, $6a1, $6ce, $6f5, $79c, $754, $7c5, $66b, $74f, $772, $6be, $7a6, $5de, $787, $79a
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
