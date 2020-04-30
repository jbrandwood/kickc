// A minimal working raster IRQ
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const IRQ_RASTER = 1
  .const WHITE = 1
  .const BLACK = 0
  .const CIA_INTERRUPT_CLEAR = $7f
  .label KERNEL_IRQ = $314
  .label RASTER = $d012
  .label VIC_CONTROL = $d011
  .label IRQ_STATUS = $d019
  .label IRQ_ENABLE = $d01a
  .label BGCOL = $d020
  .label CIA1_INTERRUPT = $dc0d
main: {
    // asm
    sei
    // *CIA1_INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    // *VIC_CONTROL |=$80
    // Set raster line to $100
    lda #$80
    ora VIC_CONTROL
    sta VIC_CONTROL
    // *RASTER = $00
    lda #0
    sta RASTER
    // *IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // *KERNEL_IRQ = &irq
    // Set the IRQ routine
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    // asm
    cli
    // }
    rts
}
// Interrupt Routine
irq: {
    // *BGCOL = WHITE
    lda #WHITE
    sta BGCOL
    // *BGCOL = BLACK
    lda #BLACK
    sta BGCOL
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // }
    jmp $ea31
}
