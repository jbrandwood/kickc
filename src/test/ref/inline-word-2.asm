// Tests minimal inline word
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .const w = 1*$100+2
    lda #<w
    sta screen
    lda #>w
    sta screen+1
    rts
}
