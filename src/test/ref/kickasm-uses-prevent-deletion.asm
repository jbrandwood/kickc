// Ensure that an inline kickasm uses-clause is anough to prevent a function from being deleted
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  .label BGCOL = $d021
  .const BLACK = 0
  .const WHITE = 1
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
    // *BGCOL = WHITE
    lda #WHITE
    sta BGCOL
    // *BGCOL = BLACK
    lda #BLACK
    sta BGCOL
    // }
    jmp $ea31
}
