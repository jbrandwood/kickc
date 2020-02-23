.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  .label BGCOL2 = $d022
  .label BGCOL3 = $d023
  .label D016 = $d016
  .const VIC_MCM = $10
  .const VIC_CSEL = 8
  .label D018 = $d018
  // Color Ram
  .label COLS = $d800
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .const DARK_GREY = $b
  .label SCREEN = $400
  .label LOGO = $2000
  // kickasm
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>LOGO)/4&$f
    // *BORDERCOL = WHITE
    lda #WHITE
    sta BORDERCOL
    // *BGCOL2 = DARK_GREY
    lda #DARK_GREY
    sta BGCOL2
    // *BGCOL = *BGCOL2 = DARK_GREY
    sta BGCOL
    // *BGCOL3 = BLACK
    lda #BLACK
    sta BGCOL3
    // *D018 = toD018(SCREEN, LOGO)
    lda #toD0181_return
    sta D018
    // *D016 = VIC_MCM | VIC_CSEL
    lda #VIC_MCM|VIC_CSEL
    sta D016
    // memset(SCREEN, BLACK, 40*25)
    ldx #BLACK
    lda #<SCREEN
    sta.z memset.str
    lda #>SCREEN
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    // memset(COLS, WHITE|8, 40*25)
    ldx #WHITE|8
    lda #<COLS
    sta.z memset.str
    lda #>COLS
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    ldx #0
  __b1:
    // SCREEN[ch] = ch
    txa
    sta SCREEN,x
    // for(byte ch: 0..239)
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
// memset(void* zp(4) str, byte register(X) c, word zp(2) num)
memset: {
    .label end = 2
    .label dst = 4
    .label num = 2
    .label str = 4
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
.pc = LOGO "LOGO"
  .var logoPic = LoadPicture("logo.png", List().add($444444, $808080, $000000, $ffffff))
    .for (var y=0; y<6	; y++)
        .for (var x=0;x<40; x++)
            .for(var cp=0; cp<8; cp++)
                .byte logoPic.getMulticolorByte(x,cp+y*8)

