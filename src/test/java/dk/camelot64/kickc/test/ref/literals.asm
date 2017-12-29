.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  .const char = 'a'
  .const num = 1
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
  nums: .byte 2, 3, 4, 5
  str: .text "bc"+"d"+'e'
