// Tests optimization of identical sub-expressions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label _3 = 4
    .label screen = 2
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    ldx #0
  b1:
    txa
    asl
    sta _3
    txa
    clc
    adc _3
    clc
    adc #3
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    txa
    clc
    adc _3
    clc
    adc #3
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inx
    cpx #3
    bne b1
    rts
}
