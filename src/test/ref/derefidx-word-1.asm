// Tests that array-indexing by a constant word is turned into a constant pointer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    // screen[40*10] = 'a'
    lda #'a'
    sta screen+$28*$a
    // }
    rts
}
