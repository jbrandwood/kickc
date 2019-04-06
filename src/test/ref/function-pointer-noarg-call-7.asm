// Tests calling into a function pointer with local variables
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label idx = 3
bbegin:
  lda #0
  sta idx
  jsr main
  rts
main: {
    .label f = hello
    jsr do10
    rts
}
do10: {
    .label i = 2
    lda #0
    sta i
  b1:
    jsr main.f
    inc i
    lda #$a
    cmp i
    bne b1
    rts
}
hello: {
    ldx #0
  b1:
    lda msg,x
    ldy idx
    sta SCREEN,y
    inc idx
    inx
    lda msg,x
    cmp #'@'
    bne b1
    rts
}
  msg: .text "hello @"
