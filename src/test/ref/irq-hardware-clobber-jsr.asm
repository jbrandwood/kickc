// A minimal working raster hardware IRQ with clobber-based register savings
/// @file
/// Commodore 64 Registers and Constants
/// @file
/// The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="irq-hardware-clobber-jsr.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  /// Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR_ALL = $7f
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
  /// The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  /// $D012 RASTER Raster counter
  .label RASTER = $d012
  /// $D020 Border Color
  .label BORDER_COLOR = $d020
  /// $D021 Background Color 0
  .label BG_COLOR = $d021
  /// $D011 Control Register #1
  /// - Bit#0-#2: YSCROLL Screen Soft Scroll Vertical
  /// - Bit#3: RSEL Switch betweem 25 or 24 visible rows
  ///          RSEL|  Display window height   | First line  | Last line
  ///          ----+--------------------------+-------------+----------
  ///            0 | 24 text lines/192 pixels |   55 ($37)  | 246 ($f6)
  ///            1 | 25 text lines/200 pixels |   51 ($33)  | 250 ($fa)
  /// - Bit#4: DEN Switch VIC-II output on/off
  /// - Bit#5: BMM Turn Bitmap Mode on/off
  /// - Bit#6: ECM Turn Extended Color Mode on/off
  /// - Bit#7: RST8 9th Bit for $D012 Rasterline counter
  /// Initial Value: %10011011
  .label VICII_CONTROL1 = $d011
  /// VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  /// VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  /// Processor port data direction register
  .label PROCPORT_DDR = 0
  /// Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  /// The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  /// The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
.segment Code
// Interrupt Routine
irq: {
    sta rega+1
    // do_irq()
    jsr do_irq
    // }
  rega:
    lda #0
    rti
}
main: {
    // asm
    sei
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta.z PROCPORT
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR_ALL
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR_ALL
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // *VICII_CONTROL1 |=$80
    // Set raster line to $100
    lda #$80
    ora VICII_CONTROL1
    sta VICII_CONTROL1
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
