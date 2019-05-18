.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    lda #0
    sta screen+$27
    sta screen+$26
    sta screen+$28*1+$27
    sta screen+$28*1+$26
    rts
}
