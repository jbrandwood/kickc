.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .const screen = $400
    .label i = 2
    ldx #0
    lda #-$7f
    sta i
  b1:
    lda i
    sec
    sbc #$7f
    bvc !+
    eor #$80
  !:
    bmi b2
    rts
  b2:
    lda i
    sta screen,x
    inc i
    inx
    jmp b1
}
