// Tests variable coalescing over assignments
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label a = 2
    ldx #0
    txa
    sta.z a
  __b1:
    ldy #0
  __b2:
    // e = b+c
    tya
    clc
    adc.z a
    // g = e+f
    asl
    // SCREEN[idx++] = g
    sta SCREEN,x
    // SCREEN[idx++] = g;
    inx
    // for( byte b: 0..5)
    iny
    cpy #6
    bne __b2
    // for( byte a: 0..5)
    inc.z a
    lda #6
    cmp.z a
    bne __b1
    // }
    rts
}
