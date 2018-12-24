.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label x = 2
  lda #$c
  sta x
  jsr main
main: {
  b1:
    inc x
    lda x
    cmp #$32
    bcc b1
    lda #0
    sta x
    rts
}
