// Tests the target platform ASM6502_SEGMENTS
.file  [ name="platform-asm6502_segments.prg",type="prg",segments="Program" ]
.segmentdef Program [ segments="Code,Data" ]
.segmentdef Code [ start=$2000 ]
.segmentdef Data [ startAfter="Code" ]
.segment Code
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
.segment Data
  TABLE: .fill $a, 0
