// Typedef an array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // SCREEN[i] = a[i]
    lda a,x
    sta SCREEN,x
    // for(char i:0..6)
    inx
    cpx #7
    bne __b1
    // }
    rts
}
  a: .text "cml"
  .byte 0
  .fill 3, 0
