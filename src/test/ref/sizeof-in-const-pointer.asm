// Support for sizeof() in const pointer definition
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_BYTE = 1
  // Commodore 64 processor port
  .label SCREEN = $400+SIZEOF_BYTE*$64
main: {
    // SCREEN[0] = 'a'
    lda #'a'
    sta SCREEN
    // }
    rts
}
