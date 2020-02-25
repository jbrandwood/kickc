// Test string encoding via literals
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // (SCREEN+40*0)[i] = petscii_mixed[i]
    lda petscii_mixed,x
    sta SCREEN,x
    // (SCREEN+40*1)[i] = petscii_upper[i]
    lda petscii_upper,x
    sta SCREEN+$28*1,x
    // (SCREEN+40*2)[i] = petscii_standard[i]
    lda petscii_standard,x
    sta SCREEN+$28*2,x
    // (SCREEN+40*3)[i] = screencode_mixed[i]
    lda screencode_mixed,x
    sta SCREEN+$28*3,x
    // (SCREEN+40*4)[i] = screencode_upper[i]
    lda screencode_upper,x
    sta SCREEN+$28*4,x
    // (SCREEN+40*5)[i] = screencode_standard[i]
    lda screencode_standard,x
    sta SCREEN+$28*5,x
    // (SCREEN+40*6)[i] = standard[i]
    lda standard,x
    sta SCREEN+$28*6,x
    // for( byte i: 0..5 )
    inx
    cpx #6
    bne __b1
    // }
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
