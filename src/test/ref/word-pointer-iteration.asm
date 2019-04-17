// Tests simple word pointer iteration
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label w = 5
    .label wp = 2
    .label idx = 4
    ldx #0
    txa
    sta idx
    lda #<words
    sta wp
    lda #>words
    sta wp+1
  b1:
    ldy #0
    lda (wp),y
    sta w
    iny
    lda (wp),y
    sta w+1
    inc wp
    bne !+
    inc wp+1
  !:
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
