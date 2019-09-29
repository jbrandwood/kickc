// Error cleaning up unused blocks
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label B = $1000
main: {
  __b1:
    jsr menu
    jmp __b1
}
menu: {
    jsr mode
    rts
}
mode: {
  __b1:
    lda B
    cmp #0
    bne __b1
    jmp __b1
}
