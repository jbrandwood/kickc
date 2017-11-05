.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label a = 2
    ldx #0
    jsr inci
    clc
    adc #4
    sta a
    jsr inci
    clc
    adc a
    rts
}
inci: {
    txa
    clc
    adc #7
    tax
    txa
    rts
}
