// Unused interrupts pointing to each other but never used from main loop - should be optimized away
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label HARDWARE_IRQ = $fffe
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
