.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label a = 2
    ldy #0
  b1:
    ldx #0
  b2:
    lda #0
    sta a
  b3:
    tya
    clc
    adc a
    jsr print
    inc a
    lda #$65
    cmp a
    bne b3
    inx
    cpx #$65
    bne b2
    iny
    cpy #$65
    bne b1
    rts
}
// print(byte register(X) idx, byte register(A) val)
print: {
    .label SCREEN = $400
    sta SCREEN,x
    rts
}
