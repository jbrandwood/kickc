// Tests minimal inline word
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const w = 1*$100+2
    .label screen = $400
    lda #<w
    sta screen
    lda #>w
    sta screen+1
    rts
}
