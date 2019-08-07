// Test all types of pointers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // A constant pointer
    .label SCREEN = $400
    ldx #2
  b2:
    lda SCREEN,x
    inx
    cpx #$a
    bcc b2
    sta SCREEN+$3e7
    rts
}
