// Tests casting pointer types to other pointer types
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const sb = $ff
    .label sb_screen = $400
    // *sb_screen = sb
    lda #sb
    sta sb_screen
    // }
    rts
}
