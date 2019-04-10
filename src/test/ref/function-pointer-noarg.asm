// Tests creating pointers to non-args no-return functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    lda #<fn1
    sta SCREEN
    lda #>fn1
    sta SCREEN+1
    lda #<fn2
    sta SCREEN+2
    lda #>fn2
    sta SCREEN+3
    rts
}
fn2: {
    .label BGCOL = $d021
    inc BGCOL
    rts
}
fn1: {
    .label BORDERCOL = $d020
    inc BORDERCOL
    rts
}
