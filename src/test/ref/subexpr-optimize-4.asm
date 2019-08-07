// Tests optimization of identical sub-expressions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = 2
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #0
  b1:
    txa
    and #1
    cmp #0
    bne b2
    txa
    asl
    asl
  b4:
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    txa
    and #1
    cmp #0
    bne b5
    txa
    asl
    asl
  b7:
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inx
    cpx #3
    bne b1
    rts
  b5:
    txa
    clc
    adc #3
    jmp b7
  b2:
    txa
    clc
    adc #3
    jmp b4
}
