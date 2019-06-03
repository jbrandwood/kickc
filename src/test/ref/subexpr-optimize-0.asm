// Tests optimization of identical sub-expressions
// The two examples of i*2 is detected as identical leading to optimized ASM where *2 is only calculated once
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label _1 = 4
    .label screen = 2
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    ldx #0
  b1:
    txa
    asl
    sta _1
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    lda _1
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
