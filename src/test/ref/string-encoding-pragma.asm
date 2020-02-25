// Test string encoding via literals
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // (SCREEN+40*2)[i] = screencode_mixed1[i]
    lda screencode_mixed1,x
    sta SCREEN+$28*2,x
    // (SCREEN+40*0)[i] = petscii_mixed1[i]
    lda petscii_mixed1,x
    sta SCREEN,x
    // (SCREEN+40*1)[i] = petscii_mixed2[i]
    lda petscii_mixed2,x
    sta SCREEN+$28*1,x
    // (SCREEN+40*2)[i] = screencode_mixed2[i]
    lda screencode_mixed2,x
    sta SCREEN+$28*2,x
    // (SCREEN+40*4)[i] = screencode_upper[i]
    lda screencode_upper,x
    sta SCREEN+$28*4,x
    // (SCREEN+40*3)[i] = screencode_mixed3[i]
    lda screencode_mixed3,x
    sta SCREEN+$28*3,x
    // for( char i: 0..5 )
    inx
    cpx #6
    bne __b1
    // }
    rts
}
  // Default encoding (screencode_mixed)
  screencode_mixed1: .text "abcABC1"
  .byte 0
.encoding "petscii_mixed"
  petscii_mixed1: .text "abcABC2"
  .byte 0
  petscii_mixed2: .text "abcABC3"
  .byte 0
.encoding "screencode_mixed"
  screencode_mixed2: .text "abcABC4"
  .byte 0
  // Override default encoding using suffix
.encoding "screencode_upper"
  screencode_upper: .text "abcABC5"
  .byte 0
.encoding "screencode_mixed"
  screencode_mixed3: .text "abcABC6"
  .byte 0
