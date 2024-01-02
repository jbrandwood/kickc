// Test interrupt routine using a variable between calls (irq_idx)
/// @file
/// Commodore 64 Registers and Constants
/// @file
/// The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="irq-idx-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
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
  .const VICII_SIZE = $30
  .const IRQ_CHANGE_NEXT = $7f
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  /// $D012 RASTER Raster counter
  .label RASTER = $d012
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
  /// The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  /// The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  .label SCREEN = $400
  .label VICII_BASE = $d000
  .label irq_idx = 2
.segment Code
__start: {
    // volatile byte irq_idx = 0
    lda #0
    sta.z irq_idx
    jsr main
    rts
}
table_driven_irq: {
  __b1:
    // byte idx = IRQ_CHANGE_IDX[irq_idx]
    ldy.z irq_idx
    lda IRQ_CHANGE_IDX,y
    // byte val = IRQ_CHANGE_VAL[irq_idx]
    ldx IRQ_CHANGE_VAL,y
    // irq_idx++;
    inc.z irq_idx
    // if (idx < VICII_SIZE)
    cmp #VICII_SIZE
    bcc __b2
    // if (idx < VICII_SIZE + 8)
    cmp #VICII_SIZE+8
    bcc __b3
    // *IRQ_STATUS = IRQ_RASTER
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // *RASTER = val
    stx RASTER
    // if (val < *RASTER)
    cpx RASTER
    bcc !__ea81+
    jmp $ea81
  !__ea81:
    // irq_idx = 0
    lda #0
    sta.z irq_idx
    // }
    jmp $ea81
  __b3:
    // SCREEN[idx + $3f8 - VICII_SIZE] = val
    tay
    txa
    sta SCREEN+-VICII_SIZE+$3f8,y
    jmp __b1
  __b2:
    // VICII_BASE[idx] = val
    tay
    txa
    sta VICII_BASE,y
    jmp __b1
}
main: {
    // asm
    sei
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR_ALL
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR_ALL
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // *VICII_CONTROL1 &=$7f
    // Set raster line to $60
    lda #$7f
    and VICII_CONTROL1
    sta VICII_CONTROL1
    // *RASTER = $60
    lda #$60
    sta RASTER
    // *IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge any IRQ
    sta IRQ_STATUS
    // *KERNEL_IRQ = &table_driven_irq
    // Setup the table driven IRQ routine
    lda #<table_driven_irq
    sta KERNEL_IRQ
    lda #>table_driven_irq
    sta KERNEL_IRQ+1
    // asm
    cli
    // }
    rts
}
.segment Data
  IRQ_CHANGE_IDX: .byte $20, $21, IRQ_CHANGE_NEXT, $20, $21, IRQ_CHANGE_NEXT, $20, $21, IRQ_CHANGE_NEXT, $20, $21, IRQ_CHANGE_NEXT
  IRQ_CHANGE_VAL: .byte $b, $b, $63, 0, 0, $80, 7, 7, $83, 0, 0, $60
