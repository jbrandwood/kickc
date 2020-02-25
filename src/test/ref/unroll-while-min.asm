// Minimal unrolled while() loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    // SCREEN[i++] = 'a'
    lda #'a'
    sta SCREEN
    sta SCREEN+1
    // }
    rts
}
