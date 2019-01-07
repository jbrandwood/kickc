.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    lda #0
    sta screen+$27
    sta screen+$26
    sta $28*1+screen+$27
    sta screen+$26+$28*1
    rts
}
