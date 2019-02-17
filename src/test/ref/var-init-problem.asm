//  Variables without initialization causes problems when compiling
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    lda #'a'
    sta screen
    rts
}
