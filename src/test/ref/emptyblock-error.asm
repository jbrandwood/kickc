// Error cleaning up unused blocks
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label B = $1000
main: {
  b1:
    jsr menu
    jmp b1
}
menu: {
    jsr mode
    rts
}
mode: {
  b1:
    lda B
    cmp #0
    bne b1
    jmp b1
}
