// Tests the target platform ASM6502
  // Generic ASM 6502
.file [name="platform-asm6502.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Code, Data"]
.segmentdef Code [start=$3000]
.segmentdef Data [startAfter="Code"]
.segment Code
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
.segment Data
  TABLE: .fill $a, 0
