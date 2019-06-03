// Tests optimization of identical sub-expressions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = 3
    .label i = 2
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    lda #0
    sta i
  b1:
    lda i
    clc
    adc #1
    asl
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    lda i
    clc
    adc #1
    asl
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inc i
    lda #3
    cmp i
    bne b1
    rts
}
