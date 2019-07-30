// Tests the target platform ASM6502
.pc = $1000 "Program"
main: {
    ldx #0
  b1:
    txa
    sta TABLE,x
    inx
    cpx #$a
    bcc b1
    rts
}
  TABLE: .fill $a, 0
