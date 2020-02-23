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
  // irq_raster_next = 0
  lda #0
  sta.z irq_raster_next
  jsr main
  rts
main: {
    // *KERNEL_IRQ = &irq
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    // }
    rts
}
irq: {
    sta rega+1
    stx regx+1
    // *BORDERCOL = DARK_GREY
    lda #DARK_GREY
    sta BORDERCOL
    // irq_raster_next += 21
    lax.z irq_raster_next
    axs #-[$15]
    stx.z irq_raster_next
    // raster_next = irq_raster_next
  // Setup next interrupt
    // raster_next&7
    txa
    and #7
    // if((raster_next&7)==0)
    cmp #0
    bne __b1
    // raster_next -=1
    dex
  __b1:
    // *RASTER = raster_next
    stx RASTER
    // *BORDERCOL = BLACK
    lda #BLACK
    sta BORDERCOL
    // }
  rega:
    lda #00
  regx:
    ldx #00
    rti
}
