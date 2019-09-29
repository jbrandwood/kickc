// Test the 6502 CPU without support for illegal opcodes
// By a program that normally uses illegal opcodes
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
  __b1:
    cpx #$64
    bcc __b2
    rts
  __b2:
    lda #'*'
    sta screen,x
    txa
    and #4
    cmp #0
    bne __b3
    txa
    clc
    adc #5
    tax
  __b3:
    inx
    jmp __b1
}
