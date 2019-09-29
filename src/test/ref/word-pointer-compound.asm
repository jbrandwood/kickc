// Test word pointer compound assignment
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    txa
    asl
    tay
    clc
    lda words,y
    adc #<$101
    sta words,y
    lda words+1,y
    adc #>$101
    sta words+1,y
    inx
    cpx #3
    bne __b1
    lda words+1
    sta SCREEN
    lda words
    sta SCREEN+1
    lda words+1*SIZEOF_WORD+1
    sta SCREEN+2
    lda words+1*SIZEOF_WORD
    sta SCREEN+3
    lda words+2*SIZEOF_WORD+1
    sta SCREEN+4
    lda words+2*SIZEOF_WORD
    sta SCREEN+5
    rts
    words: .word $3031, $3233, $3435
}
