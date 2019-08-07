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
    sta.z a
  b1:
    ldy #0
  b2:
    tya
    clc
    adc.z a
    sta.z e
    tya
    clc
    adc.z a
    clc
    adc.z e
    sta SCREEN,x
    inx
    iny
    cpy #6
    bne b2
    inc.z a
    lda #6
    cmp.z a
    bne b1
    rts
}
