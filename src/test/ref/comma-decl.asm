// Tests comma-separated declarations
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const b = 'c'
    .const c = b+1
    .const d = c+1
    .label SCREEN = $400
    // SCREEN[0] = b
    lda #b
    sta SCREEN
    // SCREEN[1] = c
    lda #c
    sta SCREEN+1
    // SCREEN[2] = d
    lda #d
    sta SCREEN+2
    // }
    rts
}
