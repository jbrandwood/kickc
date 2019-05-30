// Type inference into the ternary operator
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
  b1:
    cpx #5
    bcc b2
    lda #'0'
    jmp b3
  b2:
    lda #$57
  b3:
    stx $ff
    clc
    adc $ff
    sta screen,x
    inx
    cpx #$b
    bne b1
    rts
}
