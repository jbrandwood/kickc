// Illustrates a problem where volatiles with initializers are initialized outside the main()-routine
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label x = 2
__bbegin:
  lda #$c
  sta.z x
  jsr main
  rts
main: {
  __b1:
    inc.z x
    lda.z x
    cmp #$32
    bcc __b1
    lda #0
    sta.z x
    rts
}
