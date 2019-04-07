// Tests the ternary operator - when the condition is constant
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldy #0
  b1:
    jsr cond
    cmp #0
    bne b2
    jsr m2
  b4:
    sta SCREEN,y
    iny
    cpy #$a
    bne b1
    rts
  b2:
    jsr m1
    jmp b4
}
// m1(byte register(Y) i)
m1: {
    tya
    clc
    adc #5
    rts
}
// m2(byte register(Y) i)
m2: {
    tya
    clc
    adc #$a
    rts
}
// cond(byte register(Y) b)
cond: {
    cpy #5
    lda #0
    rol
    eor #1
    rts
}
