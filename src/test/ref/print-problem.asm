.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    lda #$40
    jsr ln
    tax
    inx
    jsr ln
    tax
    inx
    jsr ln
    sta SCREEN
    rts
}
ln: {
    clc
    adc #2
    rts
}
