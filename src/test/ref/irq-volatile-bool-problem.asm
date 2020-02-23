// Illustrates a problem where a volatile bool modified at the end of an IRQ is not stored properly
// because it is assigned to the A register
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
  .label CIA1_INTERRUPT = $dc0d
  .const CIA_INTERRUPT_CLEAR = $7f
main: {
    // asm
    sei
    // *CIA1_INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    // *VIC_CONTROL &=$7f
    // Set raster line to $0fd
    lda #$7f
    and VIC_CONTROL
    sta VIC_CONTROL
    // *RASTER = $fd
    lda #$fd
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
  __b1:
    // if(*RASTER<20)
    lda RASTER
    cmp #$14
    bcs __b1
    jmp __b1
}
irq: {
    // (*BGCOL)++;
    inc BGCOL
    // *IRQ_STATUS = IRQ_RASTER
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // if (*RASTER>50)
    lda RASTER
    cmp #$32+1
    // (*BGCOL)--;
    dec BGCOL
    // }
    jmp $ea81
}
