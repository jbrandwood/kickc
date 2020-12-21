// Test string encoding via literals
  // Commodore 64 PRG executable file
.file [name="string-encoding-literals.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label D018 = $d018
    // *D018 = 0x16
    lda #$16
    sta D018
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
    // (SCREEN+40*6)[i] = ascii[i]
    lda ascii,x
    sta SCREEN+$28*6,x
    // (SCREEN+40*7)[i] = atascii[i]
    lda atascii,x
    sta SCREEN+$28*7,x
    // (SCREEN+40*8)[i] = screencode_atari[i]
    lda screencode_atari,x
    sta SCREEN+$28*8,x
    // (SCREEN+40*9)[i] = standard[i]
    lda standard,x
    sta SCREEN+$28*9,x
    // (SCREEN+40*10)[i] = no_null[i]
    lda no_null,x
    sta SCREEN+$28*$a,x
    // for( char i: 0..7 )
    inx
    cpx #8
    bne __b1
    // }
    rts
}
.segment Data
  no_null: .text "abcABC1"
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
.encoding "ascii"
  ascii: .text "abcABC7"
  .byte 0
.encoding "ascii"
  atascii: .text "abcABC8"
  .byte 0
.encoding "ascii"
  screencode_atari: .text @"abc\$21\$22\$23\$19"
  .byte 0
.encoding "screencode_mixed"
  standard: .text "abcABC0"
  .byte 0
