.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label TABLE = $2000
main: {
    .label BORDERCOL = $d020
    ldx #0
  b2:
    lda TABLE,x
    sta BORDERCOL
    inx
    jmp b2
}
.pc = TABLE "TABLE"
  .byte 1, 2, 3

