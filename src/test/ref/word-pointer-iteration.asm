// Tests simple word pointer iteration
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
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
  b1:
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
    lda.z w
    ldy.z idx
    sta SCREEN,y
    iny
    lda.z w+1
    sta SCREEN,y
    iny
    tya
    clc
    adc #1
    sta.z idx
    inx
    cpx #4
    bne b1
    rts
    // Clever word array that represents C64 numbers 0-7
    words: .word $3130, $3332, $3534, $3736
}
