// Example program for the Commander X16
// Displays raster bars in the border
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="cx16-rasterbars.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const VERA_DCSEL = 2
  .const VERA_LINE = 2
  .const SIZEOF_CHAR = 1
  /// $9F25	CTRL Control
  /// Bit 7: Reset
  /// Bit 1: DCSEL
  /// Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
  /// $9F26	IEN		Interrupt Enable
  /// Bit 7: IRQ line (8)
  /// Bit 3: AFLOW
  /// Bit 2: SPRCOL
  /// Bit 1: LINE
  /// Bit 0: VSYNC
  .label VERA_IEN = $9f26
  /// $9F27	ISR     Interrupt Status
  /// Interrupts will be generated for the interrupt sources set in the lower 4 bits of IEN. ISR will indicate the interrupts that have occurred.
  /// Writing a 1 to one of the lower 3 bits in ISR will clear that interrupt status. AFLOW can only be cleared by filling the audio FIFO for at least 1/4.
  /// Bit 4-7: Sprite Collisions. This field indicates which groups of sprites have collided.
  /// Bit 3: AFLOW
  /// Bit 2: SPRCOL
  /// Bit 1: LINE
  /// Bit 0: VSYNC
  .label VERA_ISR = $9f27
  /// $9F28	IRQLINE_L	IRQ line (7:0)
  /// IRQ_LINE specifies at which line the LINE interrupt will be generated.
  /// Note that bit 8 of this value is present in the IEN register.
  /// For interlaced modes the interrupt will be generated each field and the bit 0 of IRQ_LINE is ignored.
  .label VERA_IRQLINE_L = $9f28
  /// $9F2C	DC_BORDER (DCSEL=0)	Border Color
  .label VERA_DC_BORDER = $9f2c
  /// $9F29	DC_HSTART (DCSEL=1)	Active Display H-Start (9:2)
  .label VERA_DC_HSTART = $9f29
  /// $9F2A	DC_HSTOP (DCSEL=1)	Active Display H-Stop (9:2)
  .label VERA_DC_HSTOP = $9f2a
  /// $9F2B	DC_VSTART (DCSEL=1)	Active Display V-Start (8:1)
  .label VERA_DC_VSTART = $9f2b
  /// $9F2C	DC_VSTOP (DCSEL=1)	Active Display V-Stop (8:1)
  .label VERA_DC_VSTOP = $9f2c
  /// $0314	(RAM) IRQ vector - The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  // The horizontal start
  .label hstart = 3
  // The horizontal stop
  .label hstop = 4
  // The vertical start
  .label vstart = 5
  // The vertical stop
  .label vstop = 6
  // The countdown
  .label cnt = 7
  // The sin idx
  .label sin_idx = 8
.segment Code
__start: {
    // volatile char hstart = 0/4
    lda #0
    sta.z hstart
    // volatile char hstop = 640/4
    lda #$280/4
    sta.z hstop
    // volatile char vstart = 0/2
    lda #0
    sta.z vstart
    // volatile char vstop = 480/2
    lda #$1e0/2
    sta.z vstop
    // volatile char cnt = 2
    lda #2
    sta.z cnt
    // volatile char sin_idx = 100
    lda #$64
    sta.z sin_idx
    jsr main
    rts
}
// LINE Interrupt Routine
irq_line: {
    .label idx = 2
    .label bar = 9
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
    // *VERA_DC_VSTART = vstart
    lda.z vstart
    sta VERA_DC_VSTART
    // *VERA_DC_VSTOP = vstop
    lda.z vstop
    sta VERA_DC_VSTOP
    // *VERA_CTRL &= ~VERA_DCSEL
    // Show color raster bars in the border
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    ldx #0
  __b2:
    // for(char l=0;l!=230;l++)
    cpx #$e6
    bne __b3
    // if(--cnt==0)
    dec.z cnt
    lda.z cnt
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
    // vstart++;
    inc.z vstart
    // vstop--;
    dec.z vstop
  __b1:
    // memset(BARS, 0, sizeof(BARS))
  // Animate the bars
    jsr memset
    // char idx = sin_idx--
    lda.z sin_idx
    sta.z idx
    dec.z sin_idx
    ldx #0
  __b13:
    // for(char b=0;b<8;b++)
    cpx #8
    bcc __b14
    // *VERA_ISR = VERA_LINE
    // Reset the LINE interrupt
    lda #VERA_LINE
    sta VERA_ISR
    // }
    jmp $e049
  __b14:
    // char * bar = BARS + SIN[idx]
    ldy.z idx
    lda SIN,y
    clc
    adc #<BARS
    sta.z bar
    lda #>BARS
    adc #0
    sta.z bar+1
    ldy #0
  __b16:
    // for(char i=0;i<sizeof(BAR);i++)
    cpy #$20*SIZEOF_CHAR
    bcc __b17
    // idx += 13
    lda #$d
    clc
    adc.z idx
    sta.z idx
    // for(char b=0;b<8;b++)
    inx
    jmp __b13
  __b17:
    // bar[i] = BAR[i]
    lda BAR,y
    sta (bar),y
    // for(char i=0;i<sizeof(BAR);i++)
    iny
    jmp __b16
  __b3:
    // *VERA_DC_BORDER = BARS[l]
    lda BARS,x
    sta VERA_DC_BORDER
    lda #0
  __b5:
    // for(char i=0;i<24;i++)
    cmp #$18
    bcc __b6
    // *VERA_DC_BORDER = 0
    // Wait exactly long enough to go to the next raster line
    lda #0
    sta VERA_DC_BORDER
  __b8:
    // for(char i=0;i<23;i++)
    cmp #$17
    bcc __b9
    // asm
    // Wait exactly long enough to go to the next raster line
    nop
    nop
    // for(char l=0;l!=230;l++)
    inx
    jmp __b2
  __b9:
    // for(char i=0;i<23;i++)
    inc
    jmp __b8
  __b6:
    // for(char i=0;i<24;i++)
    inc
    jmp __b5
}
main: {
    // asm
    sei
    // *KERNEL_IRQ = &irq_line
    lda #<irq_line
    sta KERNEL_IRQ
    lda #>irq_line
    sta KERNEL_IRQ+1
    // *VERA_IEN = VERA_LINE
    lda #VERA_LINE
    sta VERA_IEN
    // *VERA_IRQLINE_L = 5
    lda #5
    sta VERA_IRQLINE_L
    // asm
    cli
  __b1:
    jmp __b1
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
memset: {
    .const num = $e6*SIZEOF_CHAR
    .const c = 0
    .label str = BARS
    .label end = str+num
    .label dst = 9
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
.segment Data
  .align $100
SIN:
.fill 256, 99+99*sin(i*2*PI/256)

  .align $100
  BARS: .fill $e6, 0
  .align $100
  BAR: .byte $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1b, $1c, $1d, $1e, $1f, $1f, $1e, $1d, $1c, $1b, $1a, $19, $18, $17, $16, $15, $14, $13, $12, $11, $10
