// Tests a simple word array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label w = 3
    .label idx = 2
    lda #0
    sta.z idx
    tax
  b1:
    txa
    asl
    tay
    lda words,y
    sta.z w
    lda words+1,y
    sta.z w+1
    ldy.z idx
    sta SCREEN,y
    iny
    lda.z w
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
    words: .word $3031, $3233, $3435, $3637
}
