// Examples of unsigned comparisons to values outside the range of unsigned
// These should be optimized to constants
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #0
  b2:
    inx
    cpx #8
    bne b2
    rts
}
