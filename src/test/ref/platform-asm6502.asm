// Tests the target platform ASM6502
.pc = $2000 "Program"
main: {
    ldx #0
  __b1:
    // for(char i=0;i<10;i++)
    cpx #$a
    bcc __b2
    // }
    rts
  __b2:
    // TABLE[i] = i
    txa
    sta TABLE,x
    // for(char i=0;i<10;i++)
    inx
    jmp __b1
}
  TABLE: .fill $a, 0
