.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
//  Concatenate a char to a string
main: {
    .label screen = $400
    ldx #0
  b1:
    lda msg,x
    sta screen,x
    inx
    cpx #3
    bne b1
    rts
    msg: .text "cm"+'l'
}
