// Creates a 2x2 font from the system CHARGEN font and compress it by identifying identical chars
  // Commodore 64 PRG executable file
.file [name="font-2x2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  /// RAM in 0xA000, 0xE000 CHAR ROM in 0xD000
  .const PROCPORT_RAM_CHARROM = 1
  /// BASIC in 0xA000, I/O in 0xD000, KERNEL in 0xE000
  .const PROCPORT_BASIC_KERNEL_IO = 7
  /// $D018 VIC-II base addresses
  // @see #VICII_MEMORY
  .label D018 = $d018
  /// Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  /// The address of the CHARGEN character set
  .label CHARGEN = $d000
  .label SCREEN = $400
  .label FONT_ORIGINAL = $2000
  .label FONT_COMPRESSED = $2800
.segment Code
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>FONT_COMPRESSED)/4&$f
    .label c = $e
    .label x = $11
    .label y = $12
    // asm
    // Create 2x2 font from CHARGEN
    sei
    // *PROCPORT = PROCPORT_RAM_CHARROM
    lda #PROCPORT_RAM_CHARROM
    sta PROCPORT
    // font_2x2(CHARGEN, FONT_ORIGINAL)
    jsr font_2x2
    // *PROCPORT = PROCPORT_BASIC_KERNEL_IO
    lda #PROCPORT_BASIC_KERNEL_IO
    sta PROCPORT
    // asm
    cli
    // char size = font_compress(FONT_ORIGINAL, FONT_COMPRESSED, FONT_COMPRESSED_MAP)
  // Compress the font finding identical characters
    jsr font_compress
    // *D018 = toD018(SCREEN, FONT_COMPRESSED)
    // Show compressed font
    lda #toD0181_return
    sta D018
    // memset(SCREEN, FONT_COMPRESSED_MAP[' '], 0x0400)
    ldx FONT_COMPRESSED_MAP+' '
  // Clear the screen
    jsr memset
    lda #0
    sta.z y
    sta.z c
  __b1:
    lda #0
    sta.z x
  __b2:
    // show(c++, x, y, FONT_COMPRESSED_MAP)
    ldx.z x
    lda.z y
    jsr show
    // show(c++, x, y, FONT_COMPRESSED_MAP);
    inc.z c
    // for(char x:0..7)
    inc.z x
    lda #8
    cmp.z x
    bne __b2
    // for(char y:0..7)
    inc.z y
    cmp.z y
    bne __b1
  __b4:
    // (*(SCREEN+999))++;
    inc SCREEN+$3e7
    jmp __b4
}
// Create a 2x2-font by doubling all pixels of the 64 first chars
// void font_2x2(char *font_original, char *font_2x2)
font_2x2: {
    .label __5 = 6
    .label __7 = 6
    .label next_2x2_left = 4
    .label next_2x2_right = 2
    .label glyph_bits = 8
    .label glyph_bits_2x2 = 6
    .label l2 = $c
    .label l = $d
    .label next_2x2_left_1 = $a
    .label next_2x2 = 4
    .label next_original = $f
    .label c = 9
    lda #0
    sta.z c
    lda #<CHARGEN
    sta.z next_original
    lda #>CHARGEN
    sta.z next_original+1
    lda #<FONT_ORIGINAL
    sta.z next_2x2_left
    lda #>FONT_ORIGINAL
    sta.z next_2x2_left+1
  __b1:
    // char* next_2x2_right = next_2x2 + 0x40*8
    lda.z next_2x2_left
    clc
    adc #<$40*8
    sta.z next_2x2_right
    lda.z next_2x2_left+1
    adc #>$40*8
    sta.z next_2x2_right+1
    lda.z next_2x2_left
    sta.z next_2x2_left_1
    lda.z next_2x2_left+1
    sta.z next_2x2_left_1+1
    lda #0
    sta.z l2
    sta.z l
  __b2:
    // char glyph_bits = next_original[l]
    ldy.z l
    lda (next_original),y
    sta.z glyph_bits
    ldy #0
    tya
    sta.z glyph_bits_2x2
    sta.z glyph_bits_2x2+1
  __b3:
    // glyph_bits&0x80
    lda #$80
    and.z glyph_bits
    // (glyph_bits&0x80)?1uc:0uc
    cmp #0
    bne __b4
    ldx #0
    jmp __b5
  __b4:
    // (glyph_bits&0x80)?1uc:0uc
    ldx #1
  __b5:
    // glyph_bits_2x2<<1
    asl.z __5
    rol.z __5+1
    // glyph_bits_2x2 = glyph_bits_2x2<<1|glyph_bit
    txa
    ora.z glyph_bits_2x2
    sta.z glyph_bits_2x2
    // glyph_bits_2x2<<1
    asl.z __7
    rol.z __7+1
    // glyph_bits_2x2 = glyph_bits_2x2<<1|glyph_bit
    txa
    ora.z glyph_bits_2x2
    sta.z glyph_bits_2x2
    // glyph_bits <<= 1
    // Move to next bit
    asl.z glyph_bits
    // for(char b: 0..7)
    iny
    cpy #8
    bne __b3
    // BYTE1(glyph_bits_2x2)
    lda.z glyph_bits_2x2+1
    // next_2x2_left[l2] = BYTE1(glyph_bits_2x2)
    // Put the generated 2x2-line into the 2x2-font twice
    ldy.z l2
    sta (next_2x2_left_1),y
    // l2+1
    iny
    // BYTE1(glyph_bits_2x2)
    // next_2x2_left[l2+1] = BYTE1(glyph_bits_2x2)
    sta (next_2x2_left_1),y
    // BYTE0(glyph_bits_2x2)
    lda.z glyph_bits_2x2
    // next_2x2_right[l2] = BYTE0(glyph_bits_2x2)
    ldy.z l2
    sta (next_2x2_right),y
    // l2+1
    iny
    // BYTE0(glyph_bits_2x2)
    // next_2x2_right[l2+1] = BYTE0(glyph_bits_2x2)
    sta (next_2x2_right),y
    // l2 += 2
    lda.z l2
    clc
    adc #2
    sta.z l2
    // if(l2==8)
    lda #8
    cmp.z l2
    bne __b8
    // next_2x2_left = next_2x2 + 0x80*8
    lda.z next_2x2_left
    clc
    adc #<$80*8
    sta.z next_2x2_left_1
    lda.z next_2x2_left+1
    adc #>$80*8
    sta.z next_2x2_left_1+1
    // next_2x2_right = next_2x2 + 0xc0*8
    lda.z next_2x2_left
    clc
    adc #<$c0*8
    sta.z next_2x2_right
    lda.z next_2x2_left+1
    adc #>$c0*8
    sta.z next_2x2_right+1
    lda #0
    sta.z l2
  __b8:
    // for(char l: 0..7)
    inc.z l
    lda #8
    cmp.z l
    bne __b2
    // next_2x2 += 8
    clc
    adc.z next_2x2
    sta.z next_2x2
    bcc !+
    inc.z next_2x2+1
  !:
    // next_original += 8
    lda #8
    clc
    adc.z next_original
    sta.z next_original
    bcc !+
    inc.z next_original+1
  !:
    // for(char c: 0..0x3f)
    inc.z c
    lda #$40
    cmp.z c
    beq !__b1+
    jmp __b1
  !__b1:
    // }
    rts
}
// Compress a font finding identical characters
// The compressed font is put into font_compressed and the compress_mapping is updated
// so that compress_mapping[c] points to the char in font_compressed that is identical to char c in font_original
// Returns the size of the compressed font (in chars)
// __register(X) char font_compress(char *font_original, char *font_compressed, char *compress_mapping)
font_compress: {
    .label next_original = 4
    .label i = $d
    .label next_compressed = $f
    .label font_size = 9
    lda #<FONT_COMPRESSED
    sta.z next_compressed
    lda #>FONT_COMPRESSED
    sta.z next_compressed+1
    lda #0
    sta.z i
    sta.z font_size
    lda #<FONT_ORIGINAL
    sta.z next_original
    lda #>FONT_ORIGINAL
    sta.z next_original+1
  __b1:
    // char found = font_find(next_original, font_compressed, font_size)
  // Look for the char in font_compressed
    jsr font_find
    // char found = font_find(next_original, font_compressed, font_size)
    txa
    // if(found==0xff)
    cmp #$ff
    bne __b7
    ldy #0
  // Glyph not found - create it
  __b3:
    // next_compressed[l] = next_original[l]
    lda (next_original),y
    sta (next_compressed),y
    // for(char l:0..7)
    iny
    cpy #8
    bne __b3
    // next_compressed += 8
    lda #8
    clc
    adc.z next_compressed
    sta.z next_compressed
    bcc !+
    inc.z next_compressed+1
  !:
    // font_size++;
    ldx.z font_size
    inx
    lda.z font_size
  __b2:
    // compress_mapping[i] = found
    ldy.z i
    sta FONT_COMPRESSED_MAP,y
    // next_original += 8
    lda #8
    clc
    adc.z next_original
    sta.z next_original
    bcc !+
    inc.z next_original+1
  !:
    // for(char i: 0..0xff)
    inc.z i
    lda.z i
    bne __b6
    // }
    rts
  __b6:
    stx.z font_size
    jmp __b1
  __b7:
    ldx.z font_size
    jmp __b2
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, __register(X) char c, unsigned int num)
memset: {
    .const num = $400
    .label str = SCREEN
    .label end = str+num
    .label dst = $a
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
    txa
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
// Show a 2x2 char on the screen at 2x2-position (x, y) using a font compress mapping
// void show(__zp($e) char c, __register(X) char x, __register(A) char y, char *font_mapping)
show: {
    .label __0 = 6
    .label __1 = 6
    .label __7 = 6
    .label c = $e
    .label ptr = 6
    .label __8 = 4
    .label __9 = 6
    // (unsigned int)y*80
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
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    // SCREEN + (unsigned int)y*80
    lda.z __1
    clc
    adc #<SCREEN
    sta.z __1
    lda.z __1+1
    adc #>SCREEN
    sta.z __1+1
    // x*2
    txa
    asl
    // char* ptr = SCREEN + (unsigned int)y*80 + x*2
    clc
    adc.z ptr
    sta.z ptr
    bcc !+
    inc.z ptr+1
  !:
    // ptr[0] = font_mapping[c]
    ldy.z c
    lda FONT_COMPRESSED_MAP,y
    ldy #0
    sta (ptr),y
    // c+0x40
    ldx.z c
    // ptr[1] = font_mapping[c+0x40]
    lda FONT_COMPRESSED_MAP+$40,x
    ldy #1
    sta (ptr),y
    // c+0x80
    txa
    // ptr[40] = font_mapping[c+0x80]
    tay
    lda FONT_COMPRESSED_MAP+$80,y
    ldy #$28
    sta (ptr),y
    // c+0xc0
    txa
    // ptr[41] = font_mapping[c+0xc0]
    tay
    lda FONT_COMPRESSED_MAP+$c0,y
    ldy #$29
    sta (ptr),y
    // }
    rts
}
// Look for a glyph within a font
// Only looks at the first font_size glyphs
// Returns the index of the glyph within the font. Returns 0xff if the glyph is not found.
// __register(X) char font_find(__zp(4) char *glyph, __zp(2) char *font, __zp(9) char font_size)
font_find: {
    .label glyph = 4
    .label font_size = 9
    .label font = 2
    lda #<FONT_COMPRESSED
    sta.z font
    lda #>FONT_COMPRESSED
    sta.z font+1
    ldx #0
  __b1:
    // for(char i=0;i<font_size;i++)
    cpx.z font_size
    bcc __b6
    ldx #$ff
    // }
    rts
  __b6:
    ldy #0
  __b2:
    // if(glyph[l]!=font[l])
    lda (glyph),y
    cmp (font),y
    beq __b3
    lda #0
    jmp __b4
  __b3:
    // for(char l:0..7)
    iny
    cpy #8
    bne __b2
    lda #1
  __b4:
    // if(found)
    cmp #0
    beq __b5
    rts
  __b5:
    // font += 8
    lda #8
    clc
    adc.z font
    sta.z font
    bcc !+
    inc.z font+1
  !:
    // for(char i=0;i<font_size;i++)
    inx
    jmp __b1
}
.segment Data
  .align $100
  FONT_COMPRESSED_MAP: .fill $100, 0
