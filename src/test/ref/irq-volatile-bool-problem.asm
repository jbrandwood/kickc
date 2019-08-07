// Illustrates a problem where a volatile bool modified at the end of an IRQ is not stored properly
// because it is assigned to the A register
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label RASTER = $d012
  .label VIC_CONTROL = $d011
  .label IRQ_STATUS = $d019
  .label IRQ_ENABLE = $d01a
  .const IRQ_RASTER = 1
  .label BGCOL = $d020
  .label CIA1_INTERRUPT = $dc0d
  .const CIA_INTERRUPT_CLEAR = $7f
  .label framedone = 2
bbegin:
  lda #0
  sta.z framedone
  jsr main
  rts
main: {
    sei
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    // Set raster line to $0fd
    lda #$7f
    and VIC_CONTROL
    sta VIC_CONTROL
    lda #$fd
    sta RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // Set the IRQ routine
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    cli
  b2:
    lda RASTER
    cmp #$14
    bcs b2
    lda #1
    sta.z framedone
    jmp b2
}
irq: {
    inc BGCOL
    lda #IRQ_RASTER
    sta IRQ_STATUS
    lda RASTER
    cmp #$32+1
    bcc b1
    lda #0
    sta.z framedone
  b1:
    dec BGCOL
    jmp $ea81
}
