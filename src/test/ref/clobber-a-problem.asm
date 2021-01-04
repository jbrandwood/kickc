  // Commodore 64 PRG executable file
.file [name="clobber-a-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const DARK_GREY = $b
  .const BLACK = 0
  .label KERNEL_IRQ = $314
  .label BORDER_COLOR = $d020
  .label RASTER = $d012
  .label irq_raster_next = 2
.segment Code
__start: {
    // irq_raster_next = 0
    lda #0
    sta.z irq_raster_next
    jsr main
    rts
}
irq: {
    sta rega+1
    stx regx+1
    // *BORDER_COLOR = DARK_GREY
    lda #DARK_GREY
    sta BORDER_COLOR
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
    // *BORDER_COLOR = BLACK
    lda #BLACK
    sta BORDER_COLOR
    // }
  rega:
    lda #0
  regx:
    ldx #0
    rti
}
main: {
    // *KERNEL_IRQ = &irq
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    // }
    rts
}
