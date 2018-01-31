.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label cnt3 = 2
  jsr main
main: {
    lda #0
    sta cnt3
    tay
    tax
    jsr inccnt
    sta SCREEN+0
    inx
    jsr inccnt
    sta SCREEN+1
    rts
}
inccnt: {
    inx
    iny
    inc cnt3
    txa
    rts
}
