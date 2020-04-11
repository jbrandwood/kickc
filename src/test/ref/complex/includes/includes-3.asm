// A file using a library
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // SCREEN[i++] = value
    lda #'a'
    sta SCREEN
    lda #'x'
    sta SCREEN+1
    // }
    rts
}
