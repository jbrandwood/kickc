.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label a = 2
    ldy #0
    jsr inci
    clc
    adc #4
    sta a
    jsr inci
    clc
    adc a
    tax
    sty SCREEN
    stx SCREEN+1
    rts
}
inci: {
    tya
    clc
    adc #7
    tay
    tya
    rts
}
