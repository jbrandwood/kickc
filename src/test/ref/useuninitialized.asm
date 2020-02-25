// Use an uninitialized variable - should use the default value (0)!
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const b = 3
  .const s = 1
main: {
    .label screen = $400
    // *screen = b
    lda #b
    sta screen
    // *(screen+1) = s
    lda #s
    sta screen+1
    // }
    rts
}
