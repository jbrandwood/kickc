.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label BGCOL = $d020
  .label col = 2
bbegin:
  lda #0
  sta col
  jsr main
  rts
main: {
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
  b2:
    inc col
    jmp b2
}
irq: {
    lda $dc0d
    lda col
    sta BGCOL
    jmp $ea81
}
