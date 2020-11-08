// Chunky DYPP with arbitrary sine
// First implemented as dyppa.asm in 2011
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_MOS6569_VICII_MEMORY = $18
  // The VIC-II MOS 6567/6569
  .label VICII = $d000
  // Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
main: {
    .const toD0181_return = (>(DEFAULT_SCREEN&$3fff)*4)|(>DYPPA_CHARSET)/4&$f
    // VICII->MEMORY = toD018(DEFAULT_SCREEN, DYPPA_CHARSET)
    lda #toD0181_return
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_MEMORY
    // memset(DEFAULT_SCREEN, DYPPA_TABLE[0], 1000)
    ldx DYPPA_TABLE
    jsr memset
  __b1:
    // (*(DEFAULT_SCREEN+999))++;
    inc DEFAULT_SCREEN+$3e7
    jmp __b1
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(byte register(X) c)
memset: {
    .const num = $3e8
    .label str = DEFAULT_SCREEN
    .label end = str+num
    .label dst = 2
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
  // The DYPPA tables mapping the slopes, offsets and pixels to the right character in the charset
  // for(offset:0..7) for(slope:0..f) for(pixels: 0..f) glyph_id(offset,slope,pixels)  
  .align $100
DYPPA_TABLE:
.var dyppaFile2 = LoadBinary("dyppacharset.bin", "Charset=$000,Tables=$800")
    .fill dyppaFile2.getTablesSize(), dyppaFile2.getTables(i) 

.pc = $2000 "DYPPA_CHARSET"
// The DYPPA charset containing the sloped offset characters
DYPPA_CHARSET:
.var dyppaFile = LoadBinary("dyppacharset.bin", "Charset=$000,Tables=$800")
    .fill dyppaFile.getCharsetSize(), dyppaFile.getCharset(i) 

