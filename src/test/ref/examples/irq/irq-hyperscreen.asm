//  A raster IRQ that opens the top/bottom border.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label VIC_CONTROL = $d011
  .const VIC_RSEL = 8
  //  VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  //  VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  //  Bits for the IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  //  CIA#1 Interrupt Status & Control Register
  .label CIA1_INTERRUPT = $dc0d
  //  Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  //  The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  .const WHITE = 1
  .const RED = 2
  .label GHOST_BYTE = $3fff
main: {
    lda #0
    sta GHOST_BYTE
    sei
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    lda VIC_CONTROL
    and #$7f
    sta VIC_CONTROL
    lda #$fa
    sta RASTER
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    lda #<irq_bottom_1
    sta KERNEL_IRQ
    lda #>irq_bottom_1
    sta KERNEL_IRQ+1
    cli
    rts
}
//  Interrupt Routine 2
irq_bottom_2: {
    lda #WHITE
    sta BORDERCOL
    lda VIC_CONTROL
    ora #VIC_RSEL
    sta VIC_CONTROL
    lda #IRQ_RASTER
    sta IRQ_STATUS
    lda #$fa
    sta RASTER
    lda #<irq_bottom_1
    sta KERNEL_IRQ
    lda #>irq_bottom_1
    sta KERNEL_IRQ+1
    lda #RED
    sta BORDERCOL
    jmp $ea31
}
//  Interrupt Routine 1
irq_bottom_1: {
    lda #WHITE
    sta BORDERCOL
    lda VIC_CONTROL
    and #$ff^VIC_RSEL
    sta VIC_CONTROL
    lda #IRQ_RASTER
    sta IRQ_STATUS
    lda #$fd
    sta RASTER
    lda #<irq_bottom_2
    sta KERNEL_IRQ
    lda #>irq_bottom_2
    sta KERNEL_IRQ+1
    lda #RED
    sta BORDERCOL
    jmp $ea81
}
