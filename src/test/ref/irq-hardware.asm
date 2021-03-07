// A minimal working raster IRQ
  // Commodore 64 PRG executable file
.file [name="irq-hardware.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const IRQ_RASTER = 1
  .const WHITE = 1
  .const BLACK = 0
  .const CIA_INTERRUPT_CLEAR = $7f
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // RAM in $A000, $E000 I/O in $D000
  .const PROCPORT_RAM_IO = $35
  .label HARDWARE_IRQ = $fffe
  .label RASTER = $d012
  .label VICII_CONTROL1 = $d011
  .label IRQ_STATUS = $d019
  .label IRQ_ENABLE = $d01a
  .label BG_COLOR = $d020
  .label FGCOL = $d021
  .label CIA1_INTERRUPT = $dc0d
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
.segment Code
// Interrupt Routine
irq: {
    sta rega+1
    stx regx+1
    sty regy+1
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
  rega:
    lda #0
  regx:
    ldx #0
  regy:
    ldy #0
    rti
}
// RAM in $A000, $E000 CHAR ROM in $D000
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
    // *CIA1_INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
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
    // (*FGCOL)++;
    inc FGCOL
    jmp __b1
}
