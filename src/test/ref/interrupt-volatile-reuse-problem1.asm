// Illustrates problem where volatiles reuse the same ZP addresses for multiple overlapping volatiles
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label SCREEN = $400
  .label col1 = 2
  .label col2 = 3
bbegin:
  lda #0
  sta.z col1
  lda #8
  sta.z col2
  jsr main
  rts
main: {
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    rts
}
irq: {
    lda.z col1
    sta SCREEN+$28
    inc.z col1
    lda.z col2
    sta SCREEN+$29
    inc.z col2
    jmp $ea81
}
