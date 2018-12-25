.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #0
  b1:
    txa
    eor #$ff
    clc
    adc #$ff+1
    tay
    lda #0
    sta table,y
    inx
    cpx #$81
    bne b1
    rts
}
  table: .fill $100, 0
