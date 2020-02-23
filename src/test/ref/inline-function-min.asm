// Test minimal inline function
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
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
    // screen[0] = sum(2, 1)
    lda #sum1_return
    sta screen
    // screen[1] = sum(10, 3)
    lda #sum2_return
    sta screen+1
    // screen[2] = sum(4, 8)
    lda #sum3_return
    sta screen+2
    // }
    rts
}
