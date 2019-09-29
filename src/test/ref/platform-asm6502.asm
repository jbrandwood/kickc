// Tests the target platform ASM6502
.pc = $2000 "Program"
main: {
    ldx #0
  __b1:
    cpx #$a
    bcc __b2
    rts
  __b2:
    txa
    sta TABLE,x
    inx
    jmp __b1
}
  TABLE: .fill $a, 0
