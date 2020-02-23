// Tests minimal inline word
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const w = 2*$100+1
    .label screen = $400
    // screen[0] = w
    lda #<w
    sta screen
    lda #>w
    sta screen+1
    // }
    rts
}
