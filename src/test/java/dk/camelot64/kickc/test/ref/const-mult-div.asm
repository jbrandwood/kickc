.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label screen = $400
    .const b = 6*$e/3+mod($16,3)
    lda #b
    sta screen+0
    rts
}
