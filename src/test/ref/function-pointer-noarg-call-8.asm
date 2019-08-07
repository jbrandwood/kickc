// Tests calling into a function pointer with local variables
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label msg = 3
  .label idx = 5
bbegin:
  lda #<0
  sta msg
  sta msg+1
  sta idx
  jsr main
  rts
main: {
    lda #<msg1
    sta msg
    lda #>msg1
    sta msg+1
    jsr do10
    lda #<msg2
    sta msg
    lda #>msg2
    sta msg+1
    jsr do10
    rts
}
do10: {
    .label i = 2
    lda #0
    sta i
  b1:
    jsr hello
    inc i
    lda #$a
    cmp i
    bne b1
    rts
}
hello: {
    ldy #0
  b1:
    lda (msg),y
    ldx idx
    sta SCREEN,x
    inc idx
    iny
    lda (msg),y
    cmp #'@'
    bne b1
    rts
}
  msg1: .text "hello "
  .byte 0
  msg2: .text "world "
  .byte 0
