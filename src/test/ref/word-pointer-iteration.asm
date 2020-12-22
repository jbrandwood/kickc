// Tests simple word pointer iteration
  // Commodore 64 PRG executable file
.file [name="word-pointer-iteration.prg", type="prg", segments="Program"]
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
    .label w = 5
    .label wp = 2
    .label idx = 4
    ldx #0
    txa
    sta.z idx
    lda #<words
    sta.z wp
    lda #>words
    sta.z wp+1
  __b1:
    // w = *(wp++)
    ldy #0
    lda (wp),y
    sta.z w
    iny
    lda (wp),y
    sta.z w+1
    lda #SIZEOF_WORD
    clc
    adc.z wp
    sta.z wp
    bcc !+
    inc.z wp+1
  !:
    // <w
    lda.z w
    // SCREEN[idx++] = <w
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = <w;
    iny
    // >w
    lda.z w+1
    // SCREEN[idx++] = >w
    sta SCREEN,y
    // SCREEN[idx++] = >w;
    iny
    tya
    // idx++;
    clc
    adc #1
    sta.z idx
    // for( byte i: 0..3)
    inx
    cpx #4
    bne __b1
    // }
    rts
  .segment Data
    // Clever word array that represents C64 numbers 0-7
    words: .word $3130, $3332, $3534, $3736
}
