.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  .label cnt3 = 2
  jsr main
main: {
    lda #0
    sta cnt3
    ldy #0
    ldx #0
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
