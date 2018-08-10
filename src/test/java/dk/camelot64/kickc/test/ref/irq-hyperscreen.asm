.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label RASTER = $d012
  .label VIC_CONTROL = $d011
  .const VIC_RSEL = 8
  .label IRQ_STATUS = $d019
  .label IRQ_ENABLE = $d01a
  .const IRQ_RASTER = 1
  .label FGCOL = $d021
  .const WHITE = 1
  .const RED = 2
  .label CIA1_INTERRUPT = $dc0d
  .const CIA_INTERRUPT_CLEAR = $7f
  .label GHOST_BYTE = $3fff
  jsr main
main: {
    lda #0
    sta GHOST_BYTE
    sei
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    lda VIC_CONTROL
    and #$7f
    sta VIC_CONTROL
    lda #$fa
    sta RASTER
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    lda #<irq_bottom_1
    sta KERNEL_IRQ
    lda #>irq_bottom_1
    sta KERNEL_IRQ+1
    cli
    rts
}
irq_bottom_2: {
    lda #WHITE
    sta FGCOL
    lda VIC_CONTROL
    ora #VIC_RSEL
    sta VIC_CONTROL
    lda #IRQ_RASTER
    sta IRQ_STATUS
    lda #$fa
    sta RASTER
    lda #<irq_bottom_1
    sta KERNEL_IRQ
    lda #>irq_bottom_1
    sta KERNEL_IRQ+1
    lda #RED
    sta FGCOL
    jmp $ea31
}
irq_bottom_1: {
    lda #WHITE
    sta FGCOL
    lda VIC_CONTROL
    and #$ff^VIC_RSEL
    sta VIC_CONTROL
    lda #IRQ_RASTER
    sta IRQ_STATUS
    lda #$fd
    sta RASTER
    lda #<irq_bottom_2
    sta KERNEL_IRQ
    lda #>irq_bottom_2
    sta KERNEL_IRQ+1
    lda #RED
    sta FGCOL
    jmp $ea81
}
