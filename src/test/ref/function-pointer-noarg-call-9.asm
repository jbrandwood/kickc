// Tests calling into a function pointer which modifies global volatile
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label idx = 2
bbegin:
  lda #0
  sta idx
  jsr main
  rts
main: {
    jsr fn1
    lda #'a'
    ldy idx
    sta SCREEN,y
    jsr fn1
    lda #'a'
    ldy idx
    sta SCREEN,y
    rts
}
fn1: {
    inc idx
    rts
}
