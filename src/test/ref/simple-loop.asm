.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b2:
    lda #'a'
    sta SCREEN,x
    lda #0
    sta $d020
    inx
    inx
    cpx #$80
    bcc b2
    rts
}
