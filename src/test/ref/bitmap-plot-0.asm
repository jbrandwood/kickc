// Tests the simple bitmap plotter - and counts plots per frame in an IRQ
// Plots simple plots
/// @file
/// Commodore 64 Registers and Constants
/// @file
/// The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="bitmap-plot-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  /// Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  /// $D011 Control Register #1  Bit#5: BMM Turn Bitmap Mode on/off
  .const VICII_BMM = $20
  /// $D011 Control Register #1  Bit#4: DEN Switch VIC-II output on/off
  .const VICII_DEN = $10
  /// $D011 Control Register #1  Bit#3: RSEL Switch betweem 25 or 24 visible rows
  ///          RSEL|  Display window height   | First line  | Last line
  ///          ----+--------------------------+-------------+----------
  ///            0 | 24 text lines/192 pixels |   55 ($37)  | 246 ($f6)
  ///            1 | 25 text lines/200 pixels |   51 ($33)  | 250 ($fa)
  .const VICII_RSEL = 8
  /// VICII IRQ Status/Enable Raster
  // @see #IRQ_ENABLE #IRQ_STATUS
  ///  0 | RST| Reaching a certain raster line. The line is specified by writing
  ///    |    | to register 0xd012 and bit 7 of $d011 and internally stored by
  ///    |    | the VIC for the raster compare. The test for reaching the
  ///    |    | interrupt raster line is done in cycle 0 of every line (for line
  ///    |    | 0, in cycle 1).
  .const IRQ_RASTER = 1
  /// Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  /// RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  /// The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  /// $D012 RASTER Raster counter
  .label RASTER = $d012
  /// $D021 Background Color 0
  .label BG_COLOR = $d021
  /// $D011 Control Register #1
  /// - Bit#0-#2: YSCROLL Screen Soft Scroll Vertical
  /// - Bit#3: RSEL Switch betweem 25 or 24 visible rows
  ///          RSEL|  Display window height   | First line  | Last line
  ///          ----+--------------------------+-------------+----------
  ///            0 | 24 text lines/192 pixels |   55 ($37)  | 246 ($f6)
  ///            1 | 25 text lines/200 pixels |   51 ($33)  | 250 ($fa)
  /// - Bit#4: DEN Switch VIC-II output on/off
  /// - Bit#5: BMM Turn Bitmap Mode on/off
  /// - Bit#6: ECM Turn Extended Color Mode on/off
  /// - Bit#7: RST8 9th Bit for $D012 Rasterline counter
  /// Initial Value: %10011011
  .label VICII_CONTROL1 = $d011
  /// $D011 Control Register #1
  /// @see #VICII_CONTROL1
  .label D011 = $d011
  /// $D018 VIC-II base addresses
  // @see #VICII_MEMORY
  .label D018 = $d018
  /// VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  /// VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  /// Processor port data direction register
  .label PROCPORT_DDR = 0
  /// Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  /// The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  /// The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
  .label BITMAP = $2000
  .label SCREEN = $400
  // Counts frames - updated by the IRQ
  .label frame_cnt = $d
