// Test a short array initializer - the rest should be zero-filled
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    lda msg1,x
    cmp #0
    bne __b2
    ldx #0
  __b3:
    lda msg2,x
    cmp #0
    bne __b4
    rts
  __b4:
    lda msg2,x
    sta SCREEN+$28,x
    inx
    jmp __b3
  __b2:
    lda msg1,x
    sta SCREEN,x
    inx
    jmp __b1
}
  msg1: .text "camelot"
  .byte 0
  .fill 8, 0
  msg2: .byte 'c', 'm', 'l'
  .fill $d, 0
