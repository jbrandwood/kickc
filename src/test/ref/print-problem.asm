.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // ln()
    lda #$40
    jsr ln
    // ln()
    jsr ln
    // ln()
    jsr ln
    // *SCREEN = ch
    sta SCREEN
    // *(SCREEN+40) = line
    sta SCREEN+$28
    // }
    rts
}
ln: {
    // line + $2
    clc
    adc #2
    // }
    rts
}
