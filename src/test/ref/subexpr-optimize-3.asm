// Tests optimization of identical sub-expressions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label __3 = 4
    .label screen = 2
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #0
  __b1:
    txa
    asl
    sta.z __3
    txa
    clc
    adc.z __3
    clc
    adc #3
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    txa
    clc
    adc.z __3
    clc
    adc #3
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inx
    cpx #3
    bne __b1
    rts
}
