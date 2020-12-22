// Test the 6502 CPU without support for illegal opcodes
// By a program that normally uses illegal opcodes
.cpu _6502NoIllegals
  // Commodore 64 PRG executable file
.file [name="cpu-6502.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    ldx #0
  __b1:
    // while(c<100)
    cpx #$64
    bcc __b2
    // }
    rts
  __b2:
    // screen[c] = '*'
    lda #'*'
    sta screen,x
    // c&4
    txa
    and #4
    // if((c&4)==0)
    cmp #0
    bne __b3
    // c+=5
    txa
    clc
    adc #5
    tax
  __b3:
    // c++;
    inx
    jmp __b1
}
