// Tests casting pointer types to other pointer types
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label ub_screen = $400
    .label sb_screen = $428
    .label sb_ptr = ub
    .label ub_ptr = sb
    .label ub = 2
    .label sb = 3
    // ub = 0xff
    lda #$ff
    sta.z ub
    // *sb_ptr = 1
    lda #1
    sta.z sb_ptr
    // *ub_screen = ub
    lda.z ub
    sta ub_screen
    // sb = (signed byte)0x7f
    lda #$7f
    sta.z sb
    // *ub_ptr = 1
    lda #1
    sta.z ub_ptr
    // *sb_screen = sb
    lda.z sb
    sta sb_screen
    // }
    rts
}
