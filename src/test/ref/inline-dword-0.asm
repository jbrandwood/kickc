// Tests minimal inline dword
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const w = $1234*$10000+$5678
    .label screen = $400
    lda #<w
    sta screen
    lda #>w
    sta screen+1
    lda #<w>>$10
    sta screen+2
    lda #>w>>$10
    sta screen+3
    rts
}
