// Tests comma-separated declarations
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .const b = 'c'
    .const c = b+1
    .const d = c+1
    lda #b
    sta SCREEN
    lda #c
    sta SCREEN+1
    lda #d
    sta SCREEN+2
    rts
}
