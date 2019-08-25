// Tests the target platform ASM6502
.pc = $2000 "Program"
main: {
    ldx #0
  b1:
    cpx #$a
    bcc b2
    rts
  b2:
    txa
    sta TABLE,x
    inx
    jmp b1
}
  TABLE: .fill $a, 0
