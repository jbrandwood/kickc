.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label a = 2
    // inci()
    ldy #0
    jsr inci
    // inci()
    // a=a+inci()
    clc
    adc #4
    sta.z a
    // inci()
    jsr inci
    // inci()
    // a=a+inci()
    clc
    adc.z a
    tax
    // *SCREEN = i
    sty SCREEN
    // *(SCREEN+1) = a
    stx SCREEN+1
    // }
    rts
}
inci: {
    // i+7
    tya
    clc
    adc #7
    tay
    // return i;
    tya
    // }
    rts
}
