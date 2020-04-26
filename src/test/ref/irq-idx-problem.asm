// Test interrupt routine using a variable between calls (irq_idx)
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label RASTER = $d012
  .label VIC_CONTROL = $d011
  // VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  // VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  // Bits for the IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  .label SCREEN = $400
  .label VIC_BASE = $d000
  .const VIC_SIZE = $30
  .const IRQ_CHANGE_NEXT = $7f
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  .label irq_idx = 2
__bbegin:
  // irq_idx = 0
  lda #0
  sta.z irq_idx
  jsr main
  rts
main: {
    // asm
    sei
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // *VIC_CONTROL &=$7f
    // Set raster line to $60
    lda #$7f
    and VIC_CONTROL
    sta VIC_CONTROL
    // *RASTER = $60
    lda #$60
    sta RASTER
    // *IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge any IRQ
    sta IRQ_STATUS
    // *KERNEL_IRQ = &table_driven_irq
    // Setup the table driven IRQ routine
    lda #<table_driven_irq
    sta KERNEL_IRQ
    lda #>table_driven_irq
    sta KERNEL_IRQ+1
    // asm
    cli
    // }
    rts
}
table_driven_irq: {
  __b1:
    // idx = IRQ_CHANGE_IDX[irq_idx]
    ldy.z irq_idx
    lda IRQ_CHANGE_IDX,y
    // val = IRQ_CHANGE_VAL[irq_idx]
    ldx IRQ_CHANGE_VAL,y
    // irq_idx++;
    inc.z irq_idx
    // if (idx < VIC_SIZE)
    cmp #VIC_SIZE
    bcc __b2
    // if (idx < VIC_SIZE + 8)
    cmp #VIC_SIZE+8
    bcc __b3
    // *IRQ_STATUS = IRQ_RASTER
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // *RASTER = val
    stx RASTER
    // if (val < *RASTER)
    ldy RASTER
    sty.z $ff
    cpx.z $ff
    bcc !__ea81+
    jmp $ea81
  !__ea81:
    // irq_idx = 0
    lda #0
    sta.z irq_idx
    // }
    jmp $ea81
  __b3:
    // SCREEN[idx + $3f8 - VIC_SIZE] = val
    tay
    txa
    sta SCREEN+-VIC_SIZE+$3f8,y
    jmp __b1
  __b2:
    // VIC_BASE[idx] = val
    tay
    txa
    sta VIC_BASE,y
    jmp __b1
}
  IRQ_CHANGE_IDX: .byte $20, $21, IRQ_CHANGE_NEXT, $20, $21, IRQ_CHANGE_NEXT, $20, $21, IRQ_CHANGE_NEXT, $20, $21, IRQ_CHANGE_NEXT
  IRQ_CHANGE_VAL: .byte $b, $b, $63, 0, 0, $80, 7, 7, $83, 0, 0, $60
