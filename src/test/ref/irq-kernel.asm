//  A minimal working raster IRQ
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label RASTER = $d012
  .label VIC_CONTROL = $d011
  .label IRQ_STATUS = $d019
  .label IRQ_ENABLE = $d01a
  .const IRQ_RASTER = 1
  .label BGCOL = $d020
  .const WHITE = 1
  .const BLACK = 0
  .label CIA1_INTERRUPT = $dc0d
  .const CIA_INTERRUPT_CLEAR = $7f
main: {
    sei
    //  Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    //  Set raster line to $100
    lda VIC_CONTROL
    ora #$80
    sta VIC_CONTROL
    lda #0
    sta RASTER
    //  Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    //  Set the IRQ routine
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    cli
    rts
}
//  Interrupt Routine
irq: {
    lda #WHITE
    sta BGCOL
    lda #BLACK
    sta BGCOL
    //  Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    jmp $ea31
}
