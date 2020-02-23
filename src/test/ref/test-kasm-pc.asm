// Test inline KickAssembler code with PC location specification
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label TABLE = $2000
  // kickasm
main: {
    .label BORDERCOL = $d020
    ldx #0
  __b2:
    // *BORDERCOL = TABLE[i++]
    lda TABLE,x
    sta BORDERCOL
    // *BORDERCOL = TABLE[i++];
    inx
    jmp __b2
}
.pc = TABLE "TABLE"
  .byte 1, 2, 3

