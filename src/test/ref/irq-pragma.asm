// A minimal working IRQ with #pragma defining the type
  // Commodore 64 PRG executable file
.file [name="irq-pragma.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  // The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  .label BG_COLOR = $d021
.segment Code
// The Interrupt Handler
irq: {
    // *BG_COLOR = 1
    lda #1
    sta BG_COLOR
    // *BG_COLOR = 0
    lda #0
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
