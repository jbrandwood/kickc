.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label BGCOL = $d020
  .label FGCOL = $d021
  jsr main
main: {
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
  b2:
    inc FGCOL
    jmp b2
}
irq: {
    inc BGCOL
    lda $dc0d
    jmp $ea81
}
