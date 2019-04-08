// Illustrates a problem where local variables inside an IRQ are assigned the same zeropage as a variable outside the IRQ
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label RASTER = $d012
  .label VIC_CONTROL = $d011
  .label IRQ_STATUS = $d019
  .label IRQ_ENABLE = $d01a
  .const IRQ_RASTER = 1
  .label BGCOL = $d020
  .label FGCOL = $d021
  .label CIA1_INTERRUPT = $dc0d
  .const CIA_INTERRUPT_CLEAR = $7f
main: {
    .label k = 4
    .label j = 3
    .label i = 2
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
  b4:
    lda #0
    sta i
  b1:
    lda #0
    sta j
  b2:
    lda #0
    sta k
  b3:
    lda i
    clc
    adc j
    clc
    adc k
    sta FGCOL
    jsr sub_main
    inc k
    lda #$b
    cmp k
    bne b3
    inc j
    cmp j
    bne b2
    inc i
    cmp i
    bne b1
    jmp b4
}
sub_main: {
    .label i = 5
    lda #0
    sta i
  b1:
    ldx #0
  b2:
    ldy #0
  b3:
    txa
    clc
    adc i
    sty $ff
    clc
    adc $ff
    sta BGCOL
    iny
    cpy #$b
    bne b3
    inx
    cpx #$b
    bne b2
    inc i
    lda #$b
    cmp i
    bne b1
    rts
}
irq: {
    .label k = 8
    .label j = 7
    .label i = 6
    inc BGCOL
    lda #0
    sta i
  b1:
    lda #0
    sta j
  b2:
    lda #0
    sta k
  b3:
    lda i
    clc
    adc j
    clc
    adc k
    sta FGCOL
    jsr sub_irq
    inc k
    lda #$b
    cmp k
    bne b3
    inc j
    cmp j
    bne b2
    inc i
    cmp i
    bne b1
    lda #IRQ_RASTER
    sta IRQ_STATUS
    dec BGCOL
    jmp $ea81
}
sub_irq: {
    .label i = 9
    lda #0
    sta i
  b1:
    ldx #0
  b2:
    ldy #0
  b3:
    txa
    clc
    adc i
    sty $ff
    clc
    adc $ff
    sta BGCOL
    iny
    cpy #$b
    bne b3
    inx
    cpx #$b
    bne b2
    inc i
    lda #$b
    cmp i
    bne b1
    rts
}
