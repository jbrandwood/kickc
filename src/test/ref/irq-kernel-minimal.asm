// A minimal working IRQ
  // Commodore 64 PRG executable file
.file [name="irq-kernel-minimal.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  /// The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  /// $D021 Background Color 0
  .label BG_COLOR = $d021
  /// The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
.segment Code
// The Interrupt Handler
irq: {
    // *BG_COLOR = WHITE
    lda #WHITE
    sta BG_COLOR
    // *BG_COLOR = BLACK
    lda #BLACK
    sta BG_COLOR
    // }
    jmp $ea31
}
// Setup the IRQ routine
main: {
    // asm
    sei
    // *KERNEL_IRQ = &irq
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    // asm
    cli
    // }
    rts
}
