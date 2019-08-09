// Tests the target platform ASM6502
.pc = $2000 "Program"
main: {
    ldx #0
  b2:
    txa
    sta TABLE,x
    inx
    cpx #$a
    bcc b2
    rts
}
  TABLE: .fill $a, 0
