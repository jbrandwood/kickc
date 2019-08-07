// Tests optimization of identical sub-expressions
// The two examples of i*2 is detected as identical leading to optimized ASM where *2 is only calculated once
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label _1 = 4
    .label screen = 2
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #0
  b1:
    txa
    asl
    sta.z _1
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    lda.z _1
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
}
