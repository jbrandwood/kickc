// Tests ATASCII encoding
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // SCREEN[0] = TEXT[13]
    lda TEXT+$d
    sta SCREEN
    // }
    rts
}
.encoding "ascii"
  TEXT: .text @"hello, world!\$9b"
  .byte 0
