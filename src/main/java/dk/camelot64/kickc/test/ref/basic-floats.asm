.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    lda #$55
    ldy #$aa
    jsr $b391
    jsr $b1aa
    sty $fe
    sta $ff
    rts
}
