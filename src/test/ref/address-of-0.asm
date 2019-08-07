// Test address-of - use the pointer to get the value
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label bp = b
    .label b = 2
    lda #0
    sta.z b
  b1:
    lda bp
    clc
    adc #1
    ldy.z b
    sta SCREEN,y
    inc.z b
    lda #$b
    cmp.z b
    bne b1
    rts
}
