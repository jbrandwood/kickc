.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const ch = 'a'
  .const num = 1
main: {
    // SCREEN[0] = ch
    lda #ch
    sta SCREEN
    // SCREEN[2] = num
    lda #num
    sta SCREEN+2
    ldx #0
  __b1:
    // SCREEN[4+i] = str[i]
    lda str,x
    sta SCREEN+4,x
    // SCREEN[9+i] = nums[i]
    lda nums,x
    sta SCREEN+9,x
    // for(byte i : 0..3)
    inx
    cpx #4
    bne __b1
    // }
    rts
}
  str: .text "bcde"
  .byte 0
  nums: .byte 2, 3, 4, 5
