// Tests declaring a (constant) variable as __notconst
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label size = 2
__bbegin:
  lda #$28
  sta.z size
  jsr main
  rts
main: {
    ldx #0
  __b1:
    cpx.z size
    bcc __b2
    rts
  __b2:
    lda #'*'
    sta SCREEN,x
    inx
    jmp __b1
}
