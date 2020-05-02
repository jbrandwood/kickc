// Test inline KickAssembler code with PC location specification
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label TABLE = $2000
  // kickasm
main: {
    .label BORDER_COLOR = $d020
    ldx #0
  __b2:
    // *BORDER_COLOR = TABLE[i++]
    lda TABLE,x
    sta BORDER_COLOR
    // *BORDER_COLOR = TABLE[i++];
    inx
    jmp __b2
}
.pc = TABLE "TABLE"
  .byte 1, 2, 3

