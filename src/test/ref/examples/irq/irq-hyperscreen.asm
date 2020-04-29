// A raster IRQ that opens the top/bottom border.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  .const VIC_RSEL = 8
  // Bits for the VICII IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // The VIC-II MOS 6567/6569
  .label VICII = $d000
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  .const WHITE = 1
  .const RED = 2
  .label GHOST_BYTE = $3fff
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  .const OFFSET_STRUCT_MOS6569_VICII_CONTROL1 = $11
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MOS6569_VICII_IRQ_ENABLE = $1a
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  .const OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS = $19
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
    // VICII->CONTROL1 &=$7f
    // Set raster line to $fa
    lda #$7f
    and VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    // VICII->RASTER = $fa
    lda #$fa
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // VICII->IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_ENABLE
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
    // VICII->BORDER_COLOR = WHITE
    lda #WHITE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // VICII->CONTROL1 |= VIC_RSEL
    // Set screen height back to 25 lines (preparing for the next screen)
    lda #VIC_RSEL
    ora VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    // VICII->IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS
    // VICII->RASTER = $fa
    // Trigger IRQ 1 at line $fa
    lda #$fa
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // *KERNEL_IRQ = &irq_bottom_1
    lda #<irq_bottom_1
    sta KERNEL_IRQ
    lda #>irq_bottom_1
    sta KERNEL_IRQ+1
    // VICII->BORDER_COLOR = RED
    lda #RED
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // }
    jmp $ea31
}
// Interrupt Routine 1
irq_bottom_1: {
    // VICII->BORDER_COLOR = WHITE
    lda #WHITE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // VICII->CONTROL1 &= ($ff^VIC_RSEL)
    // Set screen height to 24 lines - this is done after the border should have started drawing - so it wont start
    lda #$ff^VIC_RSEL
    and VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    // VICII->IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS
    // VICII->RASTER = $fd
    // Trigger IRQ 2 at line $fd
    lda #$fd
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // *KERNEL_IRQ = &irq_bottom_2
    lda #<irq_bottom_2
    sta KERNEL_IRQ
    lda #>irq_bottom_2
    sta KERNEL_IRQ+1
    // VICII->BORDER_COLOR = RED
    lda #RED
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // }
    jmp $ea81
}
