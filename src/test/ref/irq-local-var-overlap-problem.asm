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
  b1:
    lda #0
    sta.z i
  __b1:
    lda #0
    sta.z j
  __b2:
    lda #0
    sta.z k
  __b3:
    lda.z i
    clc
    adc.z j
    clc
    adc.z k
    sta FGCOL
    jsr sub_main
    inc.z k
    lda #$b
    cmp.z k
    bne __b3
    inc.z j
    cmp.z j
    bne __b2
    inc.z i
    cmp.z i
    bne __b1
    jmp b1
}
sub_main: {
    .label i = 5
    lda #0
    sta.z i
  __b1:
    ldx #0
  __b2:
    ldy #0
  __b3:
    txa
    clc
    adc.z i
    sty.z $ff
    clc
    adc.z $ff
    sta BGCOL
    iny
    cpy #$b
    bne __b3
    inx
    cpx #$b
    bne __b2
    inc.z i
    lda #$b
    cmp.z i
    bne __b1
    rts
}
irq: {
    .label k = 8
    .label j = 7
    .label i = 6
    inc BGCOL
    lda #0
    sta.z i
  __b1:
    lda #0
    sta.z j
  __b2:
    lda #0
    sta.z k
  __b3:
    lda.z i
    clc
    adc.z j
    clc
    adc.z k
    sta FGCOL
    jsr sub_irq
    inc.z k
    lda #$b
    cmp.z k
    bne __b3
    inc.z j
    cmp.z j
    bne __b2
    inc.z i
    cmp.z i
    bne __b1
    lda #IRQ_RASTER
    sta IRQ_STATUS
    dec BGCOL
    jmp $ea81
}
sub_irq: {
    .label i = 9
    lda #0
    sta.z i
  __b1:
    ldx #0
  __b2:
    ldy #0
  __b3:
    txa
    clc
    adc.z i
    sty.z $ff
    clc
    adc.z $ff
    sta BGCOL
    iny
    cpy #$b
    bne __b3
    inx
    cpx #$b
    bne __b2
    inc.z i
    lda #$b
    cmp.z i
    bne __b1
    rts
}
