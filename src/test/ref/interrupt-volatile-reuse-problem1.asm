.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label SCREEN = $400
  .label col1 = 2
  .label col2 = 2
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
