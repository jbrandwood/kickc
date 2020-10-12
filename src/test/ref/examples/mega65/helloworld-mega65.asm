// Hello World for MEGA 65 - using stdio.h and conio.h
// Functions for performing input and output.
.cpu _45gs02
  // MEGA65 platform PRG executable starting in MEGA65 mode.
.file [name="helloworld-mega65.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$2001]
.segmentdef Code [start=$2017]
.segmentdef Data [startAfter="Code"]
.segment Basic
.byte $0a, $20, $0a, $00, $fe, $02, $20, $30, $00       // 10 BANK 0
.byte $15, $20, $14, $00, $9e, $20                      // 20 SYS 
.text toIntString(__start)                                   //         NNNN
.byte $00, $00, $00                                     // 
  // Map 2nd KB of colour RAM $DC00-$DFFF (hiding CIA's)
  .const CRAM2K = 1
  .const LIGHT_BLUE = $e
  // I/O Personality selection
  .label IO_KEY = $d02f
  // C65 Banking Register
  .label IO_BANK = $d030
  // Color Ram
  .label COLORRAM = $d800
  // Default address of screen character matrix
  .label DEFAULT_SCREEN = $800
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = 6
  // The current cursor y-position
  .label conio_cursor_y = 7
  // The current text cursor line start
  .label conio_line_text = 8
  // The current color cursor line start
  .label conio_line_color = $a
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
    // #pragma constructor_for(conio_mega65_init, cputc, clrscr, cscroll)
    jsr conio_mega65_init
    jsr main
    rts
}
// Enable 2K Color ROM
conio_mega65_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $eb
    // asm
    // Disable BASIC/KERNAL interrupts
    sei
    // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
    lda #0
    tax
    tay
    taz
    map
    eom
    // *IO_KEY = 0x47
    // Enable the VIC 4
    lda #$47
    sta IO_KEY
    // *IO_KEY = 0x53
    lda #$53
    sta IO_KEY
    // *IO_BANK |= CRAM2K
    // Enable 2K Color RAM
    lda #CRAM2K
    ora IO_BANK
    sta IO_BANK
    // line = *BASIC_CURSOR_LINE+1
    ldx BASIC_CURSOR_LINE
    inx
    // if(line>24)
    cpx #$18+1
    bcc __b1
    ldx #$18
  __b1:
    // gotoxy(0, line)
    jsr gotoxy
    // }
    rts
}
main: {
    // printf("hello world!")
    jsr cputs
    // }
    rts
  .segment Data
    s: .text "hello world!"
    .byte 0
}
.segment Code
// Set the cursor to the specified position
// gotoxy(byte register(X) y)
gotoxy: {
    .const x = 0
    .label __5 = $10
    .label __6 = $c
    .label __7 = $c
    .label line_offset = $c
    .label __8 = $e
    .label __9 = $c
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
    asw line_offset
    asw line_offset
    asw line_offset
    asw line_offset
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
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp(2) s)
cputs: {
    .label s = 2
    lda #<main.s
    sta.z s
    lda #>main.s
    sta.z s+1
  __b1:
    // while(c=*s++)
    ldy #0
    lda (s),y
    inw.z s
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // cputc(c)
    jsr cputc
    jmp __b1
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
    lda #$50
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
// Print a newline
cputln: {
    // conio_line_text +=  CONIO_WIDTH
    lda #$50
    clc
    adc.z conio_line_text
    sta.z conio_line_text
    bcc !+
    inc.z conio_line_text+1
  !:
    // conio_line_color += CONIO_WIDTH
    lda #$50
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
    lda #<DEFAULT_SCREEN+$50
    sta.z memcpy.source
    lda #>DEFAULT_SCREEN+$50
    sta.z memcpy.source+1
    jsr memcpy
    // memcpy(CONIO_SCREEN_COLORS, CONIO_SCREEN_COLORS+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH)
    lda #<COLORRAM
    sta.z memcpy.destination
    lda #>COLORRAM
    sta.z memcpy.destination+1
    lda #<COLORRAM+$50
    sta.z memcpy.source
    lda #>COLORRAM+$50
    sta.z memcpy.source+1
    jsr memcpy
    // memset(CONIO_SCREEN_TEXT+CONIO_BYTES-CONIO_WIDTH, ' ', CONIO_WIDTH)
    ldz #' '
    lda #<DEFAULT_SCREEN+$19*$50-$50
    sta.z memset.str
    lda #>DEFAULT_SCREEN+$19*$50-$50
    sta.z memset.str+1
    jsr memset
    // memset(CONIO_SCREEN_COLORS+CONIO_BYTES-CONIO_WIDTH, conio_textcolor, CONIO_WIDTH)
    ldz #LIGHT_BLUE
    lda #<COLORRAM+$19*$50-$50
    sta.z memset.str
    lda #>COLORRAM+$19*$50-$50
    sta.z memset.str+1
    jsr memset
    // conio_line_text -= CONIO_WIDTH
    sec
    lda.z conio_line_text
    sbc #$50
    sta.z conio_line_text
    lda.z conio_line_text+1
    sbc #0
    sta.z conio_line_text+1
    // conio_line_color -= CONIO_WIDTH
    sec
    lda.z conio_line_color
    sbc #$50
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
// memcpy(void* zp($14) destination, void* zp(4) source)
memcpy: {
    .label src_end = $12
    .label dst = $14
    .label src = 4
    .label source = 4
    .label destination = $14
    // src_end = (char*)source+num
    clc
    lda.z source
    adc #<$19*$50-$50
    sta.z src_end
    lda.z source+1
    adc #>$19*$50-$50
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
    inw.z dst
    inw.z src
    jmp __b1
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp(4) str, byte register(Z) c)
memset: {
    .label end = $14
    .label dst = 4
    .label str = 4
    // end = (char*)str + num
    lda #$50
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
    tza
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inw.z dst
    jmp __b2
}
