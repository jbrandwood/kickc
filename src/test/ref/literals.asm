.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const ch = 'a'
  .const num = 1
main: {
    lda #ch
    sta SCREEN
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
  str: .text "bcde"
  .byte 0
  nums: .byte 2, 3, 4, 5
