// Test string encoding via literals
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    lda petscii_mixed,x
    sta SCREEN,x
    lda petscii_upper,x
    sta SCREEN+$28*1,x
    lda petscii_standard,x
    sta SCREEN+$28*2,x
    lda screencode_mixed,x
    sta SCREEN+$28*3,x
    lda screencode_upper,x
    sta SCREEN+$28*4,x
    lda screencode_standard,x
    sta SCREEN+$28*5,x
    lda standard,x
    sta SCREEN+$28*6,x
    inx
    cpx #6
    bne __b1
    rts
}
.encoding "petscii_mixed"
  petscii_mixed: .text "abcABC1"
  .byte 0
.encoding "petscii_upper"
  petscii_upper: .text "abcABC2"
  .byte 0
.encoding "petscii_mixed"
  petscii_standard: .text "abcABC3"
  .byte 0
.encoding "screencode_mixed"
  screencode_mixed: .text "abcABC4"
  .byte 0
.encoding "screencode_upper"
  screencode_upper: .text "abcABC5"
  .byte 0
.encoding "screencode_mixed"
  screencode_standard: .text "abcABC6"
  .byte 0
  standard: .text "abcABC7"
  .byte 0
