.pc = $801 "Basic"
:BasicUpstart(__b1)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label BORDERCOL = $d020
  .label RASTER = $d012
  .const DARK_GREY = $b
  .const BLACK = 0
  .label irq_raster_next = 2
__b1:
  lda #0
  sta.z irq_raster_next
  jsr main
  rts
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
    lax.z irq_raster_next
    axs #-[$15]
    stx.z irq_raster_next
  // Setup next interrupt
    txa
    and #7
    cmp #0
    bne __b1
    dex
  __b1:
    stx RASTER
    lda #BLACK
    sta BORDERCOL
  rega:
    lda #00
  regx:
    ldx #00
    rti
}
