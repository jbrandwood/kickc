// 8 bit converted md5 calculator
  // Atari XL/XE executable XEX file with a single segment
// https://www.atarimax.com/jindroush.atari.org/afmtexe.html
.plugin "dk.camelot64.kickass.xexplugin.AtariXex"
.file [name="atarixl-md5.xex", type="bin", segments="XexFile"]
.segmentdef XexFile [segments="Program", modify="XexFormat", _RunAddr=main]
.segmentdef Program [segments="Code, Data"]
.segmentdef Code [start=$2000]
.segmentdef Data [startAfter="Code"]
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  /// 2-byte saved memory scan counter
  .label SAVMSC = $58
  /// data under cursor
  .label OLDCHR = $5d
  /// 2-byte saved cursor memory address
  .label OLDADR = $5e
  /// Cursor inhibit flag, 0 turns on, any other number turns off. Cursor doesn't change until it moves next.
  .label CRSINH = $2f0
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  /// Atari ZP registers
  /// 1-byte cursor row
  .label ROWCRS = $54
  /// 2-byte cursor column
  .label COLCRS = $55
  .label h0 = $e0
  .label h1 = $dc
  .label h2 = $d8
  .label h3 = $d2
.segment Code
main: {
    // printf("Calculating MD5\n")
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // strlen(message)
    lda #<message
    sta.z strlen.str
    lda #>message
    sta.z strlen.str+1
    jsr strlen
    // strlen(message)
    lda.z strlen.len
    sta.z strlen.return_1
    lda.z strlen.len+1
    sta.z strlen.return_1+1
    // md5(message, strlen(message))
    jsr md5
  __b1:
    jmp __b1
  .segment Data
  .encoding "ascii"
    message: .text "The quick brown fox jumps over the lazy dog"
    .byte 0
    s: .text @"Calculating MD5\$9b"
    .byte 0
}
.segment Code
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__zp($89) volatile char c)
cputc: {
    .const OFFSET_STACK_C = 0
    .label convertToScreenCode1_v = c
    .label c = $89
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    sta.z c
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
/// Print a NUL-terminated string
// void printf_str(__zp($ec) void (*putc)(char), __zp($8b) const char *s)
printf_str: {
    .label s = $8b
    .label putc = $ec
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
    // putc(c)
    pha
    jsr icall1
    pla
    jmp __b1
  icall1:
    jmp (putc)
}
// Computes the length of the string str up to but not including the terminating null character.
// __zp($e8) unsigned int strlen(__zp($8b) char *str)
strlen: {
    .label len = $8f
    .label str = $8b
    .label return = $8f
    .label return_1 = $e8
    lda #<0
    sta.z len
    sta.z len+1
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
// void md5(char *initial_msg, __zp($e8) unsigned int initial_len)
md5: {
    .label __0 = $d6
    .label __1 = $d6
    .label __2 = $d6
    .label __3 = $d6
    .label bits_len = $cd
    .label __26 = $9c
    .label __27 = $b5
    .label __28 = $b5
    .label __30 = $9c
    .label __31 = $b1
    .label __32 = $b1
    .label __34 = $a7
    .label __37 = $9c
    .label __39 = $a5
    .label __42 = $9c
    .label __43 = $9c
    .label __65 = $a9
    .label __66 = $a9
    .label __67 = $a9
    .label __71 = $d1
    .label __72 = $cc
    .label initial_len = $e8
    .label new_len = $d6
    .label msg = $c8
    .label w = $ea
    .label a = $a9
    .label b = $c3
    .label c = $bd
    .label d = $b9
    .label offset = $ca
    .label f = $9c
    .label g = $a0
    .label temp = $b9
    .label lr = $a1
    .label b_1 = $a1
    .label i = $c7
    .label __74 = $e4
    // initial_len + 8
    lda #8
    clc
    adc.z initial_len
    sta.z __0
    lda #0
    adc.z initial_len+1
    sta.z __0+1
    // (initial_len + 8) / 64
    lda.z __1
    asl
    sta.z $ff
    lda.z __1+1
    rol
    sta.z __1
    lda #0
    rol
    sta.z __1+1
    asl.z $ff
    rol.z __1
    rol.z __1+1
    // ((initial_len + 8) / 64) + 1
    inc.z __2
    bne !+
    inc.z __2+1
  !:
    // (((initial_len + 8) / 64) + 1) * 64
    lda.z __3+1
    lsr
    sta.z $ff
    lda.z __3
    ror
    sta.z __3+1
    lda #0
    ror
    sta.z __3
    lsr.z $ff
    ror.z __3+1
    ror.z __3
    // uint16_t new_len = ((((initial_len + 8) / 64) + 1) * 64) - 8
    sec
    lda.z new_len
    sbc #8
    sta.z new_len
    lda.z new_len+1
    sbc #0
    sta.z new_len+1
    // calloc(new_len + 64, 1)
    lda #$40
    clc
    adc.z new_len
    sta.z calloc.nitems
    lda #0
    adc.z new_len+1
    sta.z calloc.nitems+1
    jsr calloc
    // memcpy(msg, initial_msg, initial_len)
    lda.z msg
    sta.z memcpy.destination
    lda.z msg+1
    sta.z memcpy.destination+1
    lda.z initial_len
    sta.z memcpy.num
    lda.z initial_len+1
    sta.z memcpy.num+1
    lda #<main.message
    sta.z memcpy.source
    lda #>main.message
    sta.z memcpy.source+1
    jsr memcpy
    // msg[initial_len] = 128
    lda.z msg
    clc
    adc.z initial_len
    sta.z __74
    lda.z msg+1
    adc.z initial_len+1
    sta.z __74+1
    lda #$80
    ldy #0
    sta (__74),y
    // uint32_t bits_len = initial_len * 8
    lda.z initial_len
    asl
    sta.z bits_len
    lda.z initial_len+1
    rol
    sta.z bits_len+1
    tya
    sta.z bits_len+3
    rol
    sta.z bits_len+2
    asl.z bits_len
    rol.z bits_len+1
    rol.z bits_len+2
    rol.z bits_len+3
    asl.z bits_len
    rol.z bits_len+1
    rol.z bits_len+2
    rol.z bits_len+3
    // msg + new_len
    lda.z msg
    clc
    adc.z new_len
    sta.z memcpy.destination_1
    lda.z msg+1
    adc.z new_len+1
    sta.z memcpy.destination_1+1
    lda.z memcpy.destination_1
    sta.z memcpy.destination
    lda.z memcpy.destination_1+1
    sta.z memcpy.destination+1
    // memcpy(msg + new_len, &bits_len, 4)
    lda #<4
    sta.z memcpy.num
    tya
    sta.z memcpy.num+1
    lda #<bits_len
    sta.z memcpy.source
    lda #>bits_len
    sta.z memcpy.source+1
    jsr memcpy
    lda #<$10325476
    sta.z h3
    lda #>$10325476
    sta.z h3+1
    lda #<$10325476>>$10
    sta.z h3+2
    lda #>$10325476>>$10
    sta.z h3+3
    lda #<$98badcfe
    sta.z h2
    lda #>$98badcfe
    sta.z h2+1
    lda #<$98badcfe>>$10
    sta.z h2+2
    lda #>$98badcfe>>$10
    sta.z h2+3
    lda #<$efcdab89
    sta.z h1
    lda #>$efcdab89
    sta.z h1+1
    lda #<$efcdab89>>$10
    sta.z h1+2
    lda #>$efcdab89>>$10
    sta.z h1+3
    lda #<$67452301
    sta.z h0
    lda #>$67452301
    sta.z h0+1
    lda #<$67452301>>$10
    sta.z h0+2
    lda #>$67452301>>$10
    sta.z h0+3
    lda #<0
    sta.z offset
    sta.z offset+1
  __b1:
    // for(int offset=0; offset<new_len; offset += (512/8))
    lda.z offset+1
    bmi __b2
    cmp.z new_len+1
    bcc __b2
    bne !+
    lda.z offset
    cmp.z new_len
    bcc __b2
  !:
    // }
    rts
  __b2:
    // msg + offset
    lda.z msg
    clc
    adc.z offset
    sta.z w
    lda.z msg+1
    adc.z offset+1
    sta.z w+1
    // uint32_t a = h0
    lda.z h0
    sta.z a
    lda.z h0+1
    sta.z a+1
    lda.z h0+2
    sta.z a+2
    lda.z h0+3
    sta.z a+3
    // uint32_t b = h1
    lda.z h1
    sta.z b
    lda.z h1+1
    sta.z b+1
    lda.z h1+2
    sta.z b+2
    lda.z h1+3
    sta.z b+3
    // uint32_t c = h2
    lda.z h2
    sta.z c
    lda.z h2+1
    sta.z c+1
    lda.z h2+2
    sta.z c+2
    lda.z h2+3
    sta.z c+3
    // uint32_t d = h3
    lda.z h3
    sta.z d
    lda.z h3+1
    sta.z d+1
    lda.z h3+2
    sta.z d+2
    lda.z h3+3
    sta.z d+3
    lda #0
    sta.z i
  __b3:
    // for(uint8_t i = 0; i<64; i++)
    lda.z i
    cmp #$40
    bcc __b4
    // h0 += a
    clc
    lda.z h0
    adc.z a
    sta.z h0
    lda.z h0+1
    adc.z a+1
    sta.z h0+1
    lda.z h0+2
    adc.z a+2
    sta.z h0+2
    lda.z h0+3
    adc.z a+3
    sta.z h0+3
    // h1 += b
    clc
    lda.z h1
    adc.z b
    sta.z h1
    lda.z h1+1
    adc.z b+1
    sta.z h1+1
    lda.z h1+2
    adc.z b+2
    sta.z h1+2
    lda.z h1+3
    adc.z b+3
    sta.z h1+3
    // h2 += c
    clc
    lda.z h2
    adc.z c
    sta.z h2
    lda.z h2+1
    adc.z c+1
    sta.z h2+1
    lda.z h2+2
    adc.z c+2
    sta.z h2+2
    lda.z h2+3
    adc.z c+3
    sta.z h2+3
    // h3 += d
    clc
    lda.z h3
    adc.z temp
    sta.z h3
    lda.z h3+1
    adc.z temp+1
    sta.z h3+1
    lda.z h3+2
    adc.z temp+2
    sta.z h3+2
    lda.z h3+3
    adc.z temp+3
    sta.z h3+3
    // offset += (512/8)
    lda.z offset
    clc
    adc #<$200/8
    sta.z offset
    lda.z offset+1
    adc #>$200/8
    sta.z offset+1
    jmp __b1
  __b4:
    // printf("%2x: ", i)
    ldx.z i
    lda #0
    sta.z printf_uchar.format_zero_padding
    jsr printf_uchar
    // printf("%2x: ", i)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // print32(a)
    lda.z a
    sta.z print32.l
    lda.z a+1
    sta.z print32.l+1
    lda.z a+2
    sta.z print32.l+2
    lda.z a+3
    sta.z print32.l+3
    jsr print32
    // cputc(' ')
    lda #' '
    pha
    jsr cputc
    pla
    // print32(b)
    lda.z b
    sta.z print32.l
    lda.z b+1
    sta.z print32.l+1
    lda.z b+2
    sta.z print32.l+2
    lda.z b+3
    sta.z print32.l+3
    jsr print32
    // cputc(' ')
    lda #' '
    pha
    jsr cputc
    pla
    // print32(c)
    lda.z c
    sta.z print32.l
    lda.z c+1
    sta.z print32.l+1
    lda.z c+2
    sta.z print32.l+2
    lda.z c+3
    sta.z print32.l+3
    jsr print32
    // cputc(' ')
    lda #' '
    pha
    jsr cputc
    pla
    // print32(d)
    lda.z temp
    sta.z print32.l
    lda.z temp+1
    sta.z print32.l+1
    lda.z temp+2
    sta.z print32.l+2
    lda.z temp+3
    sta.z print32.l+3
    jsr print32
    // cputln()
    jsr cputln
    // kickasm
    .break 
    // i >> 4
    lda.z i
    lsr
    lsr
    lsr
    lsr
    // (i >> 4) & 3
    and #3
    // case 0:    // (i < 16)
    //                     f = (b & c) | ((~b) & d);
    //                     g = i;
    //                     break;
    cmp #0
    bne !__b6+
    jmp __b6
  !__b6:
    // case 1:    // (i < 32)
    //                     f = (d & b) | ((~d) & c);
    //                     g = mod16(mul5(i) + 1);
    //                     break;
    cmp #1
    bne !__b7+
    jmp __b7
  !__b7:
    // case 2:    // (i < 48)
    //                     f = b ^ c ^ d;
    //                     g = mod16(mul3(i) + 5);
    //                     break;
    cmp #2
    bne !__b8+
    jmp __b8
  !__b8:
    // case 3:    // other
    //                     f = c ^ (b | (~d));
    //                     g = mod16(mul7(i));
    //                     break;
    cmp #3
    bne !__b9+
    jmp __b9
  !__b9:
    lda #0
    sta.z g
    sta.z f
    sta.z f+1
    lda #<0>>$10
    sta.z f+2
    lda #>0>>$10
    sta.z f+3
  __b10:
    // printf("f: ")
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // print32(f)
    lda.z f
    sta.z print32.l
    lda.z f+1
    sta.z print32.l+1
    lda.z f+2
    sta.z print32.l+2
    lda.z f+3
    sta.z print32.l+3
    jsr print32
    // cputc(' ')
    lda #' '
    pha
    jsr cputc
    pla
    // printf("g:%2x w[g]:", g)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // printf("g:%2x w[g]:", g)
    ldx.z g
    lda #0
    sta.z printf_uchar.format_zero_padding
    jsr printf_uchar
    // printf("g:%2x w[g]:", g)
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // print32(w[g])
    lda.z g
    asl
    asl
    sta.z __71
    tay
    lda (w),y
    sta.z print32.l
    iny
    lda (w),y
    sta.z print32.l+1
    iny
    lda (w),y
    sta.z print32.l+2
    iny
    lda (w),y
    sta.z print32.l+3
    jsr print32
    // cputln()
    jsr cputln
    // kickasm
    .break 
    // cputs("L ")
    jsr cputs
    // print32(a)
    lda.z a
    sta.z print32.l
    lda.z a+1
    sta.z print32.l+1
    lda.z a+2
    sta.z print32.l+2
    lda.z a+3
    sta.z print32.l+3
    jsr print32
    // cputc(' ')
    lda #' '
    pha
    jsr cputc
    pla
    // print32(f)
    lda.z f
    sta.z print32.l
    lda.z f+1
    sta.z print32.l+1
    lda.z f+2
    sta.z print32.l+2
    lda.z f+3
    sta.z print32.l+3
    jsr print32
    // cputc(' ')
    lda #' '
    pha
    jsr cputc
    pla
    // print32(k[i])
    lda.z i
    asl
    asl
    sta.z __72
    tay
    lda k,y
    sta.z print32.l
    lda k+1,y
    sta.z print32.l+1
    lda k+2,y
    sta.z print32.l+2
    lda k+3,y
    sta.z print32.l+3
    jsr print32
    // cputc(' ')
    lda #' '
    pha
    jsr cputc
    pla
    // print32(w[g])
    ldy.z __71
    lda (w),y
    sta.z print32.l
    iny
    lda (w),y
    sta.z print32.l+1
    iny
    lda (w),y
    sta.z print32.l+2
    iny
    lda (w),y
    sta.z print32.l+3
    jsr print32
    // cputc(' ')
    lda #' '
    pha
    jsr cputc
    pla
    // printf("r: %2x\n", r[i])
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // printf("r: %2x\n", r[i])
    ldy.z i
    ldx r,y
    lda #0
    sta.z printf_uchar.format_zero_padding
    jsr printf_uchar
    // printf("r: %2x\n", r[i])
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s6
    sta.z printf_str.s
    lda #>s6
    sta.z printf_str.s+1
    jsr printf_str
    // kickasm
    .break 
    // a + f
    clc
    lda.z __65
    adc.z f
    sta.z __65
    lda.z __65+1
    adc.z f+1
    sta.z __65+1
    lda.z __65+2
    adc.z f+2
    sta.z __65+2
    lda.z __65+3
    adc.z f+3
    sta.z __65+3
    // a + f + k[i]
    ldy.z __72
    clc
    lda.z __66
    adc k,y
    sta.z __66
    lda.z __66+1
    adc k+1,y
    sta.z __66+1
    lda.z __66+2
    adc k+2,y
    sta.z __66+2
    lda.z __66+3
    adc k+3,y
    sta.z __66+3
    // a + f + k[i] + w[g]
    ldy.z __71
    lda.z __67
    clc
    adc (w),y
    sta.z __67
    iny
    lda.z __67+1
    adc (w),y
    sta.z __67+1
    iny
    lda.z __67+2
    adc (w),y
    sta.z __67+2
    iny
    lda.z __67+3
    adc (w),y
    sta.z __67+3
    // uint32_t lr = leftRotate((a + f + k[i] + w[g]), r[i])
    lda.z __67
    sta.z leftRotate.a
    lda.z __67+1
    sta.z leftRotate.a+1
    lda.z __67+2
    sta.z leftRotate.a+2
    lda.z __67+3
    sta.z leftRotate.a+3
    ldy.z i
    lda r,y
    sta.z leftRotate.r
    //b = b + LEFTROTATE((a + f + k[i] + w[g]), r[i]);
    jsr leftRotate
    // b += lr
    clc
    lda.z b_1
    adc.z b
    sta.z b_1
    lda.z b_1+1
    adc.z b+1
    sta.z b_1+1
    lda.z b_1+2
    adc.z b+2
    sta.z b_1+2
    lda.z b_1+3
    adc.z b+3
    sta.z b_1+3
    // for(uint8_t i = 0; i<64; i++)
    inc.z i
    lda.z temp
    sta.z a
    lda.z temp+1
    sta.z a+1
    lda.z temp+2
    sta.z a+2
    lda.z temp+3
    sta.z a+3
    lda.z b_1
    sta.z b
    lda.z b_1+1
    sta.z b+1
    lda.z b_1+2
    sta.z b+2
    lda.z b_1+3
    sta.z b+3
    lda.z b
    sta.z c
    lda.z b+1
    sta.z c+1
    lda.z b+2
    sta.z c+2
    lda.z b+3
    sta.z c+3
    lda.z c
    sta.z temp
    lda.z c+1
    sta.z temp+1
    lda.z c+2
    sta.z temp+2
    lda.z c+3
    sta.z temp+3
    jmp __b3
  __b9:
    // ~d
    lda.z temp
    eor #$ff
    sta.z __42
    lda.z temp+1
    eor #$ff
    sta.z __42+1
    lda.z temp+2
    eor #$ff
    sta.z __42+2
    lda.z temp+3
    eor #$ff
    sta.z __42+3
    // b | (~d)
    lda.z b
    ora.z __43
    sta.z __43
    lda.z b+1
    ora.z __43+1
    sta.z __43+1
    lda.z b+2
    ora.z __43+2
    sta.z __43+2
    lda.z b+3
    ora.z __43+3
    sta.z __43+3
    // f = c ^ (b | (~d))
    lda.z f
    eor.z c
    sta.z f
    lda.z f+1
    eor.z c+1
    sta.z f+1
    lda.z f+2
    eor.z c+2
    sta.z f+2
    lda.z f+3
    eor.z c+3
    sta.z f+3
    // mul7(i)
    lda.z i
    jsr mul7
    // mod16(mul7(i))
    lda.z mul7.return
    sta.z mod16.a
    lda.z mul7.return+1
    sta.z mod16.a+1
    jsr mod16
    // mod16(mul7(i))
    // g = mod16(mul7(i))
    sta.z g
    jmp __b10
  __b8:
    // b ^ c
    lda.z b
    eor.z c
    sta.z __37
    lda.z b+1
    eor.z c+1
    sta.z __37+1
    lda.z b+2
    eor.z c+2
    sta.z __37+2
    lda.z b+3
    eor.z c+3
    sta.z __37+3
    // f = b ^ c ^ d
    lda.z f
    eor.z temp
    sta.z f
    lda.z f+1
    eor.z temp+1
    sta.z f+1
    lda.z f+2
    eor.z temp+2
    sta.z f+2
    lda.z f+3
    eor.z temp+3
    sta.z f+3
    // mul3(i)
    lda.z i
    jsr mul3
    // mod16(mul3(i) + 5)
    lda #5
    clc
    adc.z __39
    sta.z mod16.a
    lda #0
    adc.z __39+1
    sta.z mod16.a+1
    jsr mod16
    // mod16(mul3(i) + 5)
    // g = mod16(mul3(i) + 5)
    sta.z g
    jmp __b10
  __b7:
    // d & b
    lda.z temp
    and.z b
    sta.z __30
    lda.z temp+1
    and.z b+1
    sta.z __30+1
    lda.z temp+2
    and.z b+2
    sta.z __30+2
    lda.z temp+3
    and.z b+3
    sta.z __30+3
    // ~d
    lda.z temp
    eor #$ff
    sta.z __31
    lda.z temp+1
    eor #$ff
    sta.z __31+1
    lda.z temp+2
    eor #$ff
    sta.z __31+2
    lda.z temp+3
    eor #$ff
    sta.z __31+3
    // (~d) & c
    lda.z __32
    and.z c
    sta.z __32
    lda.z __32+1
    and.z c+1
    sta.z __32+1
    lda.z __32+2
    and.z c+2
    sta.z __32+2
    lda.z __32+3
    and.z c+3
    sta.z __32+3
    // f = (d & b) | ((~d) & c)
    lda.z __32
    ora.z f
    sta.z f
    lda.z __32+1
    ora.z f+1
    sta.z f+1
    lda.z __32+2
    ora.z f+2
    sta.z f+2
    lda.z __32+3
    ora.z f+3
    sta.z f+3
    // mul5(i)
    lda.z i
    jsr mul5
    // mod16(mul5(i) + 1)
    clc
    lda.z __34
    adc #1
    sta.z mod16.a
    lda.z __34+1
    adc #0
    sta.z mod16.a+1
    jsr mod16
    // mod16(mul5(i) + 1)
    // g = mod16(mul5(i) + 1)
    sta.z g
    jmp __b10
  __b6:
    // b & c
    lda.z b
    and.z c
    sta.z __26
    lda.z b+1
    and.z c+1
    sta.z __26+1
    lda.z b+2
    and.z c+2
    sta.z __26+2
    lda.z b+3
    and.z c+3
    sta.z __26+3
    // ~b
    lda.z b
    eor #$ff
    sta.z __27
    lda.z b+1
    eor #$ff
    sta.z __27+1
    lda.z b+2
    eor #$ff
    sta.z __27+2
    lda.z b+3
    eor #$ff
    sta.z __27+3
    // (~b) & d
    lda.z __28
    and.z temp
    sta.z __28
    lda.z __28+1
    and.z temp+1
    sta.z __28+1
    lda.z __28+2
    and.z temp+2
    sta.z __28+2
    lda.z __28+3
    and.z temp+3
    sta.z __28+3
    // f = (b & c) | ((~b) & d)
    lda.z __28
    ora.z f
    sta.z f
    lda.z __28+1
    ora.z f+1
    sta.z f+1
    lda.z __28+2
    ora.z f+2
    sta.z f+2
    lda.z __28+3
    ora.z f+3
    sta.z f+3
    lda.z i
    sta.z g
    jmp __b10
  .segment Data
    r: .byte 7, $c, $11, $16, 7, $c, $11, $16, 7, $c, $11, $16, 7, $c, $11, $16, 5, 9, $e, $14, 5, 9, $e, $14, 5, 9, $e, $14, 5, 9, $e, $14, 4, $b, $10, $17, 4, $b, $10, $17, 4, $b, $10, $17, 4, $b, $10, $17, 6, $a, $f, $15, 6, $a, $f, $15, 6, $a, $f, $15, 6, $a, $f, $15
    k: .dword $d76aa478, $e8c7b756, $242070db, $c1bdceee, $f57c0faf, $4787c62a, $a8304613, $fd469501, $698098d8, $8b44f7af, $ffff5bb1, $895cd7be, $6b901122, $fd987193, $a679438e, $49b40821, $f61e2562, $c040b340, $265e5a51, $e9b6c7aa, $d62f105d, $2441453, $d8a1e681, $e7d3fbc8, $21e1cde6, $c33707d6, $f4d50d87, $455a14ed, $a9e3e905, $fcefa3f8, $676f02d9, $8d2a4c8a, $fffa3942, $8771f681, $6d9d6122, $fde5380c, $a4beea44, $4bdecfa9, $f6bb4b60, $bebfbc70, $289b7ec6, $eaa127fa, $d4ef3085, $4881d05, $d9d4d039, $e6db99e5, $1fa27cf8, $c4ac5665, $f4292244, $432aff97, $ab9423a7, $fc93a039, $655b59c3, $8f0ccc92, $ffeff47d, $85845dd1, $6fa87e4f, $fe2ce6e0, $a3014314, $4e0811a1, $f7537e82, $bd3af235, $2ad7d2bb, $eb86d391
    s: .text ": "
    .byte 0
    s1: .text "f: "
    .byte 0
    s2: .text "g:"
    .byte 0
    s3: .text " w[g]:"
    .byte 0
    s4: .text "L "
    .byte 0
    s5: .text "r: "
    .byte 0
    s6: .text @"\$9b"
    .byte 0
}
.segment Code
// Puts a character to the screen a the current location. Uses internal screencode. Deals with storing the old cursor value
// void putchar(char code)
putchar: {
    .label loc = $84
    // **OLDADR = *OLDCHR
    lda OLDCHR
    ldy OLDADR
    sty.z $fe
    ldy OLDADR+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // char * loc = cursorLocation()
    jsr cursorLocation
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
// Handles cursor movement, displaying it if required, and inverting character it is over if there is one (and enabled)
setcursor: {
    .label loc = $84
    // **OLDADR = *OLDCHR
    // save the current oldchr into oldadr
    lda OLDCHR
    ldy OLDADR
    sty.z $fe
    ldy OLDADR+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // char * loc = cursorLocation()
    // work out the new location for oldadr based on new column/row
    jsr cursorLocation
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
newline: {
    .label start = $80
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
    // memcpy(start, start + CONIO_WIDTH, CONIO_WIDTH * 23)
    lda #<$28*$17
    sta.z memcpy.num
    lda #>$28*$17
    sta.z memcpy.num+1
    jsr memcpy
    // start + CONIO_WIDTH * 23
    lda.z memset.str
    clc
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
// Allocates memory and returns a pointer to it. Sets allocated memory to zero.
// - nitems − This is the number of elements to be allocated.
// - size − This is the size of elements.
// __zp($c8) void * calloc(__zp($c1) unsigned int nitems, unsigned int size)
calloc: {
    .label return = $c8
    .label nitems = $c1
    // void* mem = malloc(nitems*size)
    jsr malloc
    // memset(mem, 0, nitems*size)
    lda.z nitems
    sta.z memset.num
    lda.z nitems+1
    sta.z memset.num+1
    lda.z return
    sta.z memset.str
    lda.z return+1
    sta.z memset.str+1
    jsr memset
    // }
    rts
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// void * memcpy(__zp($84) void *destination, __zp($82) char *source, __zp($86) unsigned int num)
memcpy: {
    .label src_end = $86
    .label dst = $84
    .label src = $82
    .label destination = $84
    .label source = $82
    .label num = $86
    .label destination_1 = $e6
    // char* src_end = (char*)source+num
    clc
    lda.z src_end
    adc.z source
    sta.z src_end
    lda.z src_end+1
    adc.z source+1
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
// Print an unsigned char using a specific format
// void printf_uchar(void (*putc)(char), __register(X) char uvalue, char format_min_length, char format_justify_left, char format_sign_always, __zp($92) char format_zero_padding, char format_upper_case, char format_radix)
printf_uchar: {
    .label format_zero_padding = $92
    // printf_buffer.sign = format.sign_always?'+':0
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
  // Format number into buffer
    jsr uctoa
    // printf_number_buffer(putc, printf_buffer, format)
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    jsr printf_number_buffer
    // }
    rts
}
// void print32(__zp($93) volatile unsigned long l)
print32: {
    .label dp = l
    .label l = $93
    // printf("%02x%02x%02x%02x", dp[0], dp[1], dp[2], dp[3])
    ldx.z dp
    lda #1
    sta.z printf_uchar.format_zero_padding
    jsr printf_uchar
    // printf("%02x%02x%02x%02x", dp[0], dp[1], dp[2], dp[3])
    ldx dp+1
    lda #1
    sta.z printf_uchar.format_zero_padding
    jsr printf_uchar
    // printf("%02x%02x%02x%02x", dp[0], dp[1], dp[2], dp[3])
    ldx dp+2
    lda #1
    sta.z printf_uchar.format_zero_padding
    jsr printf_uchar
    // printf("%02x%02x%02x%02x", dp[0], dp[1], dp[2], dp[3])
    ldx dp+3
    lda #1
    sta.z printf_uchar.format_zero_padding
    jsr printf_uchar
    // }
    rts
}
// Print a newline
cputln: {
    // *COLCRS = 0
    lda #<0
    sta COLCRS
    sta COLCRS+1
    // newline()
    jsr newline
    // }
    rts
}
// Output a NUL-terminated string at the current cursor position
// void cputs(__zp($8f) const char *s)
cputs: {
    .label s = $8f
    lda #<md5.s4
    sta.z s
    lda #>md5.s4
    sta.z s+1
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
    pha
    jsr cputc
    pla
    jmp __b1
}
// __zp($a1) unsigned long leftRotate(__zp($97) volatile unsigned long a, __zp($92) char r)
leftRotate: {
    .label p = a
    .label result = p
    .label a = $97
    .label return = $a1
    .label r = $92
    // if (r < 8)
    lda.z r
    cmp #8
    bcc __b1
    // if (r == 8)
    lda #8
    cmp.z r
    beq __b2
    // if (r < 16)
    lda.z r
    cmp #$10
    bcc __b3
    // if (r == 16)
    lda #$10
    cmp.z r
    beq __b4
    // move16Left(p)
    // in md5, everything is under 24 bits
    jsr move16Left
    // r - 16
    lax.z r
    axs #$10
    // rotateLeft(p, r - 16)
    lda #<p
    sta.z rotateLeft.p
    lda #>p
    sta.z rotateLeft.p+1
    stx.z rotateLeft.r
    jsr rotateLeft
  __b5:
    // return *result;
    lda.z result
    sta.z return
    lda.z result+1
    sta.z return+1
    lda.z result+2
    sta.z return+2
    lda.z result+3
    sta.z return+3
    // }
    rts
  __b4:
    // move16Left(p)
    jsr move16Left
    jmp __b5
  __b3:
    // move8Left(p)
    jsr move8Left
    // r - 8
    lax.z r
    axs #8
    // rotateLeft(p, r - 8)
    lda #<p
    sta.z rotateLeft.p
    lda #>p
    sta.z rotateLeft.p+1
    stx.z rotateLeft.r
    jsr rotateLeft
    jmp __b5
  __b2:
    // move8Left(p)
    jsr move8Left
    jmp __b5
  __b1:
    // rotateLeft(p, r)
    lda #<p
    sta.z rotateLeft.p
    lda #>p
    sta.z rotateLeft.p+1
    lda.z r
    sta.z rotateLeft.r
    jsr rotateLeft
    jmp __b5
}
// __zp($ad) unsigned int mul7(__register(A) char a)
mul7: {
    .label __1 = $8f
    .label return = $ad
    .label __2 = $8b
    .label __3 = $8b
    .label __4 = $8b
    // ((uint16_t) a) * 7
    sta.z __1
    lda #0
    sta.z __1+1
    lda.z __1
    asl
    sta.z __2
    lda.z __1+1
    rol
    sta.z __2+1
    clc
    lda.z __3
    adc.z __1
    sta.z __3
    lda.z __3+1
    adc.z __1+1
    sta.z __3+1
    asl.z __4
    rol.z __4+1
    lda.z __4
    clc
    adc.z __1
    sta.z return
    lda.z __4+1
    adc.z __1+1
    sta.z return+1
    // }
    rts
}
// __register(A) char mod16(__zp($8b) unsigned int a)
mod16: {
    .label t = $8b
    .label a = $8b
    // uint16_t t = a % 16
    lda #$10-1
    and.z t
    sta.z t
    lda #0
    sta.z t+1
    // return (uint8_t) (t & 0xff);
    lda #$ff
    and.z t
    // }
    rts
}
// __zp($a5) unsigned int mul3(__register(A) char a)
mul3: {
    .label __1 = $8f
    .label return = $a5
    .label __2 = $8b
    // ((uint16_t) a) * 3
    sta.z __1
    lda #0
    sta.z __1+1
    lda.z __1
    asl
    sta.z __2
    lda.z __1+1
    rol
    sta.z __2+1
    lda.z __2
    clc
    adc.z __1
    sta.z return
    lda.z __2+1
    adc.z __1+1
    sta.z return+1
    // }
    rts
}
// __zp($a7) unsigned int mul5(__register(A) char a)
mul5: {
    .label __1 = $8b
    .label return = $a7
    .label __2 = $8f
    // ((uint16_t) a) * 5
    sta.z __1
    lda #0
    sta.z __1+1
    lda.z __1
    asl
    sta.z __2
    lda.z __1+1
    rol
    sta.z __2+1
    asl.z __2
    rol.z __2+1
    lda.z __2
    clc
    adc.z __1
    sta.z return
    lda.z __2+1
    adc.z __1+1
    sta.z return+1
    // }
    rts
}
// Return a pointer to the location of the cursor
cursorLocation: {
    .label __0 = $84
    .label __1 = $84
    .label __3 = $84
    .label return = $84
    .label __4 = $86
    .label __5 = $84
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(__zp($80) void *str, char c, __zp($82) unsigned int num)
memset: {
    .label end = $82
    .label dst = $80
    .label str = $80
    .label num = $82
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
// Allocates a block of size chars of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
// void * malloc(__zp($c1) unsigned int size)
malloc: {
    .label mem = $c8
    .label size = $c1
    // unsigned char* mem = heap_head-size
    sec
    lda #<HEAP_TOP
    sbc.z size
    sta.z mem
    lda #>HEAP_TOP
    sbc.z size+1
    sta.z mem+1
    // }
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void uctoa(__register(X) char value, __zp($8b) char *buffer, char radix)
uctoa: {
    .label digit_value = $88
    .label buffer = $8b
    .label digit = $8e
    .label started = $8d
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
    cmp #2-1
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
    // unsigned char digit_value = digit_values[digit]
    ldy.z digit
    lda RADIX_HEXADECIMAL_VALUES_CHAR,y
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
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// void printf_number_buffer(void (*putc)(char), __zp($91) char buffer_sign, char *buffer_digits, char format_min_length, char format_justify_left, char format_sign_always, __zp($92) char format_zero_padding, char format_upper_case, char format_radix)
printf_number_buffer: {
    .const format_min_length = 2
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label putc = cputc
    .label __19 = $8f
    .label buffer_sign = $91
    .label format_zero_padding = $92
    .label padding = $8e
    // strlen(buffer.digits)
    lda #<buffer_digits
    sta.z strlen.str
    lda #>buffer_digits
    sta.z strlen.str+1
    jsr strlen
    // strlen(buffer.digits)
    // signed char len = (signed char)strlen(buffer.digits)
    // There is a minimum length - work out the padding
    ldx.z __19
    // if(buffer.sign)
    lda.z buffer_sign
    beq __b10
    // len++;
    inx
  __b10:
    // padding = (signed char)format.min_length - len
    txa
    eor #$ff
    sec
    adc #format_min_length
    sta.z padding
    // if(padding<0)
    cmp #0
    bpl __b1
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
    // printf_padding(putc, ' ',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __b2:
    // if(buffer.sign)
    lda.z buffer_sign
    beq __b3
    // putc(buffer.sign)
    pha
    jsr cputc
    pla
  __b3:
    // if(format.zero_padding && padding)
    lda.z format_zero_padding
    beq __b4
    lda.z padding
    cmp #0
    bne __b9
    jmp __b4
  __b9:
    // printf_padding(putc, '0',(char)padding)
    lda.z padding
    sta.z printf_padding.length
    lda #'0'
    sta.z printf_padding.pad
    jsr printf_padding
  __b4:
    // printf_str(putc, buffer.digits)
    lda #<putc
    sta.z printf_str.putc
    lda #>putc
    sta.z printf_str.putc+1
    lda #<buffer_digits
    sta.z printf_str.s
    lda #>buffer_digits
    sta.z printf_str.s+1
    jsr printf_str
    // }
    rts
}
// void move16Left(char *p)
move16Left: {
    // uint8_t s = *p
    ldy.z leftRotate.p
    // uint8_t t = *(p + 1)
    ldx leftRotate.p+1
    // *(p + 0) = *(p + 2)
    lda leftRotate.p+2
    sta.z leftRotate.p
    // *(p + 1) = *(p + 3)
    lda leftRotate.p+3
    sta leftRotate.p+1
    // *(p + 2) = s
    sty leftRotate.p+2
    // *(p + 3) = t
    stx leftRotate.p+3
    // }
    rts
}
// void rotateLeft(__zp($af) char * volatile const p, __zp($9b) volatile char r)
rotateLeft: {
    .label p = $af
    .label r = $9b
    // kickasm
    ldx #r
		!s:
			asl p+3
			rol p+2
			rol p+1
			rol p
			bcc !+
			lda p+3
			adc #0
		!:
			dex
			bne !s-
	
    // }
    rts
}
// void move8Left(char *p)
move8Left: {
    // uint8_t t = *p
    ldx.z leftRotate.p
    // *(p + 0) = *(p + 1)
    lda leftRotate.p+1
    sta.z leftRotate.p
    // *(p + 1) = *(p + 2)
    lda leftRotate.p+2
    sta leftRotate.p+1
    // *(p + 2) = *(p + 3)
    lda leftRotate.p+3
    sta leftRotate.p+2
    // *(p + 3) = t
    stx leftRotate.p+3
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
// __register(X) char uctoa_append(__zp($8b) char *buffer, __register(X) char value, __zp($88) char sub)
uctoa_append: {
    .label buffer = $8b
    .label sub = $88
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
// Print a padding char a number of times
// void printf_padding(void (*putc)(char), __zp($88) char pad, __zp($8d) char length)
printf_padding: {
    .label i = $8a
    .label length = $8d
    .label pad = $88
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
    // putc(pad)
    lda.z pad
    pha
    jsr cputc
    pla
    // for(char i=0;i<length; i++)
    inc.z i
    jmp __b1
}
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_CHAR: .byte $10
  // create a static table to map char value to screen value
  // use KickAsm functions to create a table of code -> screen code values, using cc65 algorithm
rawmap:
.var ht = Hashtable().put(0,64, 1,0, 2,32, 3,96) // the table for converting bit 6,7 into ora value
	.for(var i=0; i<256; i++) {
		.var idx = (i & $60) / 32
		.var mask = i & $9f
		.byte mask | ht.get(idx)
	}

  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
