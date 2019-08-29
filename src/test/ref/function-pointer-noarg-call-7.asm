// Tests calling into a function pointer with local variables
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label idx = 3
bbegin:
  lda #0
  sta.z idx
  jsr main
  rts
main: {
    jsr do10
    rts
}
do10: {
    .label i = 2
    lda #0
    sta.z i
  b1:
    jsr hello
    inc.z i
    lda #$a
    cmp.z i
    bne b1
    rts
}
hello: {
    ldx #0
  b1:
    lda msg,x
    ldy.z idx
    sta SCREEN,y
    inc.z idx
    inx
    lda msg,x
    cmp #0
    bne b1
    rts
}
  msg: .text "hello "
  .byte 0
