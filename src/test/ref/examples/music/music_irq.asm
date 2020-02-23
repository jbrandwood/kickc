// A simple SID music player using RASTER IRQ
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label VIC_CONTROL = $d011
  // VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  // VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  // Bits for the IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // CIA#1 Interrupt Status & Control Register
  .label CIA1_INTERRUPT = $dc0d
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  .label MUSIC = $1000
  // kickasm
  // Load the SID
  .const music = LoadSid("toiletrensdyr.sid")

// Place the SID into memory
// Setup Raster IRQ and initialize SID player
main: {
    // asm
    sei
    jsr music.init
    // *CIA1_INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    // *VIC_CONTROL &=$7f
    // Set raster line to $fd
    lda #$7f
    and VIC_CONTROL
    sta VIC_CONTROL
    // *RASTER = $fd
    lda #$fd
    sta RASTER
    // *IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // *KERNEL_IRQ = &irq_play
    // Set the IRQ routine
    lda #<irq_play
    sta KERNEL_IRQ
    lda #>irq_play
    sta KERNEL_IRQ+1
    // asm
    cli
    // }
    rts
}
// Raster IRQ Routine playing music
irq_play: {
    // (*BORDERCOL)++;
    inc BORDERCOL
    // asm
    // Play SID
    jsr music.play
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // (*BORDERCOL)--;
    dec BORDERCOL
    // }
    jmp $ea31
}
.pc = MUSIC "MUSIC"
  .fill music.size, music.getData(i)

