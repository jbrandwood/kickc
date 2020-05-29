// A minimal working raster hardware IRQ with clobber-based register savings
// Commodore 64 Registers and Constants
// The MOS 6526 Complex Interface Adapter (CIA)
// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // Bits for the VICII IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  .label RASTER = $d012
  .label BORDER_COLOR = $d020
  .label BG_COLOR = $d021
  .label VIC_CONTROL = $d011
  // VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  // VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
main: {
    // asm
    sei
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
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
    // *HARDWARE_IRQ = &irq
    // Set the IRQ routine
    lda #<irq
    sta HARDWARE_IRQ
    lda #>irq
    sta HARDWARE_IRQ+1
    // asm
    cli
  __b1:
    // (*BORDER_COLOR)++;
    inc BORDER_COLOR
    jmp __b1
}
// Interrupt Routine
irq: {
    sta rega+1
    // do_irq()
    jsr do_irq
    // }
  rega:
    lda #00
    rti
}
do_irq: {
    // *BG_COLOR = WHITE
    lda #WHITE
    sta BG_COLOR
    // *BG_COLOR = BLACK
    lda #BLACK
    sta BG_COLOR
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // }
    rts
}
