// A minimal working IRQ with #pragma defining the type
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  .label BG_COLOR = $d021
// The Interrupt Handler
irq: {
    // *BG_COLOR = 1
    lda #1
    sta BG_COLOR
    // *BG_COLOR = 0
    lda #0
    sta BG_COLOR
    // }
    jmp $ea31
}
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
