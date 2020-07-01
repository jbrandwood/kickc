// Demonstrates problem with pointer to pointer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label p1 = 0
  .label p2 = 0
main: {
    // **p1 = **p2
    ldy p2
    sty.z $fe
    ldy p2+1
    sty.z $ff
    ldy #0
    lda ($fe),y
    ldy p1
    sty.z $fe
    ldy p1+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // }
    rts
}
