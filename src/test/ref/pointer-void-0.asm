// Test simple void pointer (conversion without casting)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label wp = w
    .label vp = wp
    .label bp = vp
    .label w = 2
    lda #<$4d2
    sta.z w
    lda #>$4d2
    sta.z w+1
    lda bp
    sta SCREEN
    rts
}
