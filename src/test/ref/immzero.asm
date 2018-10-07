.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label w = 2
    ldx #0
    txa
    sta w
    sta w+1
  b1:
    txa
    clc
    adc w
    sta w
    lda #0
    adc w+1
    sta w+1
    inx
    cpx #$b
    bne b1
    rts
}
