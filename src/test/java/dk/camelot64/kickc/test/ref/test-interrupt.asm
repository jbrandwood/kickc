.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  jsr main
main: {
    .label FGCOL = $d021
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
  b2:
    inc FGCOL
    jmp b2
}
irq: {
    .label BGCOL = $d020
    inc BGCOL
    lda $dc0d
    inc BGCOL
    jmp $ea81
}
