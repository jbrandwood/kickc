/**
 * @file memfast.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief Demonstration of functions memcpy_fast and memset_fast
 * for 8 bit architectures.
 * @version 0.1
 * @date 2023-04-14
 * 
 * @copyright Copyright (c) 2023
 * 
 */
  // Commodore 64 PRG executable file
.file [name="memfast.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const LIGHT_BLUE = $e
  /// Color Ram
  .label COLORRAM = $d800
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
.segment Code
__start: {
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
    lda.z BASIC_CURSOR_LINE
    // if(line>=CONIO_HEIGHT)
    cmp #$19
    bcc __b1
    lda #$19-1
  __b1:
    // gotoxy(0, line)
    jsr gotoxy
    // }
    rts
}
main: {
    .label screen = $400
    .label bottom = $400+$28*$c
    // *((char*)0xd018) = 0x17
    // Show mixed chars on screen
    lda #$17
    sta $d018
    // clrscr()
  // Clear screen
    jsr clrscr
    ldy #0
  __b1:
    ldx #<$100
  memset_fast1___b1:
    // *(destination+num) = c
    tya
    sta screen,x
    // num--;
    dex
    // while(num)
    cpx #0
    bne memset_fast1___b1
    // memcpy_fast(bottom, screen, 256)
  // 256 will be truncated to 0, which will copy 256 bytes!
    jsr memcpy_fast
    // for(char i:0..255)
    iny
    cpy #0
    bne __b1
    // }
    rts
}
// Set the cursor to the specified position
// void gotoxy(char x, __register(A) char y)
gotoxy: {
    // if(y>CONIO_HEIGHT)
    cmp #$19+1
    // }
    rts
}
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = 4
    .label line_cols = 2
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
    bcc __b4
    // }
    rts
  __b4:
    ldy #0
  __b2:
    // for( char c=0;c<CONIO_WIDTH; c++ )
    cpy #$28
    bcc __b3
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
  __b3:
    // line_text[c] = ' '
    lda #' '
    sta (line_text),y
    // line_cols[c] = conio_textcolor
    lda #LIGHT_BLUE
    sta (line_cols),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    iny
    jmp __b2
}
/**
 * @brief Fast copy of data from a source to a destination memory address.
 * Since the amount of bytes to be copied is a byte long, it can be executed very fast.
 * The parameter num can have a value 0, which in case is equal to 256,
 * which allows 256 bytes to be copied using one single byte counter!
 * Depending on the optimization of the compiler, this implementation can
 * result in very fast code, but it should be inlined!
 * 
 * @param destination The memory address as the destination.
 * @param source The memory address as the source.
 * @param num The amount of bytes to be copied. A value of 0 will copy 256 bytes!!!
 * @return void* The resulting destination memory address.
 */
// char * memcpy_fast(char *destination, char *source, __register(X) char num)
memcpy_fast: {
    ldx #<$100
  __b1:
    // *(destination+num) = *(source+num)
    lda main.screen,x
    sta main.bottom,x
    // num--;
    dex
    // while(num)
    cpx #0
    bne __b1
    // }
    rts
}
