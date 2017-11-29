.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label char = 2
  jsr main
main: {
    lda #$40
    jsr ln
    sta char
    inc char
    jsr ln
    sta char
    inc char
    jsr ln
    rts
}
ln: {
    clc
    adc #2
    rts
}
