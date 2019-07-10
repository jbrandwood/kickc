// Tests the simple bitmap plotter - and counts plots per frame in an IRQ
// Plots simple plots
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // RAM in $A000, $E000 I/O in $D000
  .const PROCPORT_RAM_IO = $35
  .label RASTER = $d012
  .label BGCOL = $d021
  .label VIC_CONTROL = $d011
  .label D011 = $d011
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label D018 = $d018
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
  // The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .label BITMAP = $2000
  .label SCREEN = $400
  .label frame_cnt = $e
bbegin:
  // Counts frames - updated by the IRQ
  lda #1
  sta frame_cnt
  jsr main
  rts
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>BITMAP)/4&$f
    .label x = 2
    .label y = 4
    .label vx = 5
    .label vy = 7
    jsr bitmap_init
    jsr bitmap_clear
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #toD0181_return
    sta D018
    jsr init_irq
    lda #1
    sta vy
    sta vx
    lda #>1
    sta vx+1
    sta y
    sta x
    sta x+1
  b2:
    ldx y
    jsr bitmap_plot
    lda x
    clc
    adc vx
    sta x
    lda x+1
    adc vx+1
    sta x+1
    lda y
    clc
    adc vy
    sta y
    lda x
    cmp #<$13f
    bne !+
    lda x+1
    cmp #>$13f
    beq b5
  !:
    lda x
    bne b3
    lda x+1
    bne b3
  b5:
    sec
    lda #0
    sbc vx
    sta vx
    lda #0
    sbc vx+1
    sta vx+1
  b3:
    lda #$c7
    cmp y
    beq b6
    lda y
    cmp #0
    bne b4
  b6:
    lda vy
    eor #$ff
    clc
    adc #1
    sta vy
  b4:
    ldx frame_cnt
    inc plots_per_frame,x
    jmp b2
}
// Plot a single dot in the bitmap
// bitmap_plot(word zeropage(2) x, byte register(X) y)
bitmap_plot: {
    .label _1 = $11
    .label plotter = $f
    .label x = 2
    lda bitmap_plot_yhi,x
    sta plotter+1
    lda bitmap_plot_ylo,x
    sta plotter
    lda x
    and #<$fff8
    sta _1
    lda x+1
    and #>$fff8
    sta _1+1
    lda plotter
    clc
    adc _1
    sta plotter
    lda plotter+1
    adc _1+1
    sta plotter+1
    lda x
    tay
    lda bitmap_plot_bit,y
    ldy #0
    ora (plotter),y
    sta (plotter),y
    rts
}
// Setup the IRQ
init_irq: {
    sei
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    // Set raster line to $100
    lda #$80
    ora VIC_CONTROL
    sta VIC_CONTROL
    lda #0
    sta RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // Set the IRQ routine
    lda #<irq
    sta HARDWARE_IRQ
    lda #>irq
    sta HARDWARE_IRQ+1
    cli
    rts
}
// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
bitmap_clear: {
    .const col = WHITE*$10
    ldx #col
    lda #<$3e8
    sta memset.num
    lda #>$3e8
    sta memset.num+1
    lda #<SCREEN
    sta memset.str
    lda #>SCREEN
    sta memset.str+1
    jsr memset
    ldx #0
    lda #<$1f40
    sta memset.num
    lda #>$1f40
    sta memset.num+1
    lda #<BITMAP
    sta memset.str
    lda #>BITMAP
    sta memset.str+1
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage(8) str, byte register(X) c, word zeropage($a) num)
memset: {
    .label end = $a
    .label dst = 8
    .label str = 8
    .label num = $a
    lda end
    clc
    adc str
    sta end
    lda end+1
    adc str+1
    sta end+1
  b1:
    txa
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp end+1
    bne b1
    lda dst
    cmp end
    bne b1
    rts
}
// Initialize bitmap plotting tables
bitmap_init: {
    .label _7 = $13
    .label yoffs = $c
    ldx #0
    lda #$80
  b1:
    sta bitmap_plot_bit,x
    lsr
    cmp #0
    bne b2
    lda #$80
  b2:
    inx
    cpx #0
    bne b1
    lda #<BITMAP
    sta yoffs
    lda #>BITMAP
    sta yoffs+1
    ldx #0
  b3:
    lda #7
    sax _7
    lda yoffs
    ora _7
    sta bitmap_plot_ylo,x
    lda yoffs+1
    sta bitmap_plot_yhi,x
    lda #7
    cmp _7
    bne b4
    clc
    lda yoffs
    adc #<$28*8
    sta yoffs
    lda yoffs+1
    adc #>$28*8
    sta yoffs+1
  b4:
    inx
    cpx #0
    bne b3
    rts
}
// Interrupt Routine counting frames
irq: {
    sta rega+1
    lda #WHITE
    sta BGCOL
    lda #0
    cmp frame_cnt
    beq b1
    inc frame_cnt
  b1:
    lda #BLACK
    sta BGCOL
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
  rega:
    lda #00
    rti
}
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  plots_per_frame: .fill $100, 0
