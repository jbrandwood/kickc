// Demonstrates Library Constructor Functionality
// Constructors are removed if not needed
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // SCREEN[2] = '*'
    lda #'*'
    sta SCREEN+2
    // }
    rts
}
