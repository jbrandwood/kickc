.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    cpx #$80
    bcc __b2
    rts
  __b2:
    lda #'a'
    sta SCREEN,x
    lda #0
    sta $d020
    inx
    inx
    jmp __b1
}
