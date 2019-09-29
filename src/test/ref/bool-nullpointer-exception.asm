// Some bool code that causes a NullPointerException
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    lda #1
    jmp __b2
  b1:
    lda #0
  __b2:
    cmp #0
    bne b1
    jmp __b2
}
