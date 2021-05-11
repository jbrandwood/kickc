// Ensure that an inline kickasm uses-clause is anough to prevent a function from being deleted
  // Commodore 64 PRG executable file
.file [name="kickasm-uses-prevent-deletion.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const BLACK = 0
  .const WHITE = 1
  .label KERNEL_IRQ = $314
  .label BG_COLOR = $d021
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
main: {
    // kickasm
    sei
        lda #<irq;
        sta KERNEL_IRQ
        lda #>irq;
        sta KERNEL_IRQ+1
        cli
    
    // }
    rts
}
