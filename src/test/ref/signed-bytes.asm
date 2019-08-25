.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldy #0
    ldx #-$7f
  b1:
    txa
    sec
    sbc #$7f
    bvc !+
    eor #$80
  !:
    bmi b2
    rts
  b2:
    txa
    sta screen,y
    inx
    iny
    jmp b1
}
