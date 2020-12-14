// Example program for the Commander X16
// Displays raster bars in the border
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="rasterbars.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
.segment Code


  .const VERA_DCSEL = 2
  .const VERA_LINE = 2
  // $9F25	CTRL Control
  // Bit 7: Reset
  // Bit 1: DCSEL
  // Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
  // $9F26	IEN		Interrupt Enable
  // Bit 7: IRQ line (8)
  // Bit 3: AFLOW
  // Bit 2: SPRCOL
  // Bit 1: LINE
  // Bit 0: VSYNC
  .label VERA_IEN = $9f26
  // $9F27	ISR     Interrupt Status
  // Interrupts will be generated for the interrupt sources set in the lower 4 bits of IEN. ISR will indicate the interrupts that have occurred.
  // Writing a 1 to one of the lower 3 bits in ISR will clear that interrupt status. AFLOW can only be cleared by filling the audio FIFO for at least 1/4.
  // Bit 4-7: Sprite Collisions. This field indicates which groups of sprites have collided.
  // Bit 3: AFLOW
  // Bit 2: SPRCOL
  // Bit 1: LINE
  // Bit 0: VSYNC
  .label VERA_ISR = $9f27
  // $9F28	IRQLINE_L	IRQ line (7:0)
  // IRQ_LINE specifies at which line the LINE interrupt will be generated.
  // Note that bit 8 of this value is present in the IEN register.
  // For interlaced modes the interrupt will be generated each field and the bit 0 of IRQ_LINE is ignored.
  .label VERA_IRQLINE_L = $9f28
  // $9F2C	DC_BORDER (DCSEL=0)	Border Color
  .label VERA_DC_BORDER = $9f2c
  // $9F29	DC_HSTART (DCSEL=1)	Active Display H-Start (9:2)
  .label VERA_DC_HSTART = $9f29
  // $9F2A	DC_HSTOP (DCSEL=1)	Active Display H-Stop (9:2)
  .label VERA_DC_HSTOP = $9f2a
  // $0314	(RAM) IRQ vector - The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  // The horizontal start
  .label hstart = 2
  // The horizontal stop
  .label hstop = 3
  // The countdown
  .label cnt = 4
.segment Code
__start: {
    // hstart = 0/4
    lda #0
    sta.z hstart
    // hstop = 640/4
    lda #$280/4
    sta.z hstop
    // cnt = 2
    lda #2
    sta.z cnt
    jsr main
    rts
}
// Interrupt Routine at raster 0
irq_zero: {
    // *VERA_CTRL |= VERA_DCSEL
    // Update the border
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_HSTART = hstart
    lda.z hstart
    sta VERA_DC_HSTART
    // *VERA_DC_HSTOP = hstop
    lda.z hstop
    sta VERA_DC_HSTOP
    // *VERA_CTRL &= ~VERA_DCSEL
    // Show color raster bars in the border
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    ldx #0
  __b2:
    // for(char l=0;l!=255;l++)
    cpx #$ff
    bne __b3
    // *VERA_DC_BORDER = 0
    lda #0
    sta VERA_DC_BORDER
    // *VERA_CTRL |= VERA_DCSEL
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // if(--cnt==0)
    dec.z cnt
    lda.z cnt
    cmp #0
    bne __b1
    // cnt = 2
    lda #2
    sta.z cnt
    // if(hstart<=320/4)
    lda.z hstart
    cmp #$140/4+1
    bcs __b1
    // hstart++;
    inc.z hstart
    // hstop--;
    dec.z hstop
  __b1:
    // *VERA_ISR = VERA_LINE
    // Reset the LINE interrupt
    lda #VERA_LINE
    sta VERA_ISR
    // asm
    // Exit CX16 KERNAL IRQ
    ply
    plx
    pla
    rti
    // }
    rts
  __b3:
    // *VERA_DC_BORDER = BARS[l]
    lda BARS,x
    sta VERA_DC_BORDER
    lda #0
  __b5:
    // for(char i=0;i<23;i++)
    cmp #$17
    bcc __b6
    // for(char l=0;l!=255;l++)
    inx
    jmp __b2
  __b6:
    // for(char i=0;i<23;i++)
    inc
    jmp __b5
}
main: {
    // asm
    sei
    // *KERNEL_IRQ = &irq_zero
    lda #<irq_zero
    sta KERNEL_IRQ
    lda #>irq_zero
    sta KERNEL_IRQ+1
    // *VERA_IEN = VERA_LINE
    lda #VERA_LINE
    sta VERA_IEN
    // *VERA_IRQLINE_L = 0
    lda #0
    sta VERA_IRQLINE_L
    // asm
    cli
  __b1:
    jmp __b1
}
.segment Data
  .align $100
  BARS: .byte $10, 0, $11, 0, $12, 0, $13, 0, $14, 0, $15, 0, $16, 0, $17, 0, $18, 0, $19, 0, $1a, 0, $1b, 0, $1c, 0, $1d, 0, $1e, 0, $1f, 0, $1f, 0, $1e, 0, $1d, 0, $1c, 0, $1b, 0, $1a, 0, $19, 0, $18, 0, $17, 0, $16, 0, $15, 0, $14, 0, $13, 0, $12, 0, $11, 0, $10, 0, $10, 0, $11, 0, $12, 0, $13, 0, $14, 0, $15, 0, $16, 0, $17, 0, $18, 0, $19, 0, $1a, 0, $1b, 0, $1c, 0, $1d, 0, $1e, 0, $1f, 0, $1f, 0, $1e, 0, $1d, 0, $1c, 0, $1b, 0, $1a, 0, $19, 0, $18, 0, $17, 0, $16, 0, $15, 0, $14, 0, $13, 0, $12, 0, $11, 0, $10, 0, $10, 0, $11, 0, $12, 0, $13, 0, $14, 0, $15, 0, $16, 0, $17, 0, $18, 0, $19, 0, $1a, 0, $1b, 0, $1c, 0, $1d, 0, $1e, 0, $1f, 0, $1f, 0, $1e, 0, $1d, 0, $1c, 0, $1b, 0, $1a, 0, $19, 0, $18, 0, $17, 0, $16, 0, $15, 0, $14, 0, $13, 0, $12, 0, $11, 0, $10, 0, $10, 0, $11, 0, $12, 0, $13, 0, $14, 0, $15, 0, $16, 0, $17, 0, $18, 0, $19, 0, $1a, 0, $1b, 0, $1c, 0, $1d, 0, $1e, 0, $1f, 0, $1f, 0, $1e, 0, $1d, 0, $1c, 0, $1b, 0, $1a, 0, $19, 0, $18, 0, $17, 0, $16, 0, $15, 0, $14, 0, $13, 0, $12, 0, $11, 0, $10, 0
