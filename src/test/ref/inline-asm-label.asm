// Illustrates how inline assembler use internal labels and external references
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // asm
    ldx #0
  nxt:
    lda table,x
    sta SCREEN+1,x
    inx
    cpx #4
    bne nxt
    // }
    rts
}
  table: .text "cml!"
