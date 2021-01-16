// Commodore 64 Registers and Constants
// The MOS 6526 Complex Interface Adapter (CIA)
// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="showlogo.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const VICII_MCM = $10
  .const VICII_CSEL = 8
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .const DARK_GREY = $b
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  .const OFFSET_STRUCT_MOS6569_VICII_BG_COLOR1 = $22
  .const OFFSET_STRUCT_MOS6569_VICII_BG_COLOR = $21
  .const OFFSET_STRUCT_MOS6569_VICII_BG_COLOR2 = $23
  .label D016 = $d016
  .label D018 = $d018
  // The VIC-II MOS 6567/6569
  .label VICII = $d000
  // Color Ram
  .label COLS = $d800
  .label SCREEN = $400
.segment Code
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>LOGO)/4&$f
    // VICII->BORDER_COLOR = WHITE
    lda #WHITE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // VICII->BG_COLOR1 = DARK_GREY
    lda #DARK_GREY
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BG_COLOR1
    // VICII->BG_COLOR = VICII->BG_COLOR1 = DARK_GREY
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BG_COLOR
    // VICII->BG_COLOR2 = BLACK
    lda #BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BG_COLOR2
    // *D018 = toD018(SCREEN, LOGO)
    lda #toD0181_return
    sta D018
    // *D016 = VICII_MCM | VICII_CSEL
    lda #VICII_MCM|VICII_CSEL
    sta D016
    // memset(SCREEN, BLACK, 40*25)
    ldx #BLACK
    lda #<SCREEN
    sta.z memset.str
    lda #>SCREEN
    sta.z memset.str+1
    jsr memset
    // memset(COLS, WHITE|8, 40*25)
    ldx #WHITE|8
    lda #<COLS
    sta.z memset.str
    lda #>COLS
    sta.z memset.str+1
    jsr memset
    ldx #0
  __b1:
    // SCREEN[ch] = ch
    txa
    sta SCREEN,x
    // for(char ch: 0..239)
    inx
    cpx #$f0
    bne __b1
  __b2:
    // (*(SCREEN+999))++;
    inc SCREEN+$3e7
    // kickasm
    inc $d020 
    jmp __b2
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp(2) str, byte register(X) c)
memset: {
    .label end = 4
    .label dst = 2
    .label str = 2
    // end = (char*)str + num
    clc
    lda.z str
    adc #<$28*$19
    sta.z end
    lda.z str+1
    adc #>$28*$19
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
.pc = $2000 "LOGO"
LOGO:
.var logoPic = LoadPicture("logo.png", List().add($444444, $808080, $000000, $ffffff))
    .for (var y=0; y<6	; y++)
        .for (var x=0;x<40; x++)
            .for(var cp=0; cp<8; cp++)
                .byte logoPic.getMulticolorByte(x,cp+y*8)

