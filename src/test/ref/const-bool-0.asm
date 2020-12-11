// Tests a complex constant binary
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    // *screen = bError
    lda #7&(($10|$20|$40)^$ff)
    sta screen
    // }
    rts
}
