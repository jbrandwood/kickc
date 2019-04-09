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
    .label sb = 2
    lda #$ff
    sta ub
    lda #1
    sta sb_ptr
    lda ub
    sta ub_screen
    lda #$7f
    sta sb
    lda #1
    sta ub_ptr
    lda sb
    sta sb_screen
    rts
}
