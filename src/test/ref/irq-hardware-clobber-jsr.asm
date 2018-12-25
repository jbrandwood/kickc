.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label PROCPORT_DDR = 0
  .const PROCPORT_DDR_MEMORY_MASK = 7
  .label PROCPORT = 1
  .const PROCPORT_RAM_IO = $35
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  .label VIC_CONTROL = $d011
  .label IRQ_STATUS = $d019
  .label IRQ_ENABLE = $d01a
  .const IRQ_RASTER = 1
  .label CIA1_INTERRUPT = $dc0d
  .const CIA_INTERRUPT_CLEAR = $7f
  .label HARDWARE_IRQ = $fffe
  .const BLACK = 0
  .const WHITE = 1
main: {
    sei
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    lda VIC_CONTROL
    ora #$80
    sta VIC_CONTROL
    lda #0
    sta RASTER
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    lda #<irq
    sta HARDWARE_IRQ
    lda #>irq
    sta HARDWARE_IRQ+1
    cli
  b2:
    inc BORDERCOL
    jmp b2
}
irq: {
    sta rega+1
    jsr do_irq
  rega:
    lda #00
    rti
}
do_irq: {
    lda #WHITE
    sta BGCOL
    lda #BLACK
    sta BGCOL
    lda #IRQ_RASTER
    sta IRQ_STATUS
    rts
}
