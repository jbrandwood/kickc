.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    // *(screen+40*j+39) = 0
    lda #0
    sta screen+$27
    // screen[40*j+37] = 0
    sta screen+$25
    // *(screen+40*j+39) = 0
    sta screen+$28*1+$27
    // screen[40*j+37] = 0
    sta screen+$28*1+$25
    // }
    rts
}
