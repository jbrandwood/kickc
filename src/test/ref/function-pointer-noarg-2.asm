// Tests creating and assigning pointers to non-args no-return functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #0
  __b1:
    txa
    and #1
    cmp #0
    inx
    cpx #$65
    bne __b1
    rts
}
