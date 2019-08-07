// Tests encoding of literal chars
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
.encoding "petscii_mixed"
  .const cpm = -$3f
.encoding "petscii_upper"
  .const cpu = $41
.encoding "screencode_mixed"
  .const csm = 'A'
.encoding "screencode_upper"
  .const csu = 1
  .label screen = $400
main: {
    lda #cpm
    sta screen
    lda #cpu
    sta screen+1
    lda #csm
    sta screen+2
    lda #csu
    sta screen+3
    lda spm
    sta screen+$28
    lda spu
    sta screen+$29
    lda ssm
    sta screen+$2a
    lda ssu
    sta screen+$2b
    rts
}
.encoding "petscii_mixed"
  spm: .text "A@"
.encoding "petscii_upper"
  spu: .text "A@"
.encoding "screencode_mixed"
  ssm: .text "A@"
.encoding "screencode_upper"
  ssu: .text "A@"