.segment Code
__start: {
    // volatile byte frame_cnt = 1
    lda #1
    sta.z frame_cnt
    jsr main
    rts
}
// Interrupt Routine counting frames
irq: {
    sta rega+1
    // *BG_COLOR = WHITE
    lda #WHITE
    sta BG_COLOR
    // if(frame_cnt)
    lda.z frame_cnt
    beq __b1
    // frame_cnt++;
    inc.z frame_cnt
  __b1:
    // *BG_COLOR = BLACK
    lda #BLACK
    sta BG_COLOR
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // }
  rega:
    lda #0
    rti
}
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>BITMAP)/4&$f
    .label x = 6
    .label y = $c
    .label vx = $a
    .label vy = 9
    // bitmap_init(BITMAP, SCREEN)
    jsr bitmap_init
    // bitmap_clear(BLACK, WHITE)
    jsr bitmap_clear
    // *D011 = VICII_BMM|VICII_DEN|VICII_RSEL|3
    lda #VICII_BMM|VICII_DEN|VICII_RSEL|3
    sta D011
    // *D018 = toD018(SCREEN, BITMAP)
    lda #toD0181_return
    sta D018
    // init_irq()
    jsr init_irq
    lda #1
    sta.z vy
    sta.z vx
    lda #>1
    sta.z vx+1
    sta.z y
    sta.z x
    sta.z x+1
  __b2:
    // bitmap_plot(x, y)
    ldx.z y
    jsr bitmap_plot
    // x += vx
    clc
    lda.z x
    adc.z vx
    sta.z x
    lda.z x+1
    adc.z vx+1
    sta.z x+1
    // y += vy
    lda.z y
    clc
    adc.z vy
    sta.z y
    // if(x==319 || x==0)
    lda.z x
    cmp #<$13f
    bne !+
    lda.z x+1
    cmp #>$13f
    beq __b5
  !:
    lda.z x
    ora.z x+1
    bne __b3
  __b5:
    // vx = -vx
    sec
    lda #0
    sbc.z vx
    sta.z vx
    lda #0
    sbc.z vx+1
    sta.z vx+1
  __b3:
    // if(y==199 || y==0)
    lda #$c7
    cmp.z y
    beq __b6
    lda.z y
    bne __b4
  __b6:
    // vy = -vy
    lda.z vy
    eor #$ff
    clc
    adc #1
    sta.z vy
  __b4:
    // plots_per_frame[frame_cnt]++;
    ldx.z frame_cnt
    inc plots_per_frame,x
    jmp __b2
}
// Initialize bitmap plotting tables
// void bitmap_init(char *gfx, char *screen)
bitmap_init: {
    .label __7 = 8
    .label yoffs = 4
    ldx #0
    lda #$80
  __b1:
    // bitmap_plot_bit[x] = bits
    sta bitmap_plot_bit,x
    // bits >>= 1
    lsr
    // if(bits==0)
    cmp #0
    bne __b2
    lda #$80
  __b2:
    // for(char x : 0..255)
    inx
    cpx #0
    bne __b1
    lda #<BITMAP
    sta.z yoffs
    lda #>BITMAP
    sta.z yoffs+1
    ldx #0
  __b3:
    // y&$7
    lda #7
    sax.z __7
    // BYTE0(yoffs)
    lda.z yoffs
    // y&$7 | BYTE0(yoffs)
    ora.z __7
    // bitmap_plot_ylo[y] = y&$7 | BYTE0(yoffs)
    sta bitmap_plot_ylo,x
    // BYTE1(yoffs)
    lda.z yoffs+1
    // bitmap_plot_yhi[y] = BYTE1(yoffs)
    sta bitmap_plot_yhi,x
    // if((y&$7)==7)
    lda #7
    cmp.z __7
    bne __b4
    // yoffs = yoffs + 40*8
    lda.z yoffs
    clc
    adc #<$28*8
    sta.z yoffs
    lda.z yoffs+1
    adc #>$28*8
    sta.z yoffs+1
  __b4:
    // for(char y : 0..255)
    inx
    cpx #0
    bne __b3
    // }
    rts
}
// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
// void bitmap_clear(char bgcol, char fgcol)
bitmap_clear: {
    .const col = WHITE*$10
    // memset(bitmap_screen, col, 1000uw)
    ldx #col
    lda #<SCREEN
    sta.z memset.str
    lda #>SCREEN
    sta.z memset.str+1
    lda #<$3e8
    sta.z memset.num
    lda #>$3e8
    sta.z memset.num+1
    jsr memset
    // memset(bitmap_gfx, 0, 8000uw)
    ldx #0
    lda #<BITMAP
    sta.z memset.str
    lda #>BITMAP
    sta.z memset.str+1
    lda #<$1f40
    sta.z memset.num
    lda #>$1f40
    sta.z memset.num+1
    jsr memset
    // }
    rts
}
// Setup the IRQ
init_irq: {
    // asm
    sei
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta.z PROCPORT
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // *VICII_CONTROL1 |=$80
    // Set raster line to $100
    lda #$80
    ora VICII_CONTROL1
    sta VICII_CONTROL1
    // *RASTER = $00
    lda #0
    sta RASTER
    // *IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // *HARDWARE_IRQ = &irq
    // Set the IRQ routine
    lda #<irq
    sta HARDWARE_IRQ
    lda #>irq
    sta HARDWARE_IRQ+1
    // asm
    cli
    // }
    rts
}
// Plot a single dot in the bitmap
// void bitmap_plot(__zp(6) unsigned int x, __register(X) char y)
bitmap_plot: {
    .label __1 = 4
    .label plotter = 2
    .label x = 6
    // MAKEWORD( bitmap_plot_yhi[y], bitmap_plot_ylo[y] )
    lda bitmap_plot_yhi,x
    sta.z plotter+1
    lda bitmap_plot_ylo,x
    sta.z plotter
    // x & $fff8
    lda.z x
    and #<$fff8
    sta.z __1
    lda.z x+1
    and #>$fff8
    sta.z __1+1
    // plotter += ( x & $fff8 )
    clc
    lda.z plotter
    adc.z __1
    sta.z plotter
    lda.z plotter+1
    adc.z __1+1
    sta.z plotter+1
    // BYTE0(x)
    ldx.z x
    // *plotter |= bitmap_plot_bit[BYTE0(x)]
    lda bitmap_plot_bit,x
    ldy #0
    ora (plotter),y
    sta (plotter),y
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(__zp(2) void *str, __register(X) char c, __zp(4) unsigned int num)
memset: {
    .label end = 4
    .label dst = 2
    .label num = 4
    .label str = 2
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // char* end = (char*)str + num
    clc
    lda.z end
    adc.z str
    sta.z end
    lda.z end+1
    adc.z str+1
    sta.z end+1
  __b2:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
  __breturn:
    // }
    rts
  __b3:
    // *dst = c
    txa
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
.segment Data
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  plots_per_frame: .fill $100, 0
