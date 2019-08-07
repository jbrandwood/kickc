.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
    ldy #-$7f
  b2:
    tya
    sta screen,x
    iny
    inx
    tya
    sec
    sbc #$7f
    bvc !+
    eor #$80
  !:
    bmi b2
    rts
}
