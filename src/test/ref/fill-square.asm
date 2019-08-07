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
    sta.z y
  b1:
    lda.z y
    sta.z _0
    lda #0
    sta.z _0+1
    lda.z _0
    asl
    sta.z _6
    lda.z _0+1
    rol
    sta.z _6+1
    asl.z _6
    rol.z _6+1
    lda.z _7
    clc
    adc.z _6
    sta.z _7
    lda.z _7+1
    adc.z _6+1
    sta.z _7+1
    asl.z _1
    rol.z _1+1
    asl.z _1
    rol.z _1+1
    asl.z _1
    rol.z _1+1
    clc
    lda.z line
    adc #<SCREEN
    sta.z line
    lda.z line+1
    adc #>SCREEN
    sta.z line+1
    ldy #5
  b2:
    tya
    clc
    adc.z y
    sta (line),y
    iny
    cpy #$10
    bne b2
    inc.z y
    lda #$10
    cmp.z y
    bne b1
    rts
}
