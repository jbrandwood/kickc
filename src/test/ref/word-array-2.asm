// Tests a word-array with 128+ elements
  // Commodore 64 PRG executable file
.file [name="word-array-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_WORD = 2
.segment Code
main: {
    .label SCREEN = $400
    .label __0 = 2
    .label __1 = 2
    .label __3 = 4
    .label __6 = 2
    .label __7 = 4
    .label __8 = 4
    ldx #0
  __b1:
    // ((word)i)*0x100
    txa
    sta.z __6
    lda #0
    sta.z __6+1
    lda.z __0
    sta.z __0+1
    lda #0
    sta.z __0
    // ((word)i)*0x100+i
    txa
    clc
    adc.z __1
    sta.z __1
    bcc !+
    inc.z __1+1
  !:
    // words[(word)i] = ((word)i)*0x100+i
    txa
    sta.z __7
    lda #0
    sta.z __7+1
    asl.z __3
    rol.z __3+1
    clc
    lda.z __8
    adc #<words
    sta.z __8
    lda.z __8+1
    adc #>words
    sta.z __8+1
    ldy #0
    lda.z __1
    sta (__8),y
    iny
    lda.z __1+1
    sta (__8),y
    // for(byte i: 0..0xff)
    inx
    cpx #0
    bne __b1
    // SCREEN[0] = words[(word)255]
    lda words+$ff*SIZEOF_WORD
    sta SCREEN
    lda words+$ff*SIZEOF_WORD+1
    sta SCREEN+1
    // }
    rts
}
.segment Data
  words: .fill 2*$100, 0
