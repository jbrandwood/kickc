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
  __b1:
    // w = words[i]
    txa
    asl
    tay
    lda words,y
    sta.z w
    lda words+1,y
    sta.z w+1
    // >w
    // SCREEN[idx++] = >w
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = >w;
    iny
    // <w
    lda.z w
    // SCREEN[idx++] = <w
    sta SCREEN,y
    // SCREEN[idx++] = <w;
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
    // Clever word array that represents C64 numbers 0-7
    words: .word $3031, $3233, $3435, $3637
}
