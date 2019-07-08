// Fill a square on the screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label _0 = 3
    .label _1 = 3
    .label line = 3
    .label y = 2
    .label _6 = 5
    .label _7 = 3
    lda #5
    sta y
  b1:
    lda y
    sta _0
    lda #0
    sta _0+1
    lda _0
    asl
    sta _6
    lda _0+1
    rol
    sta _6+1
    asl _6
    rol _6+1
    lda _7
    clc
    adc _6
    sta _7
    lda _7+1
    adc _6+1
    sta _7+1
    asl _1
    rol _1+1
    asl _1
    rol _1+1
    asl _1
    rol _1+1
    clc
    lda line
    adc #<SCREEN
    sta line
    lda line+1
    adc #>SCREEN
    sta line+1
    ldy #5
  b2:
    tya
    clc
    adc y
    sta (line),y
    iny
    cpy #$10
    bne b2
    inc y
    lda #$10
    cmp y
    bne b1
    rts
}
