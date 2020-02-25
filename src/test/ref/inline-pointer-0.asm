// Tests creating a literal pointer from two bytes
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = 4*$100
    // *screen = 'a'
    lda #'a'
    sta screen
    // }
    rts
}
