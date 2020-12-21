// Unused interrupts pointing to each other but never used from main loop - should be optimized away
  // Commodore 64 PRG executable file
.file [name="unused-irq.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
  .label HARDWARE_IRQ = $fffe
.segment Code
// Unused Interrupt Routine
irq2: {
    // *HARDWARE_IRQ = &irq1
    lda #<irq1
    sta HARDWARE_IRQ
    lda #>irq1
    sta HARDWARE_IRQ+1
    // }
    jmp $ea81
}
// Unused Interrupt Routine
irq1: {
    // *HARDWARE_IRQ = &irq2
    lda #<irq2
    sta HARDWARE_IRQ
    lda #>irq2
    sta HARDWARE_IRQ+1
    // }
    jmp $ea81
}
main: {
    // *SCREEN = 'x'
    lda #'x'
    sta SCREEN
    // }
    rts
}
