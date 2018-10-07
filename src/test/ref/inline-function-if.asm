.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
  jsr main
main: {
    .const toUpper1_ch = 'c'
    .const toUpper2_ch = 'm'
    .const toUpper1_res = toUpper1_ch+$40
    lda #toUpper1_res
    sta screen
    lda #toUpper2_ch
    sta screen+1
    rts
}
