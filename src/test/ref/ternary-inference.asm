// Type inference into the ternary operator
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
  __b1:
    cpx #5
    bcc __b2
    lda #'0'
    jmp __b3
  __b2:
    lda #$57
  __b3:
    stx.z $ff
    clc
    adc.z $ff
    sta screen,x
    inx
    cpx #$b
    bne __b1
    rts
}
