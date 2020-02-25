.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label BGCOL = $d020
  .label FGCOL = $d021
main: {
    // *KERNEL_IRQ = &irq
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
  __b1:
    // (*FGCOL)++;
    inc FGCOL
    jmp __b1
}
irq: {
    // (*BGCOL)++;
    inc BGCOL
    // asm
    lda $dc0d
    // }
    jmp $ea81
}
