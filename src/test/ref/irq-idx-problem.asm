// Test interrupt routine using a variable between calls (irq_idx)
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label RASTER = $d012
  .label VIC_CONTROL = $d011
  // VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  // VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  // Bits for the IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // CIA#1 Interrupt Status & Control Register
  .label CIA1_INTERRUPT = $dc0d
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  .label SCREEN = $400
  .label VIC_BASE = $d000
  .const VIC_SIZE = $30
  .const IRQ_CHANGE_NEXT = $7f
  .label irq_idx = 2
bbegin:
  lda #0
  sta irq_idx
  jsr main
  rts
main: {
    sei
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    // Set raster line to $60
    lda #$7f
    and VIC_CONTROL
    sta VIC_CONTROL
    lda #$60
    sta RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // Acknowledge any IRQ
    sta IRQ_STATUS
    // Setup the table driven IRQ routine
    lda #<table_driven_irq
    sta KERNEL_IRQ
    lda #>table_driven_irq
    sta KERNEL_IRQ+1
    cli
    rts
}
table_driven_irq: {
  b1:
    ldy irq_idx
    lda IRQ_CHANGE_IDX,y
    ldx IRQ_CHANGE_VAL,y
    inc irq_idx
    cmp #VIC_SIZE
    bcc b2
    cmp #VIC_SIZE+8
    bcc b3
    lda #IRQ_RASTER
    sta IRQ_STATUS
    stx RASTER
    ldy RASTER
    sty $ff
    cpx $ff
    bcc !_ea81+
    jmp $ea81
  !_ea81:
    lda #0
    sta irq_idx
    jmp $ea81
  b3:
    tay
    txa
    sta SCREEN+-VIC_SIZE+$3f8,y
    jmp b1
  b2:
    tay
    txa
    sta VIC_BASE,y
    jmp b1
}
  IRQ_CHANGE_VAL: .byte $b, $b, $63, 0, 0, $80, 7, 7, $83, 0, 0, $60
  IRQ_CHANGE_IDX: .byte $20, $21, IRQ_CHANGE_NEXT, $20, $21, IRQ_CHANGE_NEXT, $20, $21, IRQ_CHANGE_NEXT, $20, $21, IRQ_CHANGE_NEXT
