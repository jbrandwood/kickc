// Some bool code that causes a NullPointerException
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    lda #1
    jmp __b2
  __b1:
    lda #0
  __b2:
    // while(!framedone)
    cmp #0
    bne __b1
    jmp __b2
}
