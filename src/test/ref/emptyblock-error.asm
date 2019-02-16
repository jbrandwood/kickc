.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label B = $1000
//  Error cleaning up unused blocks
main: {
    lda #0
  b2:
    jsr menu
    jmp b2
}
menu: {
    jsr mode
    rts
}
mode: {
  b2:
    lda B
    cmp #0
    bne b2
    jmp b2
}
