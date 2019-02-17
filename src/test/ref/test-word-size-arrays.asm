.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label _0 = 4
    .label _2 = 6
    .label _6 = 4
    .label line = 2
    lda #<0
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
    lda #<screen
    clc
    adc _0
    sta !a1++1
    lda #>screen
    adc _0+1
    sta !a1++2
    lda #<screen+$28
    clc
    adc _2
    sta !a2++1
    lda #>screen+$28
    adc _2+1
    sta !a2++2
  !a2:
    lda screen+$28
  !a1:
    sta screen
    inx
    cpx #$28
    bcc b2
    clc
    lda line
    adc #<$28
    sta line
    lda line+1
    adc #>$28
    sta line+1
    cmp #>$28*$18
    bcc b1
    bne !+
    lda line
    cmp #<$28*$18
    bcc b1
  !:
    ldx #0
  // Cleare the bottom line
  b3:
    txa
    clc
    adc line
    sta _6
    lda #0
    adc line+1
    sta _6+1
    lda #<screen
    clc
    adc _6
    sta !++1
    lda #>screen
    adc _6+1
    sta !++2
    lda #' '
  !:
    sta screen
    inx
    cpx #$28
    bcc b3
    rts
}
