// Test that struct variable and members can both have type directives
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // SCREEN[0] = y.x
    lda y
    sta SCREEN
    // SCREEN[0] = y.z
    lda y+1
    sta SCREEN
    // }
    rts
}
  y: .byte 1, 2
