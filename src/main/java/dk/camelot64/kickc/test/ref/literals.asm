  .const SCREEN = $400
  .const char = 'a'
  .const num = 1
  .const str = "bc"+"d"+'e'
  nums: .byte 2, 3, 4, 5
  jsr main
main: {
    lda #char
    sta SCREEN+0
    lda #num
    sta SCREEN+2
    ldx #0
  b1:
    lda str,x
    sta SCREEN+4,x
    lda nums,x
    sta SCREEN+9,x
    inx
    cpx #4
    bne b1
    rts
}
