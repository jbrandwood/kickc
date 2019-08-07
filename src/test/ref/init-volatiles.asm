// Illustrates a problem where volatiles with initializers are initialized outside the main()-routine
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label x = 2
bbegin:
  lda #$c
  sta.z x
  jsr main
  rts
main: {
  b1:
    inc.z x
    lda.z x
    cmp #$32
    bcc b1
    lda #0
    sta.z x
    rts
}
