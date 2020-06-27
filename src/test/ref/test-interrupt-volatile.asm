.pc = $801 "Basic"
:BasicUpstart(__start)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label BG_COLOR = $d020
  .label col = 2
__start: {
    // col = 0
    lda #0
    sta.z col
    jsr main
    rts
}
irq: {
    // asm
    lda $dc0d
    // *BG_COLOR = col
    lda.z col
    sta BG_COLOR
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
    // col++;
    inc.z col
    jmp __b1
}
