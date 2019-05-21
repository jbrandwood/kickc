// Tests (non-)optimization of identical sub-expressions
// The two examples of i+1 is not detected as identical leading to ASM that could be optimized more
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = 2
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    ldx #0
  b1:
    txa
    tay
    iny
    tya
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    txa
    tay
    iny
    tya
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
