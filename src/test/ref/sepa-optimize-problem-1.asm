// Parameter "c" to _copyDigitToAnySprite is passed incorrectly to an unused c_1 in the first call in  _updateLupineSprite
  // Commodore 64 PRG executable file
.file [name="sepa-optimize-problem-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const STACK_BASE = $103
  .label SPR_POTATO_UI = $a00
  .label SPR_LUPINE_UI = $a40
  .label SCREEN = 4
.segment Code
__start: {
    // char * SCREEN = (char*)0x0400
    lda #<$400
    sta.z SCREEN
    lda #>$400
    sta.z SCREEN+1
    jsr main
    rts
}
// void xputc(__register(A) char c)
xputc: {
    .const OFFSET_STACK_C = 0
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    // *(SCREEN++) = c
    ldy #0
    sta (SCREEN),y
    // *(SCREEN++) = c;
    inc.z SCREEN
    bne !+
    inc.z SCREEN+1
  !:
    // }
    rts
}
main: {
    // _updatePotatoSprite()
    jsr _updatePotatoSprite
    // _updateLupineSprite()
    jsr _updateLupineSprite
    // }
    rts
}
_updatePotatoSprite: {
    // xputc(0)
    lda #0
    pha
    jsr xputc
    pla
    // _copyDigitToAnySprite(SPR_POTATO_UI, num2str[0])
    ldy num2str
    lda #<SPR_POTATO_UI
    sta.z _copyDigitToAnySprite.pointer
    lda #>SPR_POTATO_UI
    sta.z _copyDigitToAnySprite.pointer+1
    jsr _copyDigitToAnySprite
    // }
    rts
}
_updateLupineSprite: {
    // xputc(1)
    lda #1
    pha
    jsr xputc
    pla
    // _copyDigitToAnySprite(SPR_LUPINE_UI, num2str[0])
    ldy num2str
    lda #<SPR_LUPINE_UI
    sta.z _copyDigitToAnySprite.pointer
    lda #>SPR_LUPINE_UI
    sta.z _copyDigitToAnySprite.pointer+1
    jsr _copyDigitToAnySprite
    // _copyDigitToAnySprite(SPR_LUPINE_UI, num2str[1])
    ldy num2str+1
    lda #<SPR_LUPINE_UI
    sta.z _copyDigitToAnySprite.pointer
    lda #>SPR_LUPINE_UI
    sta.z _copyDigitToAnySprite.pointer+1
    jsr _copyDigitToAnySprite
    // }
    rts
}
// void _copyDigitToAnySprite(__zp(2) char *pointer, __register(Y) char c)
_copyDigitToAnySprite: {
    .label pointer = 2
    // if(c == $f0)
    cpy #$f0
    beq __b1
    // pointer[c] = 1
    lda #1
    sta (pointer),y
    // }
    rts
  __b1:
    // pointer[c] = 0
    lda #0
    sta (pointer),y
    rts
}
.segment Data
  num2str: .fill 3, 0
