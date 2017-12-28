.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .const SCREEN = $400
    ldx #0
  b1:
    lda s5,x
    sta SCREEN,x
    inx
    cpx #8
    bne b1
    rts
    s5: .text "cam"+"e"+"l"+'o'+""+'t'+'!'
}
