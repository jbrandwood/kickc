// Tests simple word pointer math
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label w = 3
    .label idx = 2
    lda #0
    sta idx
    tax
  b1:
    txa
    asl
    tay
    lda words,y
    sta w
    lda words+1,y
    sta w+1
    lda w
    ldy idx
    sta SCREEN,y
    iny
    lda w+1
    sta SCREEN,y
    iny
    tya
    clc
    adc #1
    sta idx
    inx
    cpx #4
    bne b1
    rts
    // Clever word array that represents C64 numbers 0-7
    words: .word $3130, $3332, $3534, $3736
}
