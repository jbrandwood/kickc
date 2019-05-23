.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label _0 = 4
    .label _2 = 6
    .label _6 = 4
    .label line = 2
    .label _9 = 6
    .label _10 = 4
    .label _11 = 4
    lda #0
    sta line
    sta line+1
  b1:
    ldx #0
  b2:
    txa
    clc
    adc line
    sta _0
    lda #0
    adc line+1
    sta _0+1
    txa
    clc
    adc line
    sta _2
    lda #0
    adc line+1
    sta _2+1
    clc
    lda _9
    adc #<screen+$28
    sta _9
    lda _9+1
    adc #>screen+$28
    sta _9+1
    clc
    lda _10
    adc #<screen
    sta _10
    lda _10+1
    adc #>screen
    sta _10+1
    ldy #0
    lda (_9),y
    sta (_10),y
    inx
    cpx #$28
    bcc b2
    lda #$28
    clc
    adc line
    sta line
    bcc !+
    inc line+1
  !:
    lda line+1
    cmp #>$28*$18
    bcc b1
    bne !+
    lda line
    cmp #<$28*$18
    bcc b1
  !:
    ldx #0
  // Cleare the bottom line
  b4:
    txa
    clc
    adc line
    sta _6
    lda #0
    adc line+1
    sta _6+1
    clc
    lda _11
    adc #<screen
    sta _11
    lda _11+1
    adc #>screen
    sta _11+1
    lda #' '
    ldy #0
    sta (_11),y
    inx
    cpx #$28
    bcc b4
    rts
}
