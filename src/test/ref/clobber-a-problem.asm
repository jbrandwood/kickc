.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label BORDERCOL = $d020
  .label RASTER = $d012
  .const DARK_GREY = $b
  .const BLACK = 0
  .label KERNEL_IRQ = $314
  .label irq_raster_next = 2
bbegin:
  lda #0
  sta irq_raster_next
  jsr main
main: {
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    rts
}
irq: {
    sta rega+1
    stx regx+1
    lda #DARK_GREY
    sta BORDERCOL
    lax irq_raster_next
    axs #-[$15]
    stx irq_raster_next
  // Setup next interrupt
    txa
    and #7
    cmp #0
    bne b1
    dex
  b1:
    stx RASTER
    lda #BLACK
    sta BORDERCOL
  rega:
    lda #00
  regx:
    ldx #00
    rti
}
