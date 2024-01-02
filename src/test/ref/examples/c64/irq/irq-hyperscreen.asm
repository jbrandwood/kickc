// A raster IRQ that opens the top/bottom border.
/// @file
/// Commodore 64 Registers and Constants
/// @file
/// The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="irq-hyperscreen.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  /// Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR_ALL = $7f
  /// $D011 Control Register #1  Bit#3: RSEL Switch betweem 25 or 24 visible rows
  ///          RSEL|  Display window height   | First line  | Last line
  ///          ----+--------------------------+-------------+----------
  ///            0 | 24 text lines/192 pixels |   55 ($37)  | 246 ($f6)
  ///            1 | 25 text lines/200 pixels |   51 ($33)  | 250 ($fa)
  .const VICII_RSEL = 8
  /// VICII IRQ Status/Enable Raster
  // @see #IRQ_ENABLE #IRQ_STATUS
  ///  0 | RST| Reaching a certain raster line. The line is specified by writing
  ///    |    | to register 0xd012 and bit 7 of $d011 and internally stored by
  ///    |    | the VIC for the raster compare. The test for reaching the
  ///    |    | interrupt raster line is done in cycle 0 of every line (for line
  ///    |    | 0, in cycle 1).
  .const IRQ_RASTER = 1
  /// Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  /// RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  .const WHITE = 1
  .const RED = 2
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  .const OFFSET_STRUCT_MOS6569_VICII_CONTROL1 = $11
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MOS6569_VICII_IRQ_ENABLE = $1a
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  .const OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS = $19
  /// Processor port data direction register
  .label PROCPORT_DDR = 0
  /// Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
  /// The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  /// The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
  .label GHOST_BYTE = $3fff
.segment Code
// Interrupt Routine 2
irq_bottom_2: {
    sta rega+1
    // VICII->BORDER_COLOR = WHITE
    lda #WHITE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // VICII->CONTROL1 |= VICII_RSEL
    // Set screen height back to 25 lines (preparing for the next screen)
    lda #VICII_RSEL
    ora VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    // VICII->IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS
    // VICII->RASTER = 0xfa
    // Trigger IRQ 1 at line 0xfa
    lda #$fa
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // *HARDWARE_IRQ = &irq_bottom_1
    lda #<irq_bottom_1
    sta HARDWARE_IRQ
    lda #>irq_bottom_1
    sta HARDWARE_IRQ+1
    // VICII->BORDER_COLOR = RED
    lda #RED
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // }
  rega:
    lda #0
    rti
}
// Interrupt Routine 1
irq_bottom_1: {
    sta rega+1
    // VICII->BORDER_COLOR = WHITE
    lda #WHITE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // VICII->CONTROL1 &= (0xff^VICII_RSEL)
    // Set screen height to 24 lines - this is done after the border should have started drawing - so it wont start
    lda #$ff^VICII_RSEL
    and VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    // VICII->IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS
    // VICII->RASTER = 0xfd
    // Trigger IRQ 2 at line 0xfd
    lda #$fd
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // *HARDWARE_IRQ = &irq_bottom_2
    lda #<irq_bottom_2
    sta HARDWARE_IRQ
    lda #>irq_bottom_2
    sta HARDWARE_IRQ+1
    // VICII->BORDER_COLOR = RED
    lda #RED
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // }
  rega:
    lda #0
    rti
}
main: {
    // *GHOST_BYTE = 0
    lda #0
    sta GHOST_BYTE
    // asm
    sei
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR_ALL
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR_ALL
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // VICII->CONTROL1 &= 0x7f
    // Set raster line to 0xfa
    lda #$7f
    and VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    // VICII->RASTER = 0xfa
    lda #$fa
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // VICII->IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_ENABLE
    // *HARDWARE_IRQ = &irq_bottom_1
    // Set the IRQ routine
    lda #<irq_bottom_1
    sta HARDWARE_IRQ
    lda #>irq_bottom_1
    sta HARDWARE_IRQ+1
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // no kernal or BASIC rom visible
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta.z PROCPORT
    // asm
    cli
  __b1:
    jmp __b1
}
