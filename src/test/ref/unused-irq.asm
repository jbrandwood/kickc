// Unused interrupts pointing to each other but never used from main loop - should be optimized away
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label HARDWARE_IRQ = $fffe
main: {
    lda #'x'
    sta SCREEN
    rts
}
// Unused Interrupt Routine
irq2: {
    lda #<irq1
    sta HARDWARE_IRQ
    lda #>irq1
    sta HARDWARE_IRQ+1
    jmp $ea81
}
// Unused Interrupt Routine
irq1: {
    lda #<irq2
    sta HARDWARE_IRQ
    lda #>irq2
    sta HARDWARE_IRQ+1
    jmp $ea81
}
