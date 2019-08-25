.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b1:
    cpx #$80
    bcc b2
    rts
  b2:
    lda #'a'
    sta SCREEN,x
    lda #0
    sta $d020
    inx
    inx
    jmp b1
}
