// Tests creating a literal pointer from two bytes
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    lda #'a'
    sta 4*$100+$28
    rts
}
