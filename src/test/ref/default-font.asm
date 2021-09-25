// Show default font on screen
  // Commodore 64 PRG executable file
.file [name="default-font.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label screen = 4
    .label ch = 6
    .label x = 7
    // memset(SCREEN, ' ', 1000)
    jsr memset
    lda #0
    sta.z x
    lda #<SCREEN+$28+1
    sta.z screen
    lda #>SCREEN+$28+1
    sta.z screen+1
    lda #0
    sta.z ch
  __b1:
    ldx #0
  __b2:
    // *screen++ = ch++
    lda.z ch
    ldy #0
    sta (screen),y
    // *screen++ = ch++;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z ch
    // for( byte y: 0..15)
    inx
    cpx #$10
    bne __b2
    // screen += (40-16)
    lda #$28-$10
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    // for( byte x: 0..15)
    inc.z x
    lda #$10
    cmp.z x
    bne __b1
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = SCREEN
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
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
