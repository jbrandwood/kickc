// Test memory model
// Demonstrates problem where post-increase on __ma memory variables is performed to early
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    lda #0
    sta i
  __b1:
    lda #'*'
    ldy i
    sta SCREEN,y
    tya
    cmp #4
    lda #0
    rol
    eor #1
    inc i
    cmp #0
    bne __b1
    rts
    i: .byte 0
}
