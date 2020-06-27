.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label BG_COLOR = $d020
  .label FGCOL = $d021
irq: {
    // (*BG_COLOR)++;
    inc BG_COLOR
    // asm
    lda $dc0d
    // }
    jmp $ea81
}
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
