// Tests comma-separated declarations with different array-ness
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const b = 0
    .const d = 0
    .label SCREEN = $400
    // SCREEN[0] = b
    lda #b
    sta SCREEN
    // SCREEN[1] = c[0]
    lda c
    sta SCREEN+1
    // SCREEN[2] = d
    lda #d
    sta SCREEN+2
    // }
    rts
    c: .fill 3, 0
}
