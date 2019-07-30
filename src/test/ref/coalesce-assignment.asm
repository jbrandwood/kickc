// Tests variable coalescing over assignments
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label e = 3
    .label a = 2
    ldx #0
    txa
    sta a
  b1:
    ldy #0
  b2:
    tya
    clc
    adc a
    sta e
    tya
    clc
    adc a
    clc
    adc e
    sta SCREEN,x
    inx
    iny
    cpy #6
    bne b2
    inc a
    lda #6
    cmp a
    bne b1
    rts
}
