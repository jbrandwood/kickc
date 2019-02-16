.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  //  Illustrates problem where volatiles reuse the same ZP addresses for multiple overlapping volatiles
  .label KERNEL_IRQ = $314
  .label SCREEN = $400
  .label col1 = 2
  .label col2 = 3
bbegin:
  lda #0
  sta col1
  lda #8
  sta col2
  jsr main
main: {
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    rts
}
irq: {
    lda col1
    sta SCREEN+$28
    inc col1
    lda col2
    sta SCREEN+$29
    inc col2
    jmp $ea81
}
