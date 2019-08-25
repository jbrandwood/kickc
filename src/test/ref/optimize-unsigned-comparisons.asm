// Examples of unsigned comparisons to values outside the range of unsigned
// These should be optimized to constants
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
  b1:
    lda ball_active,x
    lda ball_active,x
    inx
    cpx #8
    bne b1
    rts
}
  ball_active: .byte 0, 1, 0, 1, 0, 1, 1, 1
