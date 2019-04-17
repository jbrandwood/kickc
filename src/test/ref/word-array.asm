// Tests a simple word array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label w = 2
    ldy #0
    ldx #0
  b1:
    lda words,x
    sta w
    lda words+1,x
    sta w+1
    lda w
    sta SCREEN,y
    iny
    lda w+1
    sta SCREEN,y
    iny
    tya
    tay
    iny
    inx
    cpx #4
    bne b1
    rts
    // Clever word array that represents C64 numbers 0-7
    words: .word $3130, $3332, $3534, $3736
}
