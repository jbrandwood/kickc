// A minimal working IRQ
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
  // The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
// Setup the IRQ routine
main: {
    // asm
    sei
    // *KERNEL_IRQ = &irq
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    // asm
    cli
    // }
    rts
}
// The Interrupt Handler
irq: {
    // *BGCOL = WHITE
    lda #WHITE
    sta BGCOL
    // *BGCOL = BLACK
    lda #BLACK
    sta BGCOL
    // }
    jmp $ea31
}
