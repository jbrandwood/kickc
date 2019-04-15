.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    lda #$40
    jsr ln
    jsr ln
    jsr ln
    sta SCREEN
    sta SCREEN+$28
    rts
}
ln: {
    clc
    adc #2
    rts
}
