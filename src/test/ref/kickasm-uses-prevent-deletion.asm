// Ensure that an inline kickasm uses-clause is anough to prevent a function from being deleted
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const BLACK = 0
  .const WHITE = 1
  // The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  .label BG_COLOR = $d021
main: {
    // kickasm
    sei
        lda #<irq;
        sta KERNEL_IRQ
        lda #>irq;
        sta KERNEL_IRQ+1
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
