// Test address-of - use the pointer to get the value
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label bp = b
    .label b = 2
    // for( byte b: 0..10)
    lda #0
    sta.z b
  __b1:
    // c = *bp +1
    lda.z bp
    clc
    adc #1
    // SCREEN[b] = c
    ldy.z b
    sta SCREEN,y
    // for( byte b: 0..10)
    inc.z b
    lda #$b
    cmp.z b
    bne __b1
    // }
    rts
}
