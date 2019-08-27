// Tests assigning a literal word pointer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    jsr print
    rts
    str: .text "qwe"
    .byte 0
}
print: {
    lda #<main.str
    sta $80
    lda #>main.str
    sta $80+1
    rts
}
