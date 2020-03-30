// Typedef a const/volatile type and instantiate a pointer to it
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label cp = $a003
  .label vp = $a004
main: {
    // SCREEN[0] = *cp
    lda cp
    sta SCREEN
    // SCREEN[1] = *vp
    lda vp
    sta SCREEN+1
    // }
    rts
}
