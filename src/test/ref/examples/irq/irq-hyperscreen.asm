// A raster IRQ that opens the top/bottom border.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label VIC_CONTROL = $d011
  .const VIC_RSEL = 8
  // VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  // VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  // Bits for the IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  .const WHITE = 1
  .const RED = 2
  .label GHOST_BYTE = $3fff
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
main: {
    // *GHOST_BYTE = 0
    lda #0
    sta GHOST_BYTE
    // asm
    sei
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // *VIC_CONTROL &=$7f
    // Set raster line to $fa
    lda #$7f
    and VIC_CONTROL
    sta VIC_CONTROL
    // *RASTER = $fa
    lda #$fa
    sta RASTER
    // *IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // *KERNEL_IRQ = &irq_bottom_1
    // Set the IRQ routine
    lda #<irq_bottom_1
    sta KERNEL_IRQ
    lda #>irq_bottom_1
    sta KERNEL_IRQ+1
    // asm
    cli
    // }
    rts
}
// Interrupt Routine 2
irq_bottom_2: {
    // *BORDERCOL = WHITE
    lda #WHITE
    sta BORDERCOL
    // *VIC_CONTROL |= VIC_RSEL
    // Set screen height back to 25 lines (preparing for the next screen)
    lda #VIC_RSEL
    ora VIC_CONTROL
    sta VIC_CONTROL
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // *RASTER = $fa
    // Trigger IRQ 1 at line $fa
    lda #$fa
    sta RASTER
    // *KERNEL_IRQ = &irq_bottom_1
    lda #<irq_bottom_1
    sta KERNEL_IRQ
    lda #>irq_bottom_1
    sta KERNEL_IRQ+1
    // *BORDERCOL = RED
    lda #RED
    sta BORDERCOL
    // }
    jmp $ea31
}
// Interrupt Routine 1
irq_bottom_1: {
    // *BORDERCOL = WHITE
    lda #WHITE
    sta BORDERCOL
    // *VIC_CONTROL &= ($ff^VIC_RSEL)
    // Set screen height to 24 lines - this is done after the border should have started drawing - so it wont start
    lda #$ff^VIC_RSEL
    and VIC_CONTROL
    sta VIC_CONTROL
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // *RASTER = $fd
    // Trigger IRQ 2 at line $fd
    lda #$fd
    sta RASTER
    // *KERNEL_IRQ = &irq_bottom_2
    lda #<irq_bottom_2
    sta KERNEL_IRQ
    lda #>irq_bottom_2
    sta KERNEL_IRQ+1
    // *BORDERCOL = RED
    lda #RED
    sta BORDERCOL
    // }
    jmp $ea81
}
