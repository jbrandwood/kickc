.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
  jsr main
main: {
    .const sum1_a = 2
    .const sum1_b = 1
    .const sum2_a = $a
    .const sum2_b = 3
    .const sum3_a = 4
    .const sum3_b = 8
    .const sum1_return = sum1_a+sum1_b
    .const sum2_return = sum2_a+sum2_b
    .const sum3_return = sum3_a+sum3_b
    lda #sum1_return
    sta screen
    lda #sum2_return
    sta screen+1
    lda #sum3_return
    sta screen+2
    rts
}
