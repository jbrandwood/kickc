// A minimal working IRQ
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .label BG_COLOR = $d021
  // The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
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
    // *BG_COLOR = WHITE
    lda #WHITE
    sta BG_COLOR
    // *BG_COLOR = BLACK
    lda #BLACK
    sta BG_COLOR
    // }
    jmp $ea31
}
